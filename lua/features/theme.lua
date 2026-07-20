-- Runtime theme management: a picker (`:Theme`), persistence across restarts,
-- and lazy-loading so alternate colorschemes never touch startup time.
--
-- Umbra is the default. Any colorscheme you select is remembered in a small
-- state file and re-applied on the next launch. Because the theme plugins are
-- lazy (see plugins/themes.lua), we only load the one that's actually in use.

local M = {}

local state_file = vim.fn.stdpath("state") .. "/umbra-theme.txt"

-- Every alternate theme plugin, by the name lazy.nvim knows it as. The picker
-- loads these on demand so all their colorschemes show up (with live preview).
M.theme_plugins = {
  "catppuccin",
  "tokyonight.nvim",
  "kanagawa.nvim",
  "rose-pine",
  "gruvbox.nvim",
  "everforest",
  "onedarkpro.nvim",
  "nightfox.nvim",
  "oxocarbon.nvim",
  "nord.nvim",
}

-- Map a colorscheme name to the plugin that provides it, so we can lazy-load it
-- before applying. Exact names win first (keeps `nord` and `nordfox` distinct),
-- then prefixes cover each family's variants (catppuccin-mocha, tokyonight-moon…).
local exact = {
  nord = "nord.nvim",
  gruvbox = "gruvbox.nvim",
  everforest = "everforest",
  oxocarbon = "oxocarbon.nvim",
  nightfox = "nightfox.nvim",
  dayfox = "nightfox.nvim",
  dawnfox = "nightfox.nvim",
  duskfox = "nightfox.nvim",
  nordfox = "nightfox.nvim",
  terafox = "nightfox.nvim",
  carbonfox = "nightfox.nvim",
}

local prefixes = {
  { "catppuccin", "catppuccin" },
  { "tokyonight", "tokyonight.nvim" },
  { "kanagawa", "kanagawa.nvim" },
  { "rose%-pine", "rose-pine" },
  { "onedark", "onedarkpro.nvim" },
  { "onelight", "onedarkpro.nvim" },
}

local function plugin_for(name)
  if not name or name == "" or name == "umbra" then
    return nil
  end
  if exact[name] then
    return exact[name]
  end
  for _, entry in ipairs(prefixes) do
    if name:find("^" .. entry[1]) then
      return entry[2]
    end
  end
  return nil
end

local function load_plugin(name)
  local plugin = plugin_for(name)
  if plugin then
    pcall(function()
      require("lazy").load({ plugins = { plugin } })
    end)
  end
end

-- Persist the active colorscheme (called from the ColorScheme autocmd).
function M.save(name)
  if not name or name == "" then
    return
  end
  local f = io.open(state_file, "w")
  if f then
    f:write(name)
    f:close()
  end
end

-- Read the last saved colorscheme, or nil when none has been chosen yet.
function M.read()
  local f = io.open(state_file, "r")
  if not f then
    return nil
  end
  local name = f:read("*l")
  f:close()
  return (name and name ~= "") and name or nil
end

-- Apply a colorscheme, lazy-loading its plugin first and falling back to Umbra
-- if the requested scheme isn't available.
function M.apply(name)
  name = name or "umbra"
  load_plugin(name)
  if not pcall(vim.cmd.colorscheme, name) then
    pcall(vim.cmd.colorscheme, "umbra")
  end
end

-- Restore the saved theme at startup (defaults to Umbra).
function M.load_saved()
  M.apply(M.read() or "umbra")
end

-- Open the theme picker: load every alternate theme so it appears in the list,
-- then hand off to Telescope's colorscheme picker with live preview.
function M.pick()
  pcall(function()
    require("lazy").load({ plugins = M.theme_plugins })
  end)
  local ok, builtin = pcall(require, "telescope.builtin")
  if ok then
    builtin.colorscheme({ enable_preview = true })
  else
    -- Graceful fallback if Telescope isn't present.
    vim.ui.select(vim.fn.getcompletion("", "color"), { prompt = "Theme" }, function(choice)
      if choice then
        M.apply(choice)
      end
    end)
  end
