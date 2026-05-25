-- ============================================================
--  lua/akhilesh/plugins/tiny-inline-diagnostic.lua
--  Clean + Theme Adaptive + Minimal Geek UI
-- ============================================================

return {
  "rachartier/tiny-inline-diagnostic.nvim",

  event = "LspAttach",
  priority = 1000,

  opts = function()

    -- ========================================================
    -- THEME COLORS
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
      red     = hl("DiagnosticError", "fg") or "#f7768e",
      yellow  = hl("DiagnosticWarn", "fg") or "#e0af68",
      blue    = hl("DiagnosticInfo", "fg") or "#7aa2f7",
      cyan    = hl("DiagnosticHint", "fg") or "#7dcfff",
      comment = hl("Comment", "fg") or "#565f89",
    }

    -- ========================================================
    -- HIGHLIGHTS
    -- ========================================================

    local function set_hl()
      local set = vim.api.nvim_set_hl

      set(0, "TinyInlineDiagnosticVirtualTextError", {
        fg = colors.red,
        bg = "NONE",
        italic = true,
      })

      set(0, "TinyInlineDiagnosticVirtualTextWarn", {
        fg = colors.yellow,
        bg = "NONE",
        italic = true,
      })

      set(0, "TinyInlineDiagnosticVirtualTextInfo", {
        fg = colors.blue,
        bg = "NONE",
        italic = true,
      })

      set(0, "TinyInlineDiagnosticVirtualTextHint", {
        fg = colors.cyan,
        bg = "NONE",
        italic = true,
      })

      set(0, "DiagnosticVirtualTextError", {
        fg = colors.red,
        bg = "NONE",
      })

      set(0, "DiagnosticVirtualTextWarn", {
        fg = colors.yellow,
        bg = "NONE",
      })

      set(0, "DiagnosticVirtualTextInfo", {
        fg = colors.blue,
        bg = "NONE",
      })

      set(0, "DiagnosticVirtualTextHint", {
        fg = colors.cyan,
        bg = "NONE",
      })

      set(0, "DiagnosticUnderlineError", {
        undercurl = true,
        sp = colors.red,
      })

      set(0, "DiagnosticUnderlineWarn", {
        undercurl = true,
        sp = colors.yellow,
      })

      set(0, "DiagnosticUnderlineInfo", {
        undercurl = true,
        sp = colors.blue,
      })

      set(0, "DiagnosticUnderlineHint", {
        undercurl = true,
        sp = colors.cyan,
      })

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
    -- RETURN PLUGIN CONFIG
    -- ========================================================

    return {

      preset = "modern",

      signs = {
        left         = "",
        right        = "",

        diag         = "●",

        arrow        = "  ",
        up_arrow     = "  ",

        vertical     = " │",
        vertical_end = " └",
      },

      options = {

        -- ====================================================
        -- SOURCE
        -- ====================================================

        show_source = {
          enabled = true,
          if_many = false,
        },

        -- ====================================================
        -- UI
        -- ====================================================

        use_icons_from_diagnostic = true,

        set_arrow_to_diag_color = true,

        multiple_diag_under_cursor = true,

        show_all_diags_on_cursorline = false,

        add_messages = true,

        multilines = {
          enabled = true,
          always_show = false,
        },

        break_line = {
          enabled = true,
          after = 70,
        },

        throttle = 20,

        softwrap = 25,

        overflow = {
          mode = "wrap",
        },

        virt_texts = {
          priority = 2048,
        },

        severity_sort = {
          enabled = true,
        },
      },
    }
  end,

  config = function(_, opts)

    -- ========================================================
    -- DISABLE DEFAULT UGLY LSP VIRTUAL TEXT
    -- ========================================================

    vim.diagnostic.config({

      virtual_text = false,

      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "●",
          [vim.diagnostic.severity.WARN]  = "●",
          [vim.diagnostic.severity.INFO]  = "●",
          [vim.diagnostic.severity.HINT]  = "●",
        },
      },

      underline = true,

      update_in_insert = false,

      severity_sort = true,

      float = {
        border = "rounded",
        source = true,
        header = "",
        prefix = "",

        focusable = false,

        style = "minimal",
      },
    })

    -- ========================================================
    -- SETUP
    -- ========================================================

    require("tiny-inline-diagnostic").setup(opts)

    -- ========================================================
    -- FLOATING DIAGNOSTIC
    -- ========================================================

    vim.api.nvim_create_autocmd("CursorHold", {
      callback = function()
        vim.diagnostic.open_float(nil, {
          focusable = false,
          close_events = {
            "BufLeave",
            "CursorMoved",
            "InsertEnter",
            "FocusLost",
          },

          border = "rounded",

          source = "if_many",

          prefix = "",

          scope = "cursor",
        })
      end,
    })
  end,
}
