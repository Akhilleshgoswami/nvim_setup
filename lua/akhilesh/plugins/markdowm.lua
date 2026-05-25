return {
  "MeanderingProgrammer/render-markdown.nvim",

  ft = { "markdown", "Avante" },

  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-mini/mini.nvim",
  },

  opts = {
    -- ======================================================
    -- ENABLE
    -- ======================================================

    enabled = true,

    render_modes = true,

    anti_conceal = {
      enabled = true,
    },

    -- ======================================================
    -- HEADINGS
    -- ======================================================

    heading = {
      enabled = true,

      sign = false,

      position = "inline",

      icons = {
        "󰎤 ",
        "󰎧 ",
        "󰎪 ",
        "󰎭 ",
        "󰎱 ",
        "󰎳 ",
      },

      width = "block",

      left_pad = 1,
      right_pad = 1,

      backgrounds = {
        "RenderMarkdownH1Bg",
        "RenderMarkdownH2Bg",
        "RenderMarkdownH3Bg",
        "RenderMarkdownH4Bg",
        "RenderMarkdownH5Bg",
        "RenderMarkdownH6Bg",
      },

      foregrounds = {
        "RenderMarkdownH1",
        "RenderMarkdownH2",
        "RenderMarkdownH3",
        "RenderMarkdownH4",
        "RenderMarkdownH5",
        "RenderMarkdownH6",
      },
    },

    -- ======================================================
    -- CODE BLOCKS
    -- ======================================================

    code = {
      enabled = true,

      sign = false,

      width = "block",

      right_pad = 2,
      left_pad = 2,

      border = "thin",

      above = "▄",
      below = "▀",

      highlight = "RenderMarkdownCode",

      highlight_inline = "RenderMarkdownCodeInline",
    },

    -- ======================================================
    -- BLOCK QUOTES
    -- ======================================================

    quote = {
      enabled = true,

      icon = "▋",

      repeat_linebreak = false,
    },

    -- ======================================================
    -- BULLETS
    -- ======================================================

    bullet = {
      enabled = true,

      icons = {
        "●",
        "○",
        "◆",
        "◇",
      },
    },

    -- ======================================================
    -- CHECKBOXES
    -- ======================================================

    checkbox = {
      enabled = true,

      position = "inline",

      unchecked = {
        icon = "󰄱 ",
        highlight = "RenderMarkdownUnchecked",
      },

      checked = {
        icon = "󰱒 ",
        highlight = "RenderMarkdownChecked",
      },

      custom = {
        todo = {
          raw = "[-]",
          rendered = "󰥔 ",
          highlight = "RenderMarkdownTodo",
        },
      },
    },

    -- ======================================================
    -- TABLES
    -- ======================================================

    pipe_table = {
      enabled = true,

      preset = "round",
    },

    -- ======================================================
    -- LINKS
    -- ======================================================

    link = {
      enabled = true,

      hyperlink = "󰌹 ",

      image = "󰥶 ",

      email = "󰀓 ",
    },

    -- ======================================================
    -- LATEX
    -- ======================================================

    latex = {
      enabled = true,
    },

    -- ======================================================
    -- THEMING
    -- ======================================================

    overrides = function()
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

      local set = vim.api.nvim_set_hl

      -- ====================================================
      -- HEADINGS
      -- ====================================================

      set(0, "RenderMarkdownH1", {
        fg = colors.blue,
        bold = true,
      })

      set(0, "RenderMarkdownH2", {
        fg = colors.green,
        bold = true,
      })

      set(0, "RenderMarkdownH3", {
        fg = colors.yellow,
        bold = true,
      })

      set(0, "RenderMarkdownH4", {
        fg = colors.purple,
        bold = true,
      })

      set(0, "RenderMarkdownH5", {
        fg = colors.cyan,
        bold = true,
      })

      set(0, "RenderMarkdownH6", {
        fg = colors.red,
        bold = true,
      })

      set(0, "RenderMarkdownH1Bg", {
        bg = "NONE",
      })

      set(0, "RenderMarkdownH2Bg", {
        bg = "NONE",
      })

      set(0, "RenderMarkdownH3Bg", {
        bg = "NONE",
      })

      set(0, "RenderMarkdownH4Bg", {
        bg = "NONE",
      })

      set(0, "RenderMarkdownH5Bg", {
        bg = "NONE",
      })

      set(0, "RenderMarkdownH6Bg", {
        bg = "NONE",
      })

      -- ====================================================
      -- CODE
      -- ====================================================

      set(0, "RenderMarkdownCode", {
        bg = colors.bg,
      })

      set(0, "RenderMarkdownCodeInline", {
        fg = colors.green,
        bg = "NONE",
      })

      -- ====================================================
      -- CHECKBOX
      -- ====================================================

      set(0, "RenderMarkdownChecked", {
        fg = colors.green,
        bold = true,
      })

      set(0, "RenderMarkdownUnchecked", {
        fg = colors.comment,
      })

      set(0, "RenderMarkdownTodo", {
        fg = colors.yellow,
        bold = true,
      })
    end,
  },

  config = function(_, opts)
    require("render-markdown").setup(opts)

    -- ======================================================
    -- AUTO RELOAD COLORS
    -- ======================================================

    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.schedule(function()
          require("render-markdown").setup(opts)
        end)
      end,
    })
  end,
}
