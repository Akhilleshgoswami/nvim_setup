-- lua/akhilesh/plugins/noice.lua
return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      -- Floating cmdline at the center (nv-ide style)
      cmdline = {
        enabled = true,
        view = "cmdline_popup",   -- floating popup (not bottom bar)
        opts = {},
        format = {
          cmdline     = { pattern = "^:", icon = "", lang = "vim" },
          search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
          search_up   = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
          filter      = { pattern = "^:%s*!", icon = "$", lang = "bash" },
          lua         = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
          help        = { pattern = "^:%s*he?l?p?%s+", icon = "󰋖" },
          input       = { view = "cmdline_input", icon = "󰥻 " },
        },
      },
      messages = {
        enabled = true,
        view = "notify",              -- notifications via nvim-notify
        view_error = "notify",
        view_warn = "notify",
        view_history = "messages",
        view_search = "virtualtext",
      },
      popupmenu = {
        enabled = true,
        backend = "nui",              -- use nui for the completion popup
      },
      -- Route certain noisy messages to mini (small bottom-right) instead of notify
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },           -- written x lines
              { find = "; after #%d+" },
              { find = "; before #%d+" },
              { find = "%d+ fewer lines" },
              { find = "%d+ more lines" },
              { find = "%d+ lines yanked" },
              { find = "^/" },                    -- search results count
            },
          },
          view = "mini",
        },
        {
          -- send long messages to a split so they're readable
          filter = { event = "msg_show", min_height = 10 },
          view = "cmdline_output",
        },
      },
      -- Show recording macro in statusline (via lualine integration)
      notify = {
        enabled = true,
        view = "notify",
      },
      lsp = {
        -- Override `vim.lsp.buf.hover` with Noice's fancy version
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        hover = {
          enabled = true,
          silent = true,           -- don't show "no info available" messages
          view = nil,
        },
        signature = {
          enabled = true,
          auto_open = {
            enabled = true,
            trigger = true,
            luasnip = true,
            throttle = 50,
          },
          view = nil,
        },
        progress = {
          enabled = true,
          format = "lsp_progress",
          format_done = "lsp_progress_done",
          throttle = 1000 / 30,
          view = "mini",
        },
        documentation = {
          view = "hover",
          opts = {
            lang = "markdown",
            replace = true,
            render = "plain",
            format = { "{message}" },
            win_options = { concealcursor = "n", conceallevel = 3 },
          },
        },
      },
      -- Cmdline popup position & style
      views = {
        cmdline_popup = {
          position = { row = "40%", col = "50%" },
          size = { width = 60, height = "auto" },
          border = { style = "rounded", padding = { 0, 1 } },
          filter_options = {},
          win_options = {
            winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
          },
        },
        mini = {
          win_options = { winblend = 0 },
        },
        notify = {
          merge = false,
          replace = false,
        },
      },
      presets = {
        bottom_search = false,        -- use default search ui
        command_palette = true,       -- position cmdline and popupmenu together
        long_message_to_split = true, -- long messages go to a split
        inc_rename = false,
        lsp_doc_border = true,        -- add a border to hover docs and signature help
      },
    },
    keys = {
      { "<leader>sn",  "",                                                                            desc = "+noice" },
      { "<S-Enter>",   function() require("noice").redirect(vim.fn.getcmdline()) end,                mode = "c",     desc = "Redirect Cmdline" },
      { "<leader>snl", function() require("noice").cmd("last") end,                                  desc = "Noice Last Message" },
      { "<leader>snh", function() require("noice").cmd("history") end,                               desc = "Noice History" },
      { "<leader>sna", function() require("noice").cmd("all") end,                                   desc = "Noice All" },
      { "<leader>snd", function() require("noice").cmd("dismiss") end,                               desc = "Dismiss All" },
      { "<c-f>",       function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end,  silent = true,  expr = true, desc = "Scroll LSP Doc Fwd",  mode = { "i", "n", "s" } },
      { "<c-b>",       function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true,  expr = true, desc = "Scroll LSP Doc Back", mode = { "i", "n", "s" } },
    },
  },
  -- nvim-notify config (used by noice as the notification backend)
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 3000,
      max_height = function() return math.floor(vim.o.lines * 0.75) end,
      max_width = function() return math.floor(vim.o.columns * 0.75) end,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
      background_colour = "#1a1b26",  -- matches tokyonight-night bg
      render = "wrapped-compact",
      stages = "fade",
      icons = {
        ERROR = " ",
        WARN  = " ",
        INFO  = " ",
        DEBUG = " ",
        TRACE = "✎ ",
      },
    },
  },
}
