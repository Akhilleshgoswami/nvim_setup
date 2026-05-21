-- ============================================================
--  lua/akhilesh/plugins/tiny-inline-diagnostic.lua
-- ============================================================

return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event    = "LspAttach", -- only needed once an LSP connects
  priority = 1000,

  opts = {
    preset = "powerline",

    signs = {
      left        = "",
      right       = "",
      diag        = "●",
      arrow       = "    ",
      up_arrow    = "    ",
      vertical    = " │",
      vertical_end = " └",
    },

    options = {
      -- show which LSP / linter the diagnostic comes from
      show_source = {
        enabled  = true,
        if_many  = false, -- show source even when there's only one
      },

      -- use the diagnostic severity icons instead of custom ones
      use_icons_from_diagnostic = false,

      -- arrow colour matches the diagnostic severity colour
      set_arrow_to_diag_color = true,

      -- show all messages when multiple diagnostics on same line
      multiple_diag_under_cursor = true,

      -- show every diagnostic on the buffer, not just cursor line
      show_all_diags_on_cursorline = false,

      -- smooth multiline wrapping
      multilines = {
        enabled      = true,
        always_show  = false,
      },

      -- break long messages at word boundaries
      break_line = {
        enabled    = true,
        after      = 80,
      },

      -- throttle virtual text updates (ms) — keeps it snappy
      throttle = 20,

      softwrap = 30,

      virt_texts = {
        priority = 2048,
      },

      severity_sort = {
        enabled = true,
      },

      overflow = {
        mode = "wrap", -- "wrap" | "none" | "ellipsis"
      },
    },
  },

  config = function(_, opts)
    -- disable Neovim's built-in virtual text so they don't overlap
    vim.diagnostic.config({
      virtual_text = false,
      signs        = true,
      underline    = true,
      update_in_insert = false,
      severity_sort    = true,
      float = {
        border  = "rounded",
        source  = true,
        header  = "",
        prefix  = "",
      },
    })

    require("tiny-inline-diagnostic").setup(opts)
  end,
}
