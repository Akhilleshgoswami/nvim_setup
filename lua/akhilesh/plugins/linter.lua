-- ============================================================
--  lua/akhilesh/plugins/luaLine.lua
--  NEXUS // ELITE CYBER STATUSLINE
--  Ultra Geeky • Premium • Animated Feel
--  Best-of-best modern Neovim statusline
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
  -- CYBERPUNK PALETTE
  -- ==========================================================

  local c = {
    bg        = "#090b10",
    bg_dark   = "#0d1117",
    bg_light  = "#111827",
    layer     = "#161b22",

    fg        = "#c9d1d9",
    muted     = "#6e7681",

    blue      = "#58a6ff",
    cyan      = "#76e3ea",
    green     = "#7ee787",
    yellow    = "#f2cc60",
    orange    = "#ff9e64",
    red       = "#ff7b72",
    purple    = "#d2a8ff",
    pink      = "#ff79c6",
  }

  -- ==========================================================
  -- MODE SYSTEM
  -- ==========================================================

  local modes = {
    n = { name = "NORMAL",  color = c.blue,   icon = "" },
    i = { name = "INSERT",  color = c.green,  icon = "󰏫" },
    v = { name = "VISUAL",  color = c.purple, icon = "󰈈" },
    V = { name = "V-LINE",  color = c.purple, icon = "󰈈" },
    [""] = { name = "V-BLOCK", color = c.pink, icon = "󰈈" },
    c = { name = "COMMAND", color = c.yellow, icon = "" },
    R = { name = "REPLACE", color = c.red,    icon = "󰑕" },
    t = { name = "TERMINAL",color = c.cyan,   icon = "󰆍" },
  }

  local function mode_data()
    return modes[vim.fn.mode()] or modes.n
  end

  -- ==========================================================
  -- COMPONENTS
  -- ==========================================================

  local function mode()
    local m = mode_data()

    return string.format(
      " %s %s ",
      m.icon,
      m.name
    )
  end

  local function mode_color()
    return {
      fg = c.bg,
      bg = mode_data().color,
      gui = "bold",
    }
  end

  local function cwd()
    return "󰉋 " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  end

  local function lsp()
    local clients = vim.lsp.get_clients({ bufnr = 0 })

    if next(clients) == nil then
      return "󱏎 offline"
    end

    local names = {}

    for _, client in ipairs(clients) do
      table.insert(names, client.name)
    end

    return "󰒋 " .. table.concat(names, " · ")
  end

  local function diagnostics()
    local error = #vim.diagnostic.get(0, {
      severity = vim.diagnostic.severity.ERROR,
    })

    local warn = #vim.diagnostic.get(0, {
      severity = vim.diagnostic.severity.WARN,
    })

    local hint = #vim.diagnostic.get(0, {
      severity = vim.diagnostic.severity.HINT,
    })

    return string.format(
      "󰅚 %s 󰀪 %s 󰌶 %s",
      error,
      warn,
      hint
    )
  end

  local function git()
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

  local function search()
    if vim.v.hlsearch == 0 then
      return ""
    end

    local ok, s = pcall(vim.fn.searchcount)

    if not ok or s.total == 0 then
      return ""
    end

    return string.format(
      "󰱼 %d/%d",
      s.current,
      s.total
    )
  end

  local function macro()
    local reg = vim.fn.reg_recording()

    if reg == "" then
      return ""
    end

    return "󰑋 REC @" .. reg
  end

  local function clock()
    return "󰥔 " .. os.date("%H:%M")
  end

  local function os_icon()
    local sys = vim.loop.os_uname().sysname

    if sys == "Darwin" then
      return " mac"
    elseif sys == "Linux" then
      return " linux"
    else
      return " windows"
    end
  end

  local function progress_bar()
    local current = vim.fn.line(".")
    local total = vim.fn.line("$")

    local chars = {
      "▁▁▁▁▁",
      "██▁▁▁",
      "███▁▁",
      "████▁",
      "█████",
    }

    local i = math.ceil((current / total) * #chars)

    return chars[i]
  end

  -- ==========================================================
  -- THEME
  -- ==========================================================

  local theme = {
    normal = {
      a = { fg = c.bg, bg = c.blue, gui = "bold" },
      b = { fg = c.fg, bg = c.layer },
      c = { fg = c.muted, bg = c.bg_dark },
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
      a = { fg = c.muted, bg = c.bg_dark },
      b = { fg = c.muted, bg = c.bg_dark },
      c = { fg = c.muted, bg = c.bg_dark },
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
        left = "│",
        right = "│",
      },

      section_separators = {
        left = "",
        right = "",
      },

      disabled_filetypes = {
        statusline = {
          "dashboard",
          "alpha",
          "snacks_dashboard",
        },
      },

      always_divide_middle = true,
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
            bg = c.layer,
            gui = "bold",
          },
        },

        {
          "branch",

          icon = "󰘬",

          color = {
            fg = c.purple,
            bg = c.layer,
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
            bg = c.bg_dark,
          },
        },

        {
          git,

          color = {
            fg = c.orange,
            bg = c.bg_dark,
          },
        },

        {
          diagnostics,

          color = {
            fg = c.red,
            bg = c.bg_dark,
          },
        },

        {
          macro,

          color = {
            fg = c.yellow,
            bg = c.bg_dark,
            gui = "bold",
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
            fg = c.muted,
          },
        },

        {
          os_icon,

          color = {
            fg = c.blue,
          },
        },

        {
          "filetype",

          colored = true,

          icon_only = false,

          color = {
            fg = c.cyan,
          },
        },
      },

      lualine_y = {
        {
          "progress",

          color = {
            fg = c.cyan,
            bg = c.layer,
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
          progress_bar,

          color = {
            fg = c.green,
            bg = c.layer,
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
  -- HIGHLIGHTS
  -- ==========================================================

  local set = vim.api.nvim_set_hl

  set(0, "StatusLine", {
    bg = c.bg_dark,
    fg = c.fg,
  })

  set(0, "StatusLineNC", {
    bg = c.bg_dark,
    fg = c.muted,
  })
end

return M

