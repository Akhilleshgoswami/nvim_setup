-- lua/akhilesh/plugins/noice.lua
-- ============================================================
--  lua/akhilesh/plugins/noice.lua
--  Ultra Clean + Theme Adaptive + Modern Floating UI
-- ============================================================

return {
  "folke/noice.nvim",

  lazy = false,

  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },

  opts = function()
    -- ========================================================
    -- THEME COLORS (AUTO MATCHES ANY COLORSCHEME)
    -- ========================================================

    local function hl(name, attr)
      local ok, h = pcall(vim.api.nvim_get_hl, 0, {
        name = name,
        link = false,
      })

      if not ok or not h[attr] then
        return nil
      end

      return string.format("#%06x", h[attr])
    end

    local colors = {
      bg      = hl("Normal", "bg") or "#111111",
      fg      = hl("Normal", "fg") or "#cdd6f4",
      blue    = hl("Function", "fg") or "#7aa2f7",
      green   = hl("String", "fg") or "#9ece6a",
      red     = hl("DiagnosticError", "fg") or "#f7768e",
      yellow  = hl("Type", "fg") or "#e0af68",
      purple  = hl("Statement", "fg") or "#bb9af7",
      cyan    = hl("Keyword", "fg") or "#7dcfff",
      comment = hl("Comment", "fg") or "#565f89",
    }

    -- ========================================================
    -- HIGHLIGHTS
    -- ========================================================

    local function set_hl()
      local set = vim.api.nvim_set_hl

      -- Noice cmdline
      set(0, "NoiceCmdlinePopup", {
        bg = colors.bg,
      })

      set(0, "NoiceCmdlinePopupBorder", {
        fg = colors.blue,
        bg = colors.bg,
      })

      set(0, "NoiceCmdlineIcon", {
        fg = colors.cyan,
      })

      set(0, "NoiceCmdlinePopupTitle", {
        fg = colors.blue,
        bold = true,
      })

      -- Popupmenu
      set(0, "NoicePopupmenu", {
        bg = colors.bg,
      })

      set(0, "NoicePopupmenuBorder", {
        fg = colors.comment,
        bg = colors.bg,
      })

      set(0, "NoicePopupmenuSelected", {
        bg = "NONE",
        fg = colors.yellow,
        bold = true,
      })

      -- Mini view
      set(0, "NoiceMini", {
        bg = colors.bg,
      })

      -- Confirm
      set(0, "NoiceConfirmBorder", {
        fg = colors.green,
        bg = colors.bg,
      })

      -- Hover
      set(0, "NoiceLspProgressTitle", {
        fg = colors.blue,
        bold = true,
      })

      set(0, "NoiceLspProgressSpinner", {
        fg = colors.cyan,
      })

      set(0, "NoiceLspProgressClient", {
        fg = colors.purple,
      })

      -- Cmdline popup blend
      set(0, "FloatBorder", {
        fg = colors.comment,
        bg = colors.bg,
      })
    end

    set_hl()

    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.schedule(set_hl)
      end,
    })

    -- ========================================================
    -- RETURN CONFIG
    -- ========================================================

    return {

      -- ======================================================
      -- LSP
      -- ======================================================

      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },

        hover = {
          enabled = true,
          silent = true,
        },

        signature = {
          enabled = true,

          auto_open = {
            enabled = true,
            trigger = true,
            luasnip = true,
            throttle = 50,
          },
        },

        progress = {
          enabled = true,
          throttle = 1000 / 30,
          view = "mini",
        },

        message = {
          enabled = true,
        },
      },

      -- ======================================================
      -- PRESETS
      -- ======================================================

      presets = {
        bottom_search = false,
        command_palette = false,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = true,
      },

      -- ======================================================
      -- CMDLINE
      -- ======================================================

      cmdline = {
        enabled = true,

        view = "cmdline_popup",

        format = {
          cmdline = {
            icon = "",
            lang = "vim",
          },

          search_down = {
            icon = " ",
            lang = "regex",
          },

          search_up = {
            icon = " ",
            lang = "regex",
          },

          filter = {
            icon = "󰈲",
            lang = "bash",
          },

          lua = {
            icon = "",
            lang = "lua",
          },

          help = {
            icon = "󰋖",
          },
        },
      },

      -- ======================================================
      -- MESSAGES
      -- ======================================================

      messages = {
        enabled = true,

        view = "mini",

        view_error = "notify",
        view_warn = "notify",

        view_history = "split",
        view_search = "virtualtext",
      },

      -- ======================================================
      -- POPUPMENU
      -- ======================================================

      popupmenu = {
        enabled = true,
        backend = "nui",
      },

      -- ======================================================
      -- NOTIFY
      -- ======================================================

      notify = {
        enabled = true,
        view = "notify",
      },

      -- ======================================================
      -- ROUTES (REMOVE NOISE)
      -- ======================================================

      routes = {

        -- Remove INSERT visual spam
        {
          filter = {
            event = "msg_showmode",
          },
          opts = {
            skip = true,
          },
        },

        -- Remove useless file messages
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
              { find = "%d fewer lines" },
              { find = "%d more lines" },
              { find = "%d lines yanked" },
            },
          },

          opts = {
            skip = true,
          },
        },

        -- Long outputs -> split
        {
          filter = {
            event = "msg_show",
            min_height = 15,
          },

          view = "split",
        },
      },

      -- ======================================================
      -- VIEWS
      -- ======================================================

      views = {

        -- COMMAND LINE
        cmdline_popup = {
          position = {
            row = "88%",
            col = "50%",
          },

          size = {
            width = 60,
            height = "auto",
          },

          border = {
            style = "rounded",
            padding = { 0, 1 },
          },

          win_options = {
            winblend = 0,

            winhighlight = table.concat({
              "Normal:NormalFloat",
              "FloatBorder:NoiceCmdlinePopupBorder",
            }, ","),
          },
        },

        -- MINI MESSAGES
        mini = {
          timeout = 2500,

          position = {
            row = -2,
            col = "100%",
          },

          win_options = {
            winblend = 0,
          },
        },

        -- NOTIFICATIONS
        notify = {
          replace = false,
          merge = false,
        },

        -- SPLIT
        split = {
          enter = true,

          size = "20%",

          position = "bottom",

          close = {
            keys = { "q", "<Esc>" },
          },
        },

        -- HOVER
        hover = {
          border = {
            style = "rounded",
            padding = { 0, 1 },
          },

          position = {
            row = 2,
            col = 2,
          },

          size = {
            max_width = 90,
          },

          win_options = {
            winblend = 0,
          },
        },

        -- POPUPMENU
        popupmenu = {
          relative = "editor",

          border = {
            style = "rounded",
            padding = { 0, 1 },
          },

          win_options = {
            winblend = 0,

            winhighlight = table.concat({
              "Normal:NoicePopupmenu",
              "FloatBorder:NoicePopupmenuBorder",
            }, ","),
          },
        },
      },

      -- ======================================================
      -- STATUSLINE SUPPORT
      -- ======================================================

      status = {},
      format = {},
    }
  end,

  config = function(_, opts)
    require("noice").setup(opts)

    -- ========================================================
    -- NOTIFY CONFIG
    -- ========================================================

    vim.notify = require("notify")

    require("notify").setup({
      stages = "fade",

      timeout = 3000,

      render = "wrapped-compact",

      background_colour = "#000000",

      fps = 60,

      icons = {
        ERROR = "",
        WARN  = "",
        INFO  = "",
        DEBUG = "",
        TRACE = "✎",
      },
    })
  end,
}
