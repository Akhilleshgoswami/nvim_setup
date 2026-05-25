-- ============================================================
--  lua/akhilesh/plugins/indentaion.lua
--  Subtle rainbow indent + soft single-color active scope
-- ============================================================

return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = { "BufReadPost", "BufNewFile" },

  config = function()
    local hooks = require("ibl.hooks")

    -- ----------------------------------------------------
    -- HIGHLIGHT GROUPS
    -- Indent : 7 muted rainbow steps (background-tier)
    -- Scope  : single soft accent color (no eye-burn)
    -- ----------------------------------------------------
    local rainbow_indent = {
      "RainbowRed",
      "RainbowYellow",
      "RainbowBlue",
      "RainbowOrange",
      "RainbowGreen",
      "RainbowViolet",
      "RainbowCyan",
    }

    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      local set = vim.api.nvim_set_hl

      -- Indent : very muted, blends with bg
      set(0, "RainbowRed",    { fg = "#2a2330" })
      set(0, "RainbowYellow", { fg = "#2f2c25" })
      set(0, "RainbowBlue",   { fg = "#252b35" })
      set(0, "RainbowOrange", { fg = "#2f2925" })
      set(0, "RainbowGreen",  { fg = "#252e28" })
      set(0, "RainbowViolet", { fg = "#2a2535" })
      set(0, "RainbowCyan",   { fg = "#252e33" })

      -- Scope : single soft cyan-blue, slightly above muted
      set(0, "IblScope", { fg = "#3d59a1" })
    end)

    require("ibl").setup({
      indent = {
        char = "▏",
        tab_char = "▏",
        highlight = rainbow_indent,
        smart_indent_cap = true,
        priority = 2,
      },

      whitespace = {
        highlight = rainbow_indent,
        remove_blankline_trail = true,
      },

      scope = {
        enabled = true,
        char = "▏",
        show_start = false,
        show_end = false,
        show_exact_scope = false,
        injected_languages = true,
        priority = 1024,
        highlight = "IblScope",
        include = {
          node_type = {
            ["*"] = {
              "argument_list",
              "arguments",
              "block",
              "chunk",
              "class",
              "do_block",
              "do_statement",
              "element",
              "for_statement",
              "function",
              "function_declaration",
              "function_definition",
              "if_statement",
              "method",
              "method_definition",
              "object",
              "return_statement",
              "table_constructor",
              "tuple",
              "while_statement",
            },
          },
        },
      },

      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "snacks_dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
          "TelescopePrompt",
          "TelescopeResults",
          "noice",
          "oil",
          "starter",
          "checkhealth",
          "gitcommit",
        },
        buftypes = {
          "terminal",
          "nofile",
          "quickfix",
          "prompt",
        },
      },
    })
  end,
}

