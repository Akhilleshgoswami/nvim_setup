return {
  "saghen/blink.cmp",

  version = "1.*",
  lazy = false,

  dependencies = {
    "rafamadriz/friendly-snippets",
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
        function()
          return require("sidekick").nes_jump_or_apply()
        end,
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
    require("blink.cmp").setup(opts)

    -- ======================================================
    -- THEME MATCHING
    -- ======================================================

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

      blue    = hl("Function", "fg") or "#7aa2f7",
      green   = hl("String", "fg") or "#9ece6a",
      yellow  = hl("Type", "fg") or "#e0af68",
      red     = hl("DiagnosticError", "fg") or "#f7768e",
      cyan    = hl("Keyword", "fg") or "#7dcfff",
      purple  = hl("Statement", "fg") or "#bb9af7",
      comment = hl("Comment", "fg") or "#565f89",
    }

    local function set_hl()
      local set = vim.api.nvim_set_hl

      -- Main Menu
      set(0, "BlinkCmpMenu", {
        fg = colors.fg,
        bg = colors.bg,
      })

      set(0, "BlinkCmpMenuBorder", {
        fg = colors.comment,
        bg = colors.bg,
      })

      -- Documentation
      set(0, "BlinkCmpDoc", {
        fg = colors.fg,
        bg = colors.bg,
      })

      set(0, "BlinkCmpDocBorder", {
        fg = colors.comment,
        bg = colors.bg,
      })

      -- Selection
      set(0, "BlinkCmpMenuSelection", {
        fg = colors.yellow,
        bg = "NONE",
        bold = true,
      })

      -- Labels
      set(0, "BlinkCmpLabel", {
        fg = colors.fg,
      })

      set(0, "BlinkCmpLabelMatch", {
        fg = colors.blue,
        bold = true,
      })

      set(0, "BlinkCmpLabelDetail", {
        fg = colors.comment,
      })

      set(0, "BlinkCmpLabelDeprecated", {
        fg = colors.red,
        strikethrough = true,
      })

      -- Source
      set(0, "BlinkCmpSource", {
        fg = colors.purple,
      })

      -- Kind Icons
      set(0, "BlinkCmpKindFunction", {
        fg = colors.blue,
      })

      set(0, "BlinkCmpKindMethod", {
        fg = colors.blue,
      })

      set(0, "BlinkCmpKindVariable", {
        fg = colors.cyan,
      })

      set(0, "BlinkCmpKindKeyword", {
        fg = colors.purple,
      })

      set(0, "BlinkCmpKindClass", {
        fg = colors.yellow,
      })

      set(0, "BlinkCmpKindModule", {
        fg = colors.green,
      })

      set(0, "BlinkCmpKindCopilot", {
        fg = colors.green,
      })

      -- Ghost text
      set(0, "BlinkCmpGhostText", {
        fg = colors.comment,
        italic = true,
      })

      -- Signature
      set(0, "BlinkCmpSignatureHelp", {
        fg = colors.fg,
        bg = colors.bg,
      })

      set(0, "BlinkCmpSignatureHelpBorder", {
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
  end,
}
