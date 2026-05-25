-- ============================================================
--  lua/akhilesh/plugins/luaLine.lua
--  Tokyonight Night-aligned Lualine
--  Modern powerline statusline with refined sections
-- ============================================================

local M = {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "folke/noice.nvim",
    "folke/sidekick.nvim",
    "lewis6991/gitsigns.nvim",
  },
}

function M.config()
  local lualine = require("lualine")

  -- ==========================================================
  -- TOKYONIGHT NIGHT PALETTE
  -- ==========================================================

  local c = {
    bg          = "#1a1b26",
    bg_dark     = "#16161e",
    bg_highlight= "#292e42",
    fg          = "#c0caf5",
    fg_dark     = "#a9b1d6",
    fg_gutter   = "#3b4261",
    black       = "#15161e",
    white       = "#ffffff",
    blue        = "#7aa2f7",
    cyan        = "#7dcfff",
    teal        = "#1abc9c",
    green       = "#9ece6a",
    yellow      = "#e0af68",
    orange      = "#ff9e64",
    red         = "#f7768e",
    purple      = "#bb9af7",
    magenta     = "#c678dd",
    comment     = "#565f89",
  }

  -- ==========================================================
  -- MODE COLORS
  -- ==========================================================

  local mode_colors = {
    n      = c.blue,
    i      = c.green,
    v      = c.purple,
    V      = c.purple,
    [""] = c.purple,
    c      = c.yellow,
    no     = c.red,
    s      = c.orange,
    S      = c.orange,
    ic     = c.yellow,
    R      = c.red,
    Rv     = c.red,
    cv     = c.red,
    ce     = c.red,
    r      = c.cyan,
    rm     = c.cyan,
    ["r?"] = c.cyan,
    ["!"]  = c.red,
    t      = c.teal,
  }

  local mode_names = {
    n      = "NORMAL",
    i      = "INSERT",
    v      = "VISUAL",
    V      = "V-LINE",
    [""] = "V-BLOCK",
    c      = "COMMAND",
    R      = "REPLACE",
    t      = "TERMINAL",
    s      = "SELECT",
    S      = "S-LINE",
  }

  -- ==========================================================
  -- COMPONENTS
  -- ==========================================================

  local function mode_label()
    return mode_names[vim.fn.mode()] or vim.fn.mode():upper()
  end

  local function mode_color()
    return {
      fg = c.bg_dark,
      bg = mode_colors[vim.fn.mode()] or c.blue,
      gui = "bold",
    }
  end

  local function mode_color_inverse()
    return {
      fg = mode_colors[vim.fn.mode()] or c.blue,
      bg = c.bg_dark,
    }
  end

  -- Scrollbar block (8 levels)
  local function scrollbar()
    local current_line = vim.fn.line(".")
    local total_lines  = vim.fn.line("$")
    local chars = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" }
    local index = math.max(1, math.ceil((current_line / total_lines) * #chars))
    return chars[index] .. chars[index]
  end

  -- LSP clients
  local function lsp_clients()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if next(clients) == nil then
      return "󱏎 No LSP"
    end
    local names = {}
    for _, client in pairs(clients) do
      table.insert(names, client.name)
    end
    return "󰒋 " .. table.concat(names, " · ")
  end

  -- File size
  local function filesize()
    local size = vim.fn.getfsize(vim.fn.expand("%:p"))
    if size < 0 then return "" end
    if size < 1024 then
      return size .. "B"
    elseif size < 1048576 then
      return string.format("%.1fK", size / 1024)
    else
      return string.format("%.1fM", size / 1048576)
    end
  end

  -- Clock
  local function clock()
    return "󰥔 " .. os.date("%H:%M")
  end

  -- Noice cmdline
  local function noice_command()
    local ok, noice = pcall(require, "noice")
    if not ok then return "" end
    if noice.api.status.command.has() then
      return noice.api.status.command.get()
    end
    return ""
  end

  -- Noice macro recording
  local function macro_recording()
    local ok, noice = pcall(require, "noice")
    if not ok then return "" end
    if noice.api.status.mode.has() then
      return noice.api.status.mode.get()
    end
    return ""
  end

  -- Gitsigns diff source
  local function diff_source()
    local gs = vim.b.gitsigns_status_dict
    if gs then
      return {
        added    = gs.added,
        modified = gs.changed,
        removed  = gs.removed,
      }
    end
  end

  -- Sidekick AI status
  local function sidekick_status()
    local ok, status = pcall(require, "sidekick.status")
    if not ok then return "" end
    local s = status.get()
    if not s then return "" end
    return "󰚩 AI"
  end

  -- Search count
  local function search_count()
    if vim.v.hlsearch == 0 then return "" end
    local ok, count = pcall(vim.fn.searchcount, { recompute = true })
    if not ok or count.current == nil or count.total == 0 then return "" end
    return string.format(" %d/%d", count.current, count.total)
  end

  -- ==========================================================
  -- CUSTOM THEME
  -- ==========================================================

  local theme = {
    normal = {
      a = { fg = c.bg_dark, bg = c.blue, gui = "bold" },
      b = { fg = c.blue, bg = c.bg_highlight },
      c = { fg = c.fg, bg = c.bg_dark },
    },
    insert  = { a = { fg = c.bg_dark, bg = c.green,  gui = "bold" } },
    visual  = { a = { fg = c.bg_dark, bg = c.purple, gui = "bold" } },
    command = { a = { fg = c.bg_dark, bg = c.yellow, gui = "bold" } },
    replace = { a = { fg = c.bg_dark, bg = c.red,    gui = "bold" } },
    terminal= { a = { fg = c.bg_dark, bg = c.teal,   gui = "bold" } },
    inactive= {
      a = { fg = c.comment, bg = c.bg_dark },
      b = { fg = c.comment, bg = c.bg_dark },
      c = { fg = c.comment, bg = c.bg_dark },
    },
  }

  -- ==========================================================
  -- SETUP
  -- ==========================================================

  lualine.setup({
    options = {
      theme = theme,
      globalstatus = true,
      icons_enabled = true,
      always_divide_middle = true,

      component_separators = { left = "", right = "" },
      section_separators   = { left = "", right = "" },

      disabled_filetypes = {
        statusline = {
          "dashboard",
          "alpha",
          "starter",
          "snacks_dashboard",
        },
        winbar = {},
      },

      refresh = {
        statusline = 100,
        tabline    = 100,
        winbar     = 100,
      },
    },

    sections = {
      -- ----- MODE -----
      lualine_a = {
        {
          mode_label,
          color = mode_color,
          padding = { left = 1, right = 1 },
          icon = { "", align = "left" },
        },
      },

      -- ----- BRANCH + FILE -----
      lualine_b = {
        {
          "branch",
          icon = "",
          color = { fg = c.purple, bg = c.bg_highlight, gui = "bold" },
        },
        {
          "filename",
          path = 1,
          symbols = {
            modified = " ●",
            readonly = " ",
            unnamed  = " [No Name]",
            newfile  = " ",
          },
          color = { fg = c.fg, bg = c.bg_highlight },
          separator = { right = "" },
        },
      },

      -- ----- DIAGNOSTICS / DIFF / MACRO -----
      lualine_c = {
        {
          "diff",
          source = diff_source,
          symbols = {
            added    = "  ",
            modified = "  ",
            removed  = "  ",
          },
          diff_color = {
            added    = { fg = c.green },
            modified = { fg = c.yellow },
            removed  = { fg = c.red },
          },
        },
        {
          "diagnostics",
          sources = { "nvim_lsp" },
          symbols = {
            error = " ",
            warn  = " ",
            info  = " ",
            hint  = "󰌵 ",
          },
          diagnostics_color = {
            error = { fg = c.red },
            warn  = { fg = c.yellow },
            info  = { fg = c.cyan },
            hint  = { fg = c.green },
          },
        },
        {
          macro_recording,
          color = { fg = c.red, bg = c.bg_dark, gui = "bold" },
        },
        {
          search_count,
          color = { fg = c.orange, bg = c.bg_dark, gui = "bold" },
        },
        {
          noice_command,
          color = { fg = c.yellow, bg = c.bg_dark, gui = "bold" },
        },
      },

      -- ----- AI / LSP / META -----
      lualine_x = {
        {
          sidekick_status,
          color = { fg = c.green, bg = c.bg_dark, gui = "bold" },
        },
        {
          lsp_clients,
          color = { fg = c.cyan, bg = c.bg_dark },
        },
        {
          filesize,
          icon = "󰈚",
          color = { fg = c.orange, bg = c.bg_dark },
        },
        {
          "encoding",
          fmt = string.upper,
          color = { fg = c.comment, bg = c.bg_dark },
        },
        {
          "fileformat",
          symbols = {
            unix = "󰌽",
            dos  = "󰍲",
            mac  = "󰀵",
          },
          color = { fg = c.comment, bg = c.bg_dark },
        },
        {
          "filetype",
          colored = true,
          icon_only = false,
          color = { bg = c.bg_dark },
        },
      },

      -- ----- POSITION -----
      lualine_y = {
        {
          "progress",
          color = mode_color_inverse,
          separator = { left = "" },
        },
        {
          "location",
          color = { fg = c.bg_dark, bg = c.fg_dark, gui = "bold" },
        },
        {
          clock,
          color = { fg = c.bg_dark, bg = c.purple, gui = "bold" },
        },
      },

      -- ----- SCROLLBAR -----
      lualine_z = {
        {
          scrollbar,
          color = mode_color,
          padding = 0,
        },
      },
    },

    -- ========================================================
    -- INACTIVE
    -- ========================================================
    inactive_sections = {
      lualine_a = {},
      lualine_b = {
        {
          "filename",
          path = 1,
          symbols = { modified = " ●", readonly = " " },
          color = { fg = c.comment },
        },
      },
      lualine_c = {},
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },

    extensions = {
      "lazy",
      "mason",
      "toggleterm",
      "quickfix",
      "trouble",
      "oil",
      "fugitive",
      "nvim-dap-ui",
    },
  })
end

return M
