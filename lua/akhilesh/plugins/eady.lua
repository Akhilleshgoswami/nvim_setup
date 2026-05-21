return {
  "folke/edgy.nvim",
  event = "BufReadPost",
  opts = {
    animate = { enabled = false }, -- snacks handles animations
    wo = {
      winbar = true,
      winfixwidth = true,
      winfixheight = false,
      winhighlight = "WinBar:EdgyWinBar,Normal:EdgyNormal",
    },
    options = {
      left   = { size = 40 },
      bottom = { size = 12 },
      right  = { size = 50 },
      top    = { size = 10 },
    },

    -- ── Left: file explorer ───────────────────────────────────
    left = {
      {
        ft    = "snacks_picker_list",
        title = "Explorer",
        size  = { width = 40 },
      },
    },

    -- ── Right: LSP panels ─────────────────────────────────────
    right = {
      {
        ft    = "aerial",
        title = "SYMBOLS",
        size  = { width = 40 },
      },
      {
        ft    = "copilot-chat",
        title = "COPILOT",
        size  = { width = 50 },
      },
    },

    -- ── Bottom: terminals, diagnostics, quickfix ──────────────
    bottom = {
      {
        ft     = "snacks_terminal",
        size   = { height = 0.35 },
        title  = "%{b:snacks_terminal.id}: %{b:term_title}",
        filter = function(_buf, win)
          return vim.w[win].snacks_win
            and vim.w[win].snacks_win.position == "bottom"
            and vim.w[win].snacks_win.relative == "editor"
            and not vim.w[win].trouble_preview
        end,
      },
      {
        ft    = "Trouble",
        title = "TROUBLE",
        size  = { height = 0.35 },
        filter = function(_buf, win)
          return vim.api.nvim_win_get_config(win).relative == ""
        end,
      },
      {
        ft    = "qf",
        title = "QUICKFIX",
        size  = { height = 0.25 },
      },
      {
        ft    = "help",
        title = "HELP",
        size  = { height = 20 },
        filter = function(buf)
          return vim.bo[buf].buftype == "help"
        end,
      },
      {
        ft    = "noice",
        title = "MESSAGES",
        size  = { height = 0.25 },
        filter = function(_buf, win)
          return vim.api.nvim_win_get_config(win).relative == ""
        end,
      },
      {
        ft    = "lazy",
        title = "LAZY",
        size  = { height = 0.4 },
      },
    },
  },
}
