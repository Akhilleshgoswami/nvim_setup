return {
  "saghen/blink.cmp",

  version = "1.*",
  lazy = false,

  dependencies = {
    "rafamadriz/friendly-snippets",
    "L3MON4D3/LuaSnip",
    "fang2hou/blink-copilot",
    "mikavilpas/blink-ripgrep.nvim",
  },

  opts = {
    -- ======================================================
    -- KEYMAPS
    -- ======================================================

    keymap = {
      preset = "enter",

      ["<Tab>"] = {
        "snippet_forward",
        "select_next",
        "fallback",
      },

      ["<S-Tab>"] = {
        "snippet_backward",
        "select_prev",
        "fallback",
      },

      ["<C-space>"] = {
        "show",
        "show_documentation",
        "hide_documentation",
      },

      ["<C-e>"] = {
        "hide",
        "fallback",
      },

      ["<C-j>"] = {
        "scroll_documentation_down",
        "fallback",
      },

      ["<C-k>"] = {
        "scroll_documentation_up",
        "fallback",
      },

      ["<CR>"] = {
        "accept",
        "fallback",
      },
    },

    -- ======================================================
    -- APPEARANCE
    -- ======================================================

    appearance = {
      nerd_font_variant = "mono",

      use_nvim_cmp_as_default = false,

      kind_icons = {
        Text          = "󰉿",
        Method        = "󰊕",
        Function      = "󰊕",
        Constructor   = "󰒓",
        Field         = "󰜢",
        Variable      = "󰆦",
        Property      = "󰖷",
        Class         = "󱡠",
        Interface     = "󱡠",
        Struct        = "󱡠",
        Module        = "󰅩",
        Unit          = "󰪚",
        Value         = "󰦨",
        Enum          = "󰦨",
        EnumMember    = "󰦨",
        Keyword       = "󰻾",
        Constant      = "󰏿",
        Snippet       = "󱄽",
        Color         = "󰏘",
        File          = "󰈔",
        Reference     = "󰬲",
        Folder        = "󰉋",
        Event         = "󱐋",
        Operator      = "󰪚",
        TypeParameter = "󰬛",
        Copilot       = "",
      },
    },

    -- ======================================================
    -- COMPLETION
    -- ======================================================

    completion = {
      keyword = {
        range = "full",
      },

      accept = {
        auto_brackets = {
          enabled = true,
        },
      },

      ghost_text = {
        enabled = true,
      },

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

          components = {
            label = {
              width = { fill = true, max = 60 },
              text = function(ctx)
                return ctx.label
              end,

              highlight = function(ctx)
                local highlights = {
                  {
                    0,
                    #ctx.label,
                    group = ctx.deprecated
                        and "BlinkCmpLabelDeprecated"
                      or "BlinkCmpLabel",
                  },
                }

                if ctx.label_detail then
                  table.insert(highlights, {
                    #ctx.label,
                    #ctx.label + #ctx.label_detail,
                    "BlinkCmpLabelDetail",
                  })
                end

                for _, idx in ipairs(ctx.label_matched_indices) do
                  table.insert(highlights, {
                    idx,
                    idx + 1,
                    "BlinkCmpLabelMatch",
                  })
                end

                return highlights
              end,
            },
          },
        },
      },

      documentation = {
        auto_show = true,
        auto_show_delay_ms = 150,

        window = {
          border = "rounded",
          scrollbar = false,
          winblend = 0,
        },
      },
    },

    -- ======================================================
    -- SIGNATURE
    -- ======================================================

    signature = {
      enabled = true,

      window = {
        border = "rounded",
        winblend = 0,
      },
    },

    -- ======================================================
    -- SOURCES
    -- ======================================================

    sources = {
      default = {
        "lsp",
        "path",
        "snippets",
        "buffer",
        "copilot",
        "ripgrep",
      },

      per_filetype = {
        sql = {
          "dadbod",
          "lsp",
          "buffer",
        },

        mysql = {
          "dadbod",
          "lsp",
          "buffer",
        },

        plsql = {
          "dadbod",
          "lsp",
          "buffer",
        },
      },

      providers = {
        -- LSP
        lsp = {
          name = "LSP",

          score_offset = 90,

          fallbacks = {
            "buffer",
          },
        },

        -- Copilot
        copilot = {
          module = "blink-copilot",
          name = "Copilot",

          score_offset = 100,

          async = true,

          opts = {
            max_completions = 3,
            max_attempts = 2,
          },
        },

        -- Ripgrep
        ripgrep = {
          module = "blink-ripgrep",

          name = "Ripgrep",

          score_offset = -5,

          opts = {
            prefix_min_len = 4,
            context_size = 5,
            max_filesize = "1MB",
          },
        },

        -- Dadbod
        dadbod = {
          name = "Dadbod",
          module = "vim_dadbod_completion.blink",
        },

        -- Buffer
        buffer = {
          score_offset = -10,

          opts = {
            get_bufnrs = function()
              return vim.tbl_map(
                vim.api.nvim_win_get_buf,
                vim.api.nvim_list_wins()
              )
            end,
          },
        },
      },
    },

    -- ======================================================
    -- CMDLINE
    -- ======================================================

    cmdline = {
      enabled = false,

      completion = {
        menu = {
          auto_show = true,
        },
      },

      keymap = {
        preset = "enter",
      },
    },
  },

  opts_extend = {
    "sources.default",
  },

  config = function(_, opts)
    local luasnip_ok, luasnip_loaders = pcall(require, "luasnip.loaders.from_vscode")
    if luasnip_ok then
      luasnip_loaders.lazy_load()
    end
    pcall(require("luasnip.loaders.from_lua").load, {
      paths = vim.fn.stdpath("config") .. "/snippets",
    })

    require("blink.cmp").setup(opts)
    -- Completion highlights: akhilesh.ui (ColorScheme autocmd)
  end,
}
