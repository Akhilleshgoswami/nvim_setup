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
      bg      = hl("Normal",           "bg") or "#0b1020",
      bg_soft = hl("CursorLine",       "bg") or "#111827",
      fg      = hl("Normal",           "fg") or "#cdd6f4",
      blue    = hl("Function",         "fg") or "#7aa2f7",
      green   = hl("String",           "fg") or "#9ece6a",
      red     = hl("DiagnosticError",  "fg") or "#f7768e",
      yellow  = hl("Type",             "fg") or "#e0af68",
      purple  = hl("Statement",        "fg") or "#bb9af7",
      cyan    = hl("Keyword",          "fg") or "#7dcfff",
      orange  = hl("Number",           "fg") or "#ff9e64",
      comment = hl("Comment",          "fg") or "#565f89",
      border  = hl("FloatBorder",      "fg") or "#1e293b",
    }

    -- ========================================================
    -- HIGHLIGHTS
    -- ========================================================

    local function set_hl()
      local set = vim.api.nvim_set_hl

      -- Cmdline popup
      set(0, "NoiceCmdlinePopup",       { bg = colors.bg })
      set(0, "NoiceCmdlinePopupBorder", { fg = colors.blue,    bg = colors.bg })
      set(0, "NoiceCmdlinePopupTitle",  { fg = colors.bg,      bg = colors.blue, bold = true })
      set(0, "NoiceCmdlineIcon",        { fg = colors.cyan })

      -- Each cmdline kind gets its own accent
      set(0, "NoiceCmdlineIconSearch",  { fg = colors.yellow })
      set(0, "NoiceCmdlineIconLua",     { fg = colors.purple })
      set(0, "NoiceCmdlineIconHelp",    { fg = colors.green })
      set(0, "NoiceCmdlineIconFilter",  { fg = colors.orange })

      -- Popupmenu
      set(0, "NoicePopupmenu",          { bg = colors.bg })
      set(0, "NoicePopupmenuBorder",    { fg = colors.border,  bg = colors.bg })
      set(0, "NoicePopupmenuSelected",  { bg = colors.bg_soft, fg = colors.cyan, bold = true })
      set(0, "NoicePopupmenuMatch",     { fg = colors.yellow,  bold = true })

      -- Mini (bottom-right inline messages)
      set(0, "NoiceMini",               { bg = colors.bg,      fg = colors.comment })

      -- Confirm dialog
      set(0, "NoiceConfirmBorder",      { fg = colors.green,   bg = colors.bg })

      -- LSP progress
      set(0, "NoiceLspProgressTitle",   { fg = colors.blue,    bold = true })
      set(0, "NoiceLspProgressSpinner", { fg = colors.cyan })
      set(0, "NoiceLspProgressClient",  { fg = colors.purple })

      -- Formatters inside cmdline
      set(0, "NoiceFormatProgressDone", { fg = colors.green,   bold = true })
      set(0, "NoiceFormatProgressTodo", { fg = colors.comment })
      set(0, "NoiceFormatTitle",        { fg = colors.blue,    bold = true })
      set(0, "NoiceFormatEvent",        { fg = colors.comment, italic = true })
      set(0, "NoiceFormatKind",         { fg = colors.purple })
      set(0, "NoiceFormatDate",         { fg = colors.comment, italic = true })

      -- Scrollbar
      set(0, "NoiceScrollbar",          { bg = colors.bg_soft })
      set(0, "NoiceScrollbarThumb",     { bg = colors.blue })

      -- FloatBorder fallback
      set(0, "FloatBorder",             { fg = colors.border,  bg = colors.bg })
      set(0, "NormalFloat",             { bg = colors.bg })
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
          ["vim.lsp.util.stylize_markdown"]                = true,
          ["cmp.entry.get_documentation"]                  = true,
        },

        hover = {
          enabled = true,
          silent  = true,
        },

        signature = {
          enabled = true,

          auto_open = {
            enabled  = true,
            trigger  = true,
            luasnip  = true,
            throttle = 50,
          },
        },

        progress = {
          enabled  = true,
          throttle = 1000 / 30,
          view     = "mini",
        },

        message = {
          enabled = true,
        },
      },

      -- ======================================================
      -- PRESETS
      -- ======================================================

      presets = {
        bottom_search        = false,
        command_palette      = false,
        long_message_to_split = true,
        inc_rename           = false,
        lsp_doc_border       = true,
      },

      -- ======================================================
      -- CMDLINE
      -- ======================================================

      cmdline = {
        enabled = true,
        view    = "cmdline_popup",

        format = {
          cmdline = {
            icon  = "",
            lang  = "vim",
          },

          search_down = {
            icon  = " ",
            lang  = "regex",
          },

          search_up = {
            icon  = " ",
            lang  = "regex",
          },

          filter = {
            icon  = "󰈲",
            lang  = "bash",
          },

          lua = {
            icon  = "",
            lang  = "lua",
          },

          help = {
            icon  = "󰋖",
          },

          -- extra: substitute command gets a distinct icon
          substitute = {
            icon     = "󰛔",
            lang     = "regex",
            pattern  = "^:%%?s/",
            title    = " Replace ",
          },
        },
      },

      -- ======================================================
      -- MESSAGES
      -- ======================================================

      messages = {
        enabled     = true,
        view        = "mini",
        view_error  = "notify",
        view_warn   = "notify",
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
        view    = "notify",
      },

      -- ======================================================
      -- ROUTES  (suppress noise, redirect long output)
      -- ======================================================

      routes = {
        -- hide INSERT/VISUAL/REPLACE mode text
        {
          filter = { event = "msg_showmode" },
          opts   = { skip = true },
        },

        -- hide trivial write / yank / motion messages
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
              { find = "^%[.*%]$" },        -- e.g. [w], [q]
              { find = "written$" },
              { find = "^--" },             -- -- INSERT -- etc
            },
          },
          opts = { skip = true },
        },

        -- redirect large outputs to split
        {
          filter = {
            event      = "msg_show",
            min_height = 15,
          },
          view = "split",
        },

        -- send search-count virtualtext, not a floating message
        {
          filter = {
            event  = "msg_show",
            kind   = "search_count",
          },
          opts = { skip = true },
        },
      },

      -- ======================================================
      -- VIEWS
      -- ======================================================

      views = {

        -- COMMAND LINE POPUP
        cmdline_popup = {
          position = {
            row = "88%",
            col = "50%",
          },

          size = {
            width  = 64,
            height = "auto",
          },

          border = {
            style   = "rounded",
            padding = { 0, 1 },
          },

          win_options = {
            winblend = 0,

            winhighlight = table.concat({
              "Normal:NormalFloat",
              "FloatBorder:NoiceCmdlinePopupBorder",
              "FloatTitle:NoiceCmdlinePopupTitle",
            }, ","),
          },
        },

        -- MINI  (bottom-right, ephemeral messages)
        mini = {
          timeout = 2500,
          zindex  = 60,

          position = {
            row = -2,
            col = "100%",
          },

          win_options = {
            winblend = 20,       -- subtle transparency

            winhighlight = table.concat({
              "Normal:NoiceMini",
            }, ","),
          },
        },

        -- NOTIFICATIONS
        notify = {
          replace = false,
          merge   = false,
        },

        -- SPLIT  (long output)
        split = {
          enter    = true,
          size     = "22%",
          position = "bottom",

          close = {
            keys = { "q", "<Esc>" },
          },
        },

        -- HOVER DOC
        hover = {
          border = {
            style   = "rounded",
            padding = { 0, 1 },
          },

          position = { row = 2, col = 2 },

          size = {
            max_width  = 90,
            max_height = 20,
          },

          win_options = {
            winblend = 8,

            winhighlight = table.concat({
              "Normal:NormalFloat",
              "FloatBorder:FloatBorder",
            }, ","),
          },
        },

        -- POPUPMENU
        popupmenu = {
          relative = "editor",

          border = {
            style   = "rounded",
            padding = { 0, 1 },
          },

          win_options = {
            winblend = 5,

            winhighlight = table.concat({
              "Normal:NoicePopupmenu",
              "FloatBorder:NoicePopupmenuBorder",
              "CursorLine:NoicePopupmenuSelected",
            }, ","),
          },
        },

        -- CONFIRM DIALOG
        confirm = {
          border = {
            style   = "rounded",
            padding = { 0, 1 },
            text    = { top = " Confirm " },
          },

          win_options = {
            winblend = 0,

            winhighlight = table.concat({
              "Normal:NormalFloat",
              "FloatBorder:NoiceConfirmBorder",
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

  -- ============================================================
  -- CONFIG
  -- ============================================================

  config = function(_, opts)
    require("noice").setup(opts)

    -- ========================================================
    -- NOTIFY CONFIG
    -- ========================================================

    local notify = require("notify")

    notify.setup({
      stages           = "slide",     -- snappier than "fade"
      timeout          = 3000,
      render           = "wrapped-compact",
      background_colour = "#0b1020",
      max_width        = 50,
      fps              = 60,
      minimum_width    = 28,

      icons = {
        ERROR = " ",
        WARN  = " ",
        INFO  = " ",
        DEBUG = " ",
        TRACE = "✎ ",
      },

      -- dim old notifications slightly
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { focusable = false })
      end,
    })

    vim.notify = notify
  end,
}
