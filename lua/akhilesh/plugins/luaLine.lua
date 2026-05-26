-- ============================================================
--  lua/akhilesh/plugins/luaLine.lua
--  CYBERPUNK / GEEKY / HACKER STATUSLINE
--  Futuristic • Animated Feel • Dev-Centric
-- ============================================================

local M = {
  "nvim-lualine/lualine.nvim",

  event = "VeryLazy",

  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "folke/noice.nvim",
    "lewis6991/gitsigns.nvim",
  },
}

function M.config()
  local lualine = require("lualine")

  -- ==========================================================
  -- COLORS
  -- ==========================================================

  local c = {
    bg      = "#0b0f15",
    bg2     = "#111827",
    bg3     = "#161f2b",

    fg      = "#cdd6f4",
    gray    = "#565f89",

    blue    = "#7aa2f7",
    cyan    = "#7dcfff",
    green   = "#9ece6a",
    yellow  = "#e0af68",
    orange  = "#ff9e64",
    red     = "#f7768e",
    purple  = "#bb9af7",
    pink    = "#ff79c6",
  }

  -- ==========================================================
  -- MODE
  -- ==========================================================

  local mode_colors = {
    n = c.blue,
    i = c.green,
    v = c.purple,
    V = c.purple,
    [""] = c.pink,
    c = c.yellow,
    R = c.red,
    t = c.cyan,
  }

  local mode_icons = {
    n = "",
    i = "󰏫",
    v = "󰈈",
    V = "󰈈",
    [""] = "󰈈",
    c = "",
    R = "󰑕",
    t = "󰆍",
  }

  -- ==========================================================
  -- HELPERS
  -- ==========================================================

  local function mode()
    local m = vim.fn.mode()

    return string.format(
      " %s %s ",
      mode_icons[m] or "",
      string.upper(m)
    )
  end

  local function mode_color()
    return {
      fg = c.bg,
      bg = mode_colors[vim.fn.mode()] or c.blue,
      gui = "bold",
    }
  end

  local function git_diff()
    local gs = vim.b.gitsigns_status_dict

    if not gs then
      return ""
    end

    return string.format(
      "󰊢 +%s ~%s -%s",
      gs.added or 0,
      gs.changed or 0,
      gs.removed or 0
    )
  end

  local function lsp()
    local clients = vim.lsp.get_clients({ bufnr = 0 })

    if next(clients) == nil then
      return "󱏎 offline"
    end

    return "󰒋 " .. clients[1].name
  end

  local function cwd()
    return "󰉋 " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  end

  local function search()
    if vim.v.hlsearch == 0 then
      return ""
    end

    local ok, s = pcall(vim.fn.searchcount)

    if not ok or s.total == 0 then
      return ""
    end

    return string.format("󰱼 %d/%d", s.current, s.total)
  end

  local function clock()
    return "󰥔 " .. os.date("%H:%M")
  end

  local function progress()
    local current = vim.fn.line(".")
    local total = vim.fn.line("$")

    local chars = {
      "░░░░░",
      "█░░░░",
      "██░░░",
      "███░░",
      "████░",
      "█████",
    }

    local i = math.ceil((current / total) * #chars)

    return chars[i]
  end

  local function diagnostics()
    local e = #vim.diagnostic.get(0, {
      severity = vim.diagnostic.severity.ERROR,
    })

    local w = #vim.diagnostic.get(0, {
      severity = vim.diagnostic.severity.WARN,
    })

    local h = #vim.diagnostic.get(0, {
      severity = vim.diagnostic.severity.HINT,
    })

    return string.format(
      "󰅚 %s 󰀪 %s 󰌶 %s",
      e,
      w,
      h
    )
  end

  -- ==========================================================
  -- THEME
  -- ==========================================================

  local theme = {
    normal = {
      a = { fg = c.bg, bg = c.blue, gui = "bold" },
      b = { fg = c.fg, bg = c.bg3 },
      c = { fg = c.gray, bg = c.bg2 },
    },

    insert = {
      a = { fg = c.bg, bg = c.green, gui = "bold" },
    },

    visual = {
      a = { fg = c.bg, bg = c.purple, gui = "bold" },
    },

    replace = {
      a = { fg = c.bg, bg = c.red, gui = "bold" },
    },

    command = {
      a = { fg = c.bg, bg = c.yellow, gui = "bold" },
    },

    inactive = {
      a = { fg = c.gray, bg = c.bg2 },
      b = { fg = c.gray, bg = c.bg2 },
      c = { fg = c.gray, bg = c.bg2 },
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

      component_separators = {
        left = "",
        right = "",
      },

      section_separators = {
        left = "",
        right = "",
      },

      always_divide_middle = true,

      disabled_filetypes = {
        statusline = {
          "dashboard",
          "alpha",
          "snacks_dashboard",
        },
      },
    },

    sections = {
      -- ======================================================
      -- LEFT
      -- ======================================================

      lualine_a = {
        {
          mode,
          color = mode_color,
        },
      },

      lualine_b = {
        {
          cwd,

          color = {
            fg = c.cyan,
            bg = c.bg3,
            gui = "bold",
          },
        },

        {
          "branch",

          icon = "󰘬",

          color = {
            fg = c.purple,
            bg = c.bg3,
          },
        },
      },

      lualine_c = {
        {
          "filename",

          path = 1,

          symbols = {
            modified = " ●",
            readonly = " 󰌾",
            unnamed = " [No Name]",
          },

          color = {
            fg = c.fg,
            bg = c.bg2,
          },
        },

        {
          git_diff,

          color = {
            fg = c.orange,
            bg = c.bg2,
          },
        },

        {
          diagnostics,

          color = {
            fg = c.red,
            bg = c.bg2,
          },
        },
      },

      -- ======================================================
      -- RIGHT
      -- ======================================================

      lualine_x = {
        {
          search,

          color = {
            fg = c.yellow,
          },
        },

        {
          lsp,

          color = {
            fg = c.green,
            gui = "bold",
          },
        },

        {
          "encoding",

          fmt = string.upper,

          color = {
            fg = c.gray,
          },
        },

        {
          "filetype",

          colored = true,

          icon_only = false,

          color = {
            fg = c.blue,
          },
        },
      },

      lualine_y = {
        {
          "progress",

          color = {
            fg = c.cyan,
            bg = c.bg3,
          },
        },

        {
          "location",

          color = {
            fg = c.bg,
            bg = c.blue,
            gui = "bold",
          },
        },
      },

      lualine_z = {
        {
          progress,

          color = {
            fg = c.green,
            bg = c.bg3,
            gui = "bold",
          },
        },

        {
          clock,

          color = {
            fg = c.bg,
            bg = c.purple,
            gui = "bold",
          },
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
        },
      },

      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },

    extensions = {
      "lazy",
      "mason",
      "oil",
      "toggleterm",
      "trouble",
      "quickfix",
    },
  })

  -- ==========================================================
  -- EXTRA HIGHLIGHTS
  -- ==========================================================

  local set = vim.api.nvim_set_hl

  set(0, "StatusLine", {
    bg = c.bg2,
    fg = c.fg,
  })

  set(0, "StatusLineNC", {
    bg = c.bg2,
    fg = c.gray,
  })
end

return M

