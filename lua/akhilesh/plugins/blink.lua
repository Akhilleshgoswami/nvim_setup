return {
  "saghen/blink.cmp",
  lazy = false,
  dependencies = {
    "rafamadriz/friendly-snippets",
    "fang2hou/blink-copilot",
    "mikavilpas/blink-ripgrep.nvim",
  },
  version = "1.*",

  opts = {
    -- ── Keymaps ───────────────────────────────────────────────
    keymap = {
      preset = "enter",
      ["<Tab>"] = {
        function() return require("sidekick").nes_jump_or_apply() end,
        "snippet_forward",
        "fallback",
      },
      ["<S-Tab>"] = {
        "snippet_backward",
        "fallback",
      },
      ["<C-k>"] = { "scroll_documentation_up",   "fallback" },
      ["<C-j>"] = { "scroll_documentation_down", "fallback" },
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide", "fallback" },
    },

    -- ── Appearance ────────────────────────────────────────────
    appearance = {
      nerd_font_variant = "mono",
      kind_icons = {
        Copilot    = "",
        Text       = "󰉿",
        Method     = "󰊕",
        Function   = "󰊕",
        Constructor = "󰒓",
        Field      = "󰜢",
        Variable   = "󰆦",
        Property   = "󰖷",
        Class      = "󱡠",
        Interface  = "󱡠",
        Struct     = "󱡠",
        Module     = "󰅩",
        Unit       = "󰪚",
        Value      = "󰦨",
        Enum       = "󰦨",
        EnumMember = "󰦨",
        Keyword    = "󰻾",
        Constant   = "󰏿",
        Snippet    = "󱄽",
        Color      = "󰏘",
        File       = "󰈔",
        Reference  = "󰬲",
        Folder     = "󰉋",
        Event      = "󱐋",
        Operator   = "󰪚",
        TypeParameter = "󰬛",
      },
    },

    -- ── Completion ────────────────────────────────────────────
    completion = {
      accept = {
        auto_brackets = { enabled = true }, -- auto insert brackets for functions
      },
      menu = {
        border      = "single",
        draw = {
          treesitter = { "lsp" }, -- treesitter highlighting in menu
          columns = {
            { "kind_icon" },
            { "label", "label_description", gap = 1 },
            { "source_name" },
          },
        },
      },
      documentation = {
        auto_show       = true,
        auto_show_delay_ms = 200,
        window = { border = "single" },
      },
      ghost_text = { enabled = true }, -- inline preview like copilot
    },

    -- ── Sources ───────────────────────────────────────────────
    sources = {
      default = { "lsp", "path", "snippets", "buffer", "copilot", "ripgrep" },
      -- dadbod only when in sql/db filetypes
      per_filetype = {
        sql       = { "dadbod", "lsp", "buffer" },
        mysql     = { "dadbod", "lsp", "buffer" },
        plsql     = { "dadbod", "lsp", "buffer" },
      },
      providers = {
        lsp = {
          name          = "LSP",
          score_offset  = 90,
          fallbacks     = { "buffer" },
        },
        copilot = {
          name         = "copilot",
          module       = "blink-copilot",
          score_offset = 100,
          async        = true,
          opts = {
            max_completions     = 3,
            max_attempts        = 2,
          },
        },
        ripgrep = {
          module = "blink-ripgrep",
          name   = "Ripgrep",
          score_offset = -5, -- lower priority than lsp/copilot
          opts = {
            prefix_min_len      = 4, -- only trigger after 4 chars
            context_size        = 5,
            max_filesize        = "1MB",
          },
        },
        dadbod = {
          name   = "Dadbod",
          module = "vim_dadbod_completion.blink",
        },
        buffer = {
          score_offset = -10, -- lowest priority
          opts = {
            get_bufnrs = function() -- all visible buffers, not just current
              return vim.tbl_map(
                vim.api.nvim_win_get_buf,
                vim.api.nvim_list_wins()
              )
            end,
          },
        },
      },
    },

    -- ── Cmdline ───────────────────────────────────────────────
    cmdline = {
      enabled    = false,
      completion = { menu = { auto_show = true } },
      keymap     = { preset = "enter" },
    },

    -- ── Signature ─────────────────────────────────────────────
    signature = {
      enabled = true,
      window  = { border = "single" },
    },
  },

  opts_extend = { "sources.default" },
}
