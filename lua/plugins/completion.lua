-- Completion: blink.cmp with LuaSnip, buffer, path and ripgrep.
-- VS Code feel: Tab accepts, Enter accepts, ghost text previews.

local icons = require("umbra.icons")
local ui = require("umbra.tokens")

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
      "mikavilpas/blink-ripgrep.nvim",
    },
    opts = {
      snippets = { preset = "luasnip" },

      keymap = {
        preset = "none",
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "cancel", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = {
          "snippet_forward",
          "select_and_accept",
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
        kind_icons = icons.kinds,
      },

      completion = {
        keyword = { range = "prefix" },
        trigger = { show_on_trigger_character = true },
        list = { selection = { preselect = true, auto_insert = true } },
        accept = { auto_brackets = { enabled = true } },
        ghost_text = { enabled = true },
        menu = {
          border = ui.border,
          winblend = ui.opacity.float,
          scrollbar = false,
          max_height = 12,
          draw = {
            padding = ui.space.xs,
            gap = ui.space.xs,
            treesitter = { "lsp" },
            columns = {
              { "kind_icon" },
              { "label", "label_description", gap = 1 },
              { "kind" },
              { "source_name" },
            },
            components = {
              kind_icon = {
                text = function(ctx)
                  return (ctx.kind_icon or "") .. (ctx.icon_gap or " ")
                end,
              },
              source_name = {
                text = function(ctx)
                  return ctx.source_name and (" " .. ctx.source_name) or ""
                end,
                highlight = "BlinkCmpSource",
              },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 150,
          window = { border = ui.border, winblend = ui.opacity.float },
        },
      },

      signature = {
        enabled = true,
        window = { border = ui.border, winblend = ui.opacity.float },
      },

      sources = {
        default = { "lsp", "path", "snippets", "buffer", "ripgrep" },
        per_filetype = {
          sql = { "dadbod", "snippets", "buffer" },
          mysql = { "dadbod", "snippets", "buffer" },
        },
        providers = {
          lsp = { name = "LSP", score_offset = 90 },
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
