-- ============================================================
--  lua/akhilesh/plugins/lualine.lua
--  Best-in-class statusline + winbar
-- ============================================================

local M = {
  "nvim-lualine/lualine.nvim",
  lazy = false,
  enabled = true,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "folke/sidekick.nvim",
  },
}

-- ── Spinner for CodeCompanion ────────────────────────────────
local function make_codecompanion_component()
  local comp = require("lualine.component"):extend()
  comp.processing = false
  comp.spinner_index = 1

  local frames = { "⠋","⠙","⠹","⠸","⠼","⠴","⠦","⠧","⠇","⠏" }

  function comp:init(options)
    comp.super.init(self, options)
    local group = vim.api.nvim_create_augroup("CodeCompanionLualine", { clear = true })
    vim.api.nvim_create_autocmd("User", {
      pattern = "CodeCompanionRequest*",
      group   = group,
      callback = function(ev)
        self.processing = ev.match == "CodeCompanionRequestStarted"
      end,
    })
  end

  function comp:update_status()
    if not self.processing then return nil end
    self.spinner_index = (self.spinner_index % #frames) + 1
    return frames[self.spinner_index]
  end

  return comp
end

-- ── Scrollbar ────────────────────────────────────────────────
local function make_scrollbar_component()
  local comp = require("lualine.component"):extend()
  local blocks = { "▁","▂","▃","▄","▅","▆","▇","█" }

  function comp:update_status()
    local cur   = vim.api.nvim_win_get_cursor(0)[1]
    local total = vim.api.nvim_buf_line_count(0)
    if total == 0 or cur > total then return "" end
    local idx = math.floor(cur / total * 7) + 1
    return string.rep(blocks[idx], 2)
  end

  return comp
end

-- ── Colour helpers ───────────────────────────────────────────
local function resolve_colors()
  -- Try known colour-scheme modules in priority order
  local schemes = {
    { pkg = "tokyonight",    fn = function() return require("tokyonight.colors").setup({ transform = true }) end },
    { pkg = "catppuccin",    fn = function()
        local p = require("catppuccin.palettes").get_palette()
        return { bg=p.base, fg=p.text, red=p.red, green=p.green, blue=p.blue,
                 yellow=p.yellow, cyan=p.teal, orange=p.peach, purple=p.mauve,
                 teal=p.teal, violet=p.lavender }
      end },
    { pkg = "rose-pine",     fn = function()
        local p = require("rose-pine.palette")
        return { bg=p.base, fg=p.text, red=p.love, green=p.pine, blue=p.foam,
                 yellow=p.gold, cyan=p.foam, orange=p.rose, purple=p.iris,
                 teal=p.pine, violet=p.iris }
      end },
    { pkg = "cyberdream",    fn = function() return require("cyberdream.colors") end },
  }

  for _, s in ipairs(schemes) do
    if package.loaded[s.pkg] then
      local ok, c = pcall(s.fn)
      if ok and c then return c end
    end
  end

  -- Fallback: derive from active highlight groups
  local function hl(group, attr)
    local ok, val = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
    if not ok or not val[attr] then return "#888888" end
    return string.format("#%06x", val[attr])
  end

  return {
    bg     = hl("Normal",      "bg"),
    fg     = hl("Normal",      "fg"),
    red    = hl("DiagnosticError", "fg"),
    green  = hl("String",      "fg"),
    blue   = hl("Function",    "fg"),
    yellow = hl("Type",        "fg"),
    cyan   = hl("Keyword",     "fg"),
    orange = hl("Title",       "fg"),
    purple = hl("Statement",   "fg"),
    teal   = hl("Keyword",     "fg"),
    violet = hl("Special",     "fg"),
  }
end

-- ── Helpers ──────────────────────────────────────────────────
local function shorten_path(path, sep)
  return path:gsub(
    string.format("([^%s])[^%s]+%%%s", sep, sep, sep),
    "%1" .. sep, 1
  )
end

local function path_count(s, sep)
  return select(2, s:gsub(sep, ""))
end

-- ── Main config ──────────────────────────────────────────────
function M.config()
  local c              = resolve_colors()
  local lazy_status    = require("lazy.status")
  local codecompanion  = make_codecompanion_component()
  local scrollbar      = make_scrollbar_component()

  -- Mode icon with colour
  local mode_colors = {
    n  = c.green,  i  = c.red,    v  = c.blue,
    V  = c.blue,   ["\22"] = c.blue, c = c.purple,
    no = c.red,    s  = c.orange, S  = c.orange,
    ic = c.yellow, R  = c.purple, Rv = c.purple,
    cv = c.red,    ce = c.red,    r  = c.cyan,
    rm = c.cyan,   ["r?"] = c.cyan,
    ["!"] = c.red, t  = c.green,
  }

  local function mode_icon()
    local icons = {
      n="󰋜", i="󰙏", v="󰒉", V="󰒉", ["\22"]="󰒉",
      c="󰘳", R="󰑖", t="󰆍",
    }
    return icons[vim.fn.mode()] or "󰋜"
  end

  -- Current dir breadcrumb
  local SHORTEN_TARGET = 40
  local function dir_breadcrumb()
    local dir  = vim.fn.expand("%:p:h")
    local cwd  = vim.fn.getcwd()
    if dir == cwd then return "󰉋 root" end
    local width = vim.go.columns
    local data  = vim.fn.fnamemodify(dir, ":~:.")
    for _ = 0, path_count(data, "/") do
      if width <= 84 or #data > (width - SHORTEN_TARGET) then
        data = shorten_path(data, "/")
      end
    end
    return "󰉋 " .. data
  end

  -- LSP names + filetype icon
  local function lsp_info()
    local clients = vim.lsp.get_clients({ bufnr = vim.fn.bufnr() })
    local ft      = vim.api.nvim_get_option_value("filetype", { buf = 0 })
    local icon    = require("nvim-web-devicons").get_icon_by_filetype(ft) or ""
    if clients and #clients > 0 then
      local names = vim.tbl_map(function(l) return l.name end, clients)
      return string.format("%s %s", table.concat(names, " "), icon)
    end
    return icon
  end

  local function lsp_color()
    local ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
    local _, col = require("nvim-web-devicons").get_icon_cterm_color_by_filetype(ft)
    return { fg = col or c.fg, bg = c.bg }
  end

  -- Sidekick AI status
  local function sidekick_icon()
    local ok, status = pcall(require, "sidekick.status")
    if not ok then return "" end
    local s = status.get()
    return s and " " or ""
  end

  local function sidekick_color()
    local ok, status = pcall(require, "sidekick.status")
    if not ok then return "Normal" end
    local s = status.get()
    if not s then return "Normal" end
    return s.kind == "Error" and "DiagnosticError"
        or s.busy          and "DiagnosticWarn"
        or "Special"
  end

  local function sidekick_cond()
    local ok, status = pcall(require, "sidekick.status")
    return ok and status.get() ~= nil
  end

  -- Git diff source from gitsigns
  local function gitsigns_source()
    local gs = vim.b.gitsigns_status_dict
    if gs then
      return { added = gs.added, modified = gs.changed, removed = gs.removed }
    end
  end

  -- Noice helpers
  local function noice_cmd()
    return package.loaded["noice"] and require("noice").api.status.command.get() or ""
  end
  local function noice_cmd_cond()
    return package.loaded["noice"] and require("noice").api.status.command.has()
  end
  local function noice_mode()
    return package.loaded["noice"] and require("noice").api.status.mode.get() or ""
  end
  local function noice_mode_cond()
    return package.loaded["noice"] and require("noice").api.status.mode.has()
  end

  -- ── Setup ──────────────────────────────────────────────────
  require("lualine").setup({
    options = {
      icons_enabled        = true,
      globalstatus         = true,
      always_divide_middle = true,
      component_separators = { left = "", right = "" },
      section_separators   = { left = "", right = "" },
      refresh = { statusline = 100, tabline = 1000, winbar = 500 },
      theme = {
        normal   = { a = { bg = c.bg, fg = c.fg }, b = { bg = c.bg, fg = c.fg }, c = { bg = c.bg, fg = c.fg } },
        insert   = { a = { bg = c.bg, fg = c.red } },
        visual   = { a = { bg = c.bg, fg = c.blue } },
        replace  = { a = { bg = c.bg, fg = c.purple } },
        command  = { a = { bg = c.bg, fg = c.cyan } },
        inactive = { a = { bg = c.bg, fg = c.fg }, b = { bg = c.bg, fg = c.fg }, c = { bg = c.bg, fg = c.fg } },
      },
      disabled_filetypes = {
        statusline = { "alpha", "dashboard", "starter" },
        winbar     = { "alpha", "dashboard", "starter", "edgy", "toggleterm",
                       "Trouble", "spectre_panel", "qf", "noice", "dbui" },
      },
    },

    -- ── Statusline ───────────────────────────────────────────
    sections = {
      -- A: mode icon
      lualine_a = {
        {
          function() return " " .. mode_icon() .. " " end,
          color = function()
            return { fg = mode_colors[vim.fn.mode()] or c.fg, bg = c.bg, gui = "bold" }
          end,
          padding = 0,
        },
      },

      -- B: dir + filename
      lualine_b = {
        {
          dir_breadcrumb,
          cond  = function() return vim.fn.empty(vim.fn.expand("%:t")) ~= 1 end,
          color = { fg = c.violet, bg = c.bg },
          padding = { left = 1, right = 0 },
        },
        {
          "filename",
          symbols      = { modified = " ●", readonly = " 󰌾", unnamed = " [No Name]" },
          file_status  = true,
          path         = 0,
          color        = { fg = c.fg, bg = c.bg, gui = "bold" },
          cond         = function() return vim.fn.empty(vim.fn.expand("%:t")) ~= 1 end,
        },
      },

      -- C: centre spacer + sidekick AI
      lualine_c = {
        { function() return "%=" end, padding = 0 },
        {
          sidekick_icon,
          color = sidekick_color,
          cond  = sidekick_cond,
        },
      },

      -- X: noice, diagnostics, CodeCompanion, LSP
      lualine_x = {
        -- Sidekick CLI count
        {
          function()
            local ok, status = pcall(require, "sidekick.status")
            if not ok then return "" end
            local cli = status.cli()
            return " " .. (#cli > 1 and tostring(#cli) or "")
          end,
          cond  = function()
            local ok, status = pcall(require, "sidekick.status")
            return ok and #status.cli() > 0
          end,
          color = "Special",
        },

        -- CodeCompanion spinner
        { codecompanion, color = { fg = c.orange, bg = c.bg } },

        -- Noice command
        {
          noice_cmd,
          cond  = noice_cmd_cond,
          color = { bg = c.teal, fg = c.bg, gui = "bold" },
        },

        -- Noice mode
        {
          noice_mode,
          cond  = noice_mode_cond,
          color = { bg = c.orange, fg = c.bg, gui = "bold" },
        },

        -- Diagnostics
        {
          "diagnostics",
          sources          = { "nvim_lsp", "nvim_diagnostic" },
          update_in_insert = true,
          symbols          = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
          diagnostics_color = {
            error = { fg = c.red },
            warn  = { fg = c.yellow },
            info  = { fg = c.cyan },
            hint  = { fg = c.green },
          },
          colored = true,
          color   = { bg = c.bg },
        },

        -- LSP names + icon
        {
          lsp_info,
          on_click = function() vim.cmd("LspInfo") end,
          color    = lsp_color,
        },
      },

      -- Y: lazy updates, fileformat, encoding
      lualine_y = {
        {
          function() return " ﮮ " end,
          cond  = lazy_status.has_updates,
          color = { fg = c.cyan, bg = c.bg },
          on_click = function() vim.cmd("Lazy") end,
        },
        {
          "fileformat",
          symbols = { unix = "󰌽", dos = "󰍲", mac = "" },
          color   = { fg = c.purple, bg = c.bg, gui = "bold" },
        },
        {
          "encoding",
          fmt   = string.upper,
          color = { fg = c.blue, bg = c.bg, gui = "bold" },
        },
      },

      -- Z: column + scrollbar
      lualine_z = {
        {
          function() return "󰕭 %-2v" end,
          color = { fg = c.yellow, bg = c.bg, gui = "bold" },
        },
        {
          scrollbar,
          color   = { fg = c.cyan, bg = c.bg },
          padding = 0,
        },
      },
    },

    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { { "filename", color = { fg = c.fg, bg = c.bg } } },
      lualine_x = { { "location", color = { fg = c.fg, bg = c.bg } } },
      lualine_y = {},
      lualine_z = {},
    },

    tabline = {},

    -- ── Winbar ───────────────────────────────────────────────
    winbar = {
      lualine_a = {
        {
          function()
            local ok, dropbar = pcall(vim.fn["dropbar#get_dropbar_str"])
            return ok and dropbar or ""
          end,
          color = { bg = c.bg, fg = c.fg },
        },
      },
      lualine_b = {},
      lualine_c = {
        { function() return "%=" end, padding = 0 },
      },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {
        -- Branch name
        {
          "b:gitsigns_head",
          icon  = "󰘬",
          color = { bg = c.bg, fg = c.yellow, gui = "bold" },
        },
        -- Git diff
        {
          "diff",
          symbols = { added = " ", modified = " ", removed = " " },
          diff_color = {
            added    = { fg = c.green },
            modified = { fg = c.orange },
            removed  = { fg = c.red },
          },
          source   = gitsigns_source,
          on_click = function() vim.cmd("DiffviewOpen") end,
          color    = { bg = c.bg },
        },
      },
    },

    inactive_winbar = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {
        { function() return "%=" end, padding = 0 },
        {
          "filename",
          color = { fg = c.fg, bg = c.bg },
          path  = 1,
        },
      },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },

    extensions = {
      "mason", "lazy", "quickfix", "toggleterm", "trouble",
    },
  })
end

return M
