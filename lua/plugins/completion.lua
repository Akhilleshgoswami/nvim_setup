-- Completion: blink.cmp with LuaSnip, Copilot, buffer, path and ripgrep.
-- VS Code feel: Tab accepts, Enter accepts, ghost text previews.

local icons = require("utils.icons")

return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        version = "2.*",
        build = (function()
          if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
            return
          end
          return "make install_jsregexp"
        end)(),
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
          require("luasnip").config.setup({
            history = true,
            updateevents = "TextChanged,TextChangedI",
            enable_autosnippets = false,
          })
          require("luasnip.loaders.from_vscode").lazy_load()
          pcall(require("luasnip.loaders.from_lua").load, {
            paths = vim.fn.stdpath("config") .. "/snippets",
          })
        end,
      },
      "fang2hou/blink-copilot",
      "mikavilpas/blink-ripgrep.nvim",
      "zbirenbaum/copilot.lua",
    },
    opts = {
      snippets = { preset = "luasnip" },

      keymap = {
        preset = "none",
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "cancel", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.accept()
            end
            return cmp.select_and_accept()
          end,
          "snippet_forward",
          "fallback",
        },
        ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
        ["<C-n>"] = { "select_next", "fallback_to_mappings" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      },

      appearance = {
        nerd_font_variant = "mono",
        kind_icons = vim.tbl_extend("force", icons.kinds, { Copilot = icons.kinds.Copilot }),
      },

      completion = {
        keyword = { range = "prefix" },
        trigger = { show_on_trigger_character = true },
        list = { selection = { preselect = true, auto_insert = true } },
        accept = { auto_brackets = { enabled = true } },
        ghost_text = { enabled = true },
        menu = {
          border = "rounded",
          winblend = 0,
          scrollbar = false,
          draw = {
            padding = 1,
            gap = 1,
            treesitter = { "lsp" },
            columns = {
              { "kind_icon" },
              { "label", "label_description", gap = 1 },
              { "source_name" },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 150,
          window = { border = "rounded", winblend = 0 },
        },
      },

      signature = {
        enabled = true,
        window = { border = "rounded", winblend = 0 },
      },

      sources = {
        default = { "lsp", "path", "snippets", "copilot", "buffer", "ripgrep" },
        per_filetype = {
          sql = { "dadbod", "snippets", "buffer" },
          mysql = { "dadbod", "snippets", "buffer" },
        },
        providers = {
          lsp = { name = "LSP", score_offset = 90 },
          copilot = {
            module = "blink-copilot",
            name = "Copilot",
            score_offset = 100,
            async = true,
            opts = { max_completions = 3 },
          },
          ripgrep = {
            module = "blink-ripgrep",
            name = "Ripgrep",
            score_offset = -5,
            opts = { prefix_min_len = 4, context_size = 5, max_filesize = "1M" },
          },
          dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
          buffer = { score_offset = -10 },
        },
      },

      cmdline = {
        enabled = true,
        keymap = { preset = "cmdline" },
        completion = { menu = { auto_show = true } },
      },
    },
    opts_extend = { "sources.default" },
  },
}
