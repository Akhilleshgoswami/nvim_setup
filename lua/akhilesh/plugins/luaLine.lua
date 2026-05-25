-- ============================================================
--  lua/akhilesh/plugins/lualine.lua
--  Ultra Geeky Lualine
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
  -- COLORS
  -- ==========================================================

  local colors = {
    bg       = "#11111b",
    fg       = "#cdd6f4",
    blue     = "#89b4fa",
    cyan     = "#94e2d5",
    black    = "#181825",
    white    = "#ffffff",
    red      = "#f38ba8",
    violet   = "#cba6f7",
    grey     = "#6c7086",
    green    = "#a6e3a1",
    orange   = "#fab387",
    yellow   = "#f9e2af",
  }

  -- ==========================================================
  -- MODE COLORS
  -- ==========================================================

  local mode_colors = {
    n  = colors.green,
    i  = colors.red,
    v  = colors.blue,
    V  = colors.blue,
    [""] = colors.blue,
    c  = colors.violet,
    no = colors.red,
    s  = colors.orange,
    S  = colors.orange,
    ic = colors.yellow,
    R  = colors.violet,
    Rv = colors.violet,
    cv = colors.red,
    ce = colors.red,
    r  = colors.cyan,
    rm = colors.cyan,
    ["r?"] = colors.cyan,
    ["!"] = colors.red,
    t  = colors.green,
  }

  -- ==========================================================
  -- MODE ICON
  -- ==========================================================

  local function mode_icon()
    local icons = {
      n = "󰋜",
      i = "󰙏",
      v = "󰒉",
      V = "󰒉",
      [""] = "󰒉",
      c = "󰘳",
      R = "󰑖",
      t = "󰆍",
    }

    return icons[vim.fn.mode()] or "󰋜"
  end

  -- ==========================================================
  -- SCROLLBAR
  -- ==========================================================

  local function scrollbar()
    local current_line = vim.fn.line(".")
    local total_lines = vim.fn.line("$")

    local chars = {
      "▁",
      "▂",
      "▃",
      "▄",
      "▅",
      "▆",
      "▇",
      "█",
    }

    local line_ratio = current_line / total_lines
    local index = math.ceil(line_ratio * #chars)

    return string.rep(chars[index], 2)
  end

  -- ==========================================================
  -- LSP
  -- ==========================================================

  local function lsp_clients()
    local clients = vim.lsp.get_clients({
      bufnr = 0,
    })

    if next(clients) == nil then
      return "No LSP"
    end

    local names = {}

    for _, client in pairs(clients) do
      table.insert(names, client.name)
    end

    return "󰒋 " .. table.concat(names, ", ")
  end

  -- ==========================================================
  -- FILESIZE
  -- ==========================================================

  local function filesize()
    local size = vim.fn.getfsize(vim.fn.expand("%:p"))

    if size < 0 then
      return ""
    end

    if size < 1024 then
      return size .. "B"
    elseif size < 1048576 then
      return string.format("%.1fK", size / 1024)
    else
      return string.format("%.1fM", size / 1048576)
    end
  end

  -- ==========================================================
  -- CLOCK
  -- ==========================================================

  local function clock()
    return "󰥔 " .. os.date("%H:%M")
  end

  -- ==========================================================
  -- NOICE
  -- ==========================================================

  local function noice_command()
    local ok, noice = pcall(require, "noice")

    if not ok then
      return ""
    end

    if noice.api.status.command.has() then
      return noice.api.status.command.get()
    end

    return ""
  end

  -- ==========================================================
  -- GIT DIFF SOURCE
  -- ==========================================================

  local function diff_source()
    local gitsigns = vim.b.gitsigns_status_dict

    if gitsigns then
      return {
        added = gitsigns.added,
        modified = gitsigns.changed,
        removed = gitsigns.removed,
      }
    end
  end

  -- ==========================================================
  -- SIDEKICK
  -- ==========================================================

  local function sidekick_status()
    local ok, status = pcall(require, "sidekick.status")

    if not ok then
      return ""
    end

    local s = status.get()

    if not s then
      return ""
    end

    return "󰚩 AI"
  end

  -- ==========================================================
  -- THEME
  -- ==========================================================

  local theme = {
    normal = {
      a = {
        fg = colors.black,
        bg = colors.green,
        gui = "bold",
      },

      b = {
        fg = colors.fg,
        bg = colors.black,
      },

      c = {
        fg = colors.fg,
        bg = colors.bg,
      },
    },

    insert = {
      a = {
        fg = colors.black,
        bg = colors.red,
        gui = "bold",
      },
    },

    visual = {
      a = {
        fg = colors.black,
        bg = colors.blue,
        gui = "bold",
      },
    },

    replace = {
      a = {
        fg = colors.black,
        bg = colors.violet,
        gui = "bold",
      },
    },

    command = {
      a = {
        fg = colors.black,
        bg = colors.orange,
        gui = "bold",
      },
    },

    inactive = {
      a = {
        fg = colors.grey,
        bg = colors.bg,
      },

      b = {
        fg = colors.grey,
        bg = colors.bg,
      },

      c = {
        fg = colors.grey,
        bg = colors.bg,
      },
    },
  }

  -- ==========================================================
  -- SETUP
  -- ==========================================================

  lualine.setup({
    options = {
      theme = theme,

      globalstatus = true,

      disabled_filetypes = {
        statusline = {
          "dashboard",
          "alpha",
          "starter",
          "snacks_dashboard",
        },
      },

      component_separators = {
        left = "",
        right = "",
      },

      section_separators = {
        left = "",
        right = "",
      },
    },

    -- ========================================================
    -- ACTIVE
    -- ========================================================

    sections = {
      -- MODE
      lualine_a = {
        {
          function()
            return " " .. mode_icon() .. " "
          end,

          color = function()
            return {
              fg = colors.black,
              bg = mode_colors[vim.fn.mode()] or colors.green,
              gui = "bold",
            }
          end,

          padding = 0,
        },
      },

      -- FILE
      lualine_b = {
        {
          "branch",
          icon = "󰘬",
        },

        {
          "filename",
          path = 1,
          symbols = {
            modified = " ●",
            readonly = " 󰌾",
            unnamed = " [No Name]",
          },
        },
      },

      -- CENTER
      lualine_c = {
        {
          "diff",

          source = diff_source,

          symbols = {
            added = "  ",
            modified = "  ",
            removed = "  ",
          },
        },

        {
          "diagnostics",

          sources = {
            "nvim_lsp",
          },

          symbols = {
            error = " ",
            warn = " ",
            info = " ",
            hint = "󰌵 ",
          },
        },

        {
          noice_command,
          color = {
            fg = colors.black,
            bg = colors.yellow,
            gui = "bold",
          },
        },
      },

      -- RIGHT
      lualine_x = {
        {
          sidekick_status,
          color = {
            fg = colors.green,
          },
        },

        {
          lsp_clients,
          color = {
            fg = colors.cyan,
          },
        },

        {
          filesize,
          color = {
            fg = colors.orange,
          },
        },

        {
          "encoding",
          fmt = string.upper,
        },

        {
          "fileformat",
          symbols = {
            unix = "󰌽",
            dos = "󰍲",
            mac = "󰀵",
          },
        },

        {
          "filetype",
          colored = true,
          icon_only = false,
        },
      },

      -- POSITION
      lualine_y = {
        {
          "progress",
          color = {
            fg = colors.blue,
          },
        },

        {
          clock,
          color = {
            fg = colors.violet,
          },
        },
      },

      -- SCROLLBAR
      lualine_z = {
        {
          function()
            return "󰕭 " .. vim.fn.line(".") .. ":" .. vim.fn.col(".")
          end,
        },

        {
          scrollbar,
          color = {
            fg = colors.cyan,
          },
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
        },
      },

      lualine_c = {},

      lualine_x = {
        "location",
      },

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
    },
  })
end

return M
