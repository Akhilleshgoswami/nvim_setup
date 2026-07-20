--- Umbra — a premium handcrafted Neovim colorscheme.
--- Modular architecture: palette → groups → treesitter → lsp → plugins.
---
--- Usage:
---   require("themes.umbra").setup({ transparent = true })
---   vim.cmd.colorscheme("umbra")

local config = require("themes.umbra.config")
local terminal = require("themes.umbra.terminal")

local M = {}

M.config = config.merge()
M.base_palette = require("themes.umbra.palette")
M.palette = M.base_palette

--- Resolved palette after the last apply (for lualine, dashboard, etc.).
M.resolved = nil

---@param opts? UmbraConfig
function M.setup(opts)
  M.config = config.merge(opts)
end

--- Paint every highlight group. Called by `:colorscheme umbra`.
function M.apply()
  if vim.g.colors_name then
    vim.cmd("hi clear")
  end
  vim.o.termguicolors = true
  vim.o.background = "dark"
  vim.g.colors_name = "umbra"

  local groups, resolved = require("themes.umbra.highlights")(M.base_palette, M.config)
  M.resolved = resolved
  M.palette = resolved

  local set_hl = vim.api.nvim_set_hl
  for group, spec in pairs(groups) do
    set_hl(0, group, spec)
  end

  terminal.apply(resolved, M.config.terminal)

  -- Sync design-system color layer with the resolved palette.
  pcall(function()
    package.loaded["umbra.color"] = nil
    require("umbra.color")
  end)
end

--- Lualine segment theme derived from the active palette.
function M.lualine()
  local p = M.resolved or M.palette
  local a = p.accent
  local function seg(accent)
    return {
      a = { fg = p.bg.dark, bg = accent, gui = "bold" },
      b = { fg = p.fg.dim, bg = p.bg.overlay },
      c = { fg = p.fg.muted, bg = p.none },
    }
  end
  return {
    normal = seg(a.indigo),
    insert = seg(a.emerald),
    visual = seg(a.purple),
    replace = seg(a.rose),
    command = seg(a.orange),
    terminal = seg(a.cyan),
    inactive = {
      a = { fg = p.fg.muted, bg = p.none },
      b = { fg = p.fg.muted, bg = p.none },
      c = { fg = p.fg.faint, bg = p.none },
    },
  }
end

return M
