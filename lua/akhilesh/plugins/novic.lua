-- lua/akhilesh/plugins/noice.lua
-- ============================================================
--  lua/akhilesh/plugins/noice.lua
-- ============================================================

return {
  "folke/noice.nvim",
  lazy = false,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },

  opts = {
    -- ── LSP ──────────────────────────────────────────────────
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"]                = true,
        ["cmp.entry.get_documentation"]                  = true, -- nicer cmp docs
      },
      hover      = { enabled = true },
      signature  = { enabled = true, auto_open = { enabled = true, trigger = true } },
      progress   = { enabled = true, throttle = 1000 / 30 },
      message    = { enabled = true },
    },

    -- ── Presets ───────────────────────────────────────────────
    presets = {
      bottom_search        = false, -- classic bottom cmdline for /
      command_palette      = false, -- cmdline + popup together
      long_message_to_split = true, -- long msgs → split
      inc_rename           = false,
      lsp_doc_border       = true,  -- border on hover/signature
    },

    -- ── Cmdline ───────────────────────────────────────────────
    cmdline = {
      enabled = true,
      view    = "cmdline_popup",
      format  = {
        cmdline     = { icon = "❯",  lang = "vim",   title = "" },
        search_down = { icon = " ", lang = "regex", title = "" },
        search_up   = { icon = " ", lang = "regex", title = "" },
        filter      = { icon = "$",  lang = "bash",  title = "" },
        lua         = { icon = "",  lang = "lua",   title = "" },
        help        = { icon = "?",                  title = "" },
      },
    },

    -- ── Messages ──────────────────────────────────────────────
    messages = {
      enabled      = true,
      view         = "notify",
      view_error   = "notify",
      view_warn    = "notify",
      view_history = "messages",
      view_search  = "virtualtext",
    },

    -- ── Popupmenu ─────────────────────────────────────────────
    popupmenu = {
      enabled  = true,
      backend  = "nui", -- "nui" | "cmp"
    },

    -- ── Routes (suppress noise) ───────────────────────────────
    routes = {
      -- redirect showmode (-- INSERT --, etc.) to notify
      { view = "notify", filter = { event = "msg_showmode" } },

      -- suppress common noisy write messages
      {
        filter = {
          event  = "msg_show",
          any    = {
            { find = "%d+L, %d+B" },   -- written N lines
            { find = "; after #%d+" },
            { find = "; before #%d+" },
            { find = "%d fewer lines" },
            { find = "%d more lines" },
          },
        },
        opts = { skip = true },
      },

      -- send long messages (>12 lines) to a split instead of notify
      {
        filter  = { event = "msg_show", min_height = 12 },
        view    = "split",
        opts    = { enter = true },
      },
    },

    -- ── Views ─────────────────────────────────────────────────
    views = {
      cmdline_popup = {
        position = { row = "90%", col = "50%" },
        size     = { width = "90%", height = "auto" },
        border   = {
          style   = "rounded",
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
        },
      },

      notify = {
        merge      = false,
        replace    = false,
      },

      split = {
        enter    = true,
        size     = "20%",
        position = "bottom",
        close    = { keys = { "q", "<Esc>" } },
      },

      hover = {
        border = {
          style   = "rounded",
          padding = { 0, 1 },
        },
        size = { max_width = 80 },
      },

      mini = {
        timeout    = 2500,
        zindex     = 60,
        position   = { row = -2, col = -1 },   -- above statusline, right
      },
    },

    -- ── Smart notify (status / search count) ─────────────────
    notify = {
      enabled = true,
      view    = "notify",
    },

    status = {},     -- populated by components (noice + lualine)
    format = {},     -- populated by components
  },
}