end

-- Recolor the gitsigns gutter to VS Code semantics (green add, blue change, red
-- delete), adapting to whatever theme is active. Reads the active theme's own
-- diff/diagnostic colors, falling back to Umbra's semantic tokens.
local function recolor_gitsigns()
  local hl = require("umbra.hl")
  local color = require("umbra.color")
  local add = hl.first_fg({ "Added", "diffAdded", "@diff.plus", "DiagnosticOk", "String" }, color.git.add)
  local change = hl.first_fg({ "DiagnosticInfo", "@diff.delta", "Function" }, color.secondary)
  local delete = hl.first_fg({ "Removed", "diffRemoved", "@diff.minus", "DiagnosticError" }, color.git.delete)
  local set = vim.api.nvim_set_hl
  set(0, "GitSignsAdd", { fg = add })
  set(0, "GitSignsChange", { fg = change })
  set(0, "GitSignsDelete", { fg = delete })
  set(0, "GitSignsChangedelete", { fg = change })
  set(0, "GitSignsTopdelete", { fg = delete })
  set(0, "GitSignsUntracked", { fg = add })
  set(0, "GitSignsAddNr", { fg = add })
  set(0, "GitSignsChangeNr", { fg = change })
  set(0, "GitSignsDeleteNr", { fg = delete })
end

-- Recolor DAP signs from semantic tokens, adapting to the active theme.
local function recolor_dap()
  local hl = require("umbra.hl")
  local color = require("umbra.color")
  local set = vim.api.nvim_set_hl
  set(0, "DapBreakpoint", { fg = hl.first_fg({ "DiagnosticError" }, color.error) })
  set(0, "DapBreakpointCondition", { fg = hl.first_fg({ "DiagnosticWarn" }, color.warning) })
  set(0, "DapLogPoint", { fg = hl.first_fg({ "DiagnosticInfo" }, color.info) })
  set(0, "DapBreakpointRejected", { fg = hl.first_fg({ "NonText", "Comment" }, color.muted) })
  set(0, "DapStopped", { fg = hl.first_fg({ "DiagnosticOk", "String" }, color.success) })
  set(0, "DapStoppedLine", { bg = color.stopped_line })
end

M.recolor_gitsigns = recolor_gitsigns
M.recolor_dap = recolor_dap

-- Keep a handful of bespoke highlight groups looking right under *any* theme.
-- Umbra defines these explicitly; for other themes we link them to sensible
-- built-ins (default = true means we never clobber a theme that defines them).
function M.fix_custom_highlights()
  if vim.g.colors_name == "umbra" then
    return
  end
  local links = {
    AlphaHeader = "Function",
    AlphaHeaderLabel = "Label",
    AlphaButtons = "Normal",
    AlphaButtonIcon = "Special",
    AlphaShortcut = "Keyword",
    AlphaFooter = "Comment",
    AlphaProject = "String",
  }
  for group, target in pairs(links) do
    pcall(vim.api.nvim_set_hl, 0, group, { link = target, default = true })
  end
end

function M.setup()
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("umbra_theme", { clear = true }),
    callback = function(ev)
      M.save(ev.match or vim.g.colors_name)
      M.fix_custom_highlights()
      -- One reactor owns every theme-derived recolor: gutter, debugger, and the
      -- WezTerm mirror. (No plugin registers its own ColorScheme handler.)
      recolor_gitsigns()
      recolor_dap()
      pcall(function()
        require("features.wezterm").sync_theme_debounced()
      end)
    end,
  })

  vim.api.nvim_create_user_command("Theme", M.pick, { desc = "Pick a colorscheme (with preview)" })

  vim.keymap.set("n", "<leader>ut", M.pick, { desc = "Theme picker" })
end

return M
