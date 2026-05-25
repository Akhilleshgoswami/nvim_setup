-- ============================================================
--  lua/akhilesh/plugins/colorscheme.lua
--  Unified base theme : Tokyonight Night
--  Modern, polished, plugin-aware
-- ============================================================

return {

  -- ========================================================
  -- ACTIVE THEME : TOKYONIGHT NIGHT
  -- ========================================================
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,

    opts = {
      style = "night",
      light_style = "day",
      transparent = false,
      terminal_colors = true,

      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = { bold = true },
        variables = {},
        sidebars = "dark",
        floats = "dark",
      },

      sidebars = {
        "qf",
        "help",
        "terminal",
        "lazy",
        "Trouble",
        "neo-tree",
        "snacks_dashboard",
      },

      day_brightness = 0.3,
      dim_inactive = false,
      lualine_bold = true,

      -- ----------------------------------------------------
      -- COLOR OVERRIDES : a touch more vibrant
      -- ----------------------------------------------------
      on_colors = function(c)
        c.border = "#1f2335"
        c.bg_dark = "#16161e"
        c.bg_float = "#16161e"
        c.bg_sidebar = "#16161e"
        c.bg_statusline = "#16161e"
        c.fg_gutter = "#3b4261"
      end,

      -- ----------------------------------------------------
      -- HIGHLIGHT OVERRIDES : polish every surface
      -- ----------------------------------------------------
      on_highlights = function(hl, c)
        -- Floats / popups
        hl.NormalFloat = { bg = c.bg_dark }
        hl.FloatBorder = { fg = c.blue, bg = c.bg_dark }
        hl.FloatTitle  = { fg = c.blue, bg = c.bg_dark, bold = true }

        -- Cursor line : subtle background, cleaner number indicator
        hl.CursorLine   = { bg = "#1f2335" }
        hl.CursorLineNr = { fg = c.orange, bg = "#1f2335", bold = true }
        hl.LineNr       = { fg = c.fg_gutter }
        hl.LineNrAbove  = { fg = c.fg_gutter }
        hl.LineNrBelow  = { fg = c.fg_gutter }

        -- Sign column : transparent so signs don't get a backdrop
        hl.SignColumn        = { bg = "NONE" }
        hl.SignColumnSB      = { bg = "NONE" }
        hl.FoldColumn        = { bg = "NONE", fg = c.fg_gutter }

        -- Folds
        hl.Folded = { bg = "NONE", fg = c.comment, italic = true }

        -- Visual selection
        hl.Visual = { bg = "#283457" }

        -- Word under cursor : subtle underline (not a hard box)
        hl.LspReferenceText  = { underline = true, sp = c.cyan, bg = "NONE" }
        hl.LspReferenceRead  = { underline = true, sp = c.green, bg = "NONE" }
        hl.LspReferenceWrite = { underline = true, sp = c.orange, bg = "NONE" }
        hl.SnacksWordsRead   = { underline = true, sp = c.cyan, bg = "NONE" }
        hl.SnacksWordsWrite  = { underline = true, sp = c.orange, bg = "NONE" }
        hl.MatchParen        = { fg = c.orange, bold = true, underline = true, bg = "NONE" }

        -- Diagnostics : softer undercurl
        hl.DiagnosticUnderlineError = { undercurl = true, sp = c.error }
        hl.DiagnosticUnderlineWarn  = { undercurl = true, sp = c.warning }
        hl.DiagnosticUnderlineInfo  = { undercurl = true, sp = c.info }
        hl.DiagnosticUnderlineHint  = { undercurl = true, sp = c.hint }

        hl.DiagnosticVirtualTextError = { fg = c.error,   bg = "NONE", italic = true }
        hl.DiagnosticVirtualTextWarn  = { fg = c.warning, bg = "NONE", italic = true }
        hl.DiagnosticVirtualTextInfo  = { fg = c.info,    bg = "NONE", italic = true }
        hl.DiagnosticVirtualTextHint  = { fg = c.hint,    bg = "NONE", italic = true }

        -- Gitsigns : keep slim foreground bars only, no background
        hl.GitSignsAdd    = { fg = c.green,  bg = "NONE" }
        hl.GitSignsChange = { fg = c.yellow, bg = "NONE" }
        hl.GitSignsDelete = { fg = c.red,    bg = "NONE" }

        -- Telescope
        hl.TelescopeNormal       = { bg = c.bg_dark, fg = c.fg }
        hl.TelescopeBorder       = { bg = c.bg_dark, fg = c.bg_dark }
        hl.TelescopePromptNormal = { bg = "#1f2335", fg = c.fg }
        hl.TelescopePromptBorder = { bg = "#1f2335", fg = "#1f2335" }
        hl.TelescopePromptTitle  = { bg = c.blue, fg = c.bg_dark, bold = true }
        hl.TelescopePreviewTitle = { bg = c.green, fg = c.bg_dark, bold = true }
        hl.TelescopeResultsTitle = { bg = c.bg_dark, fg = c.bg_dark }
        hl.TelescopeSelection    = { bg = "#1f2335", fg = c.orange, bold = true }
        hl.TelescopeMatching     = { fg = c.yellow, bold = true }
        hl.TelescopePromptPrefix = { bg = "#1f2335", fg = c.red }

        -- WhichKey
        hl.WhichKey         = { fg = c.cyan, bold = true }
        hl.WhichKeyGroup    = { fg = c.purple, bold = true }
        hl.WhichKeyDesc     = { fg = c.fg }
        hl.WhichKeySeparator= { fg = c.comment }
        hl.WhichKeyFloat    = { bg = c.bg_dark }
        hl.WhichKeyBorder   = { fg = c.blue, bg = c.bg_dark }

        -- Bufferline / Tabline
        hl.TabLineFill = { bg = c.bg_dark }

        -- Notify
        hl.NotifyBackground = { bg = c.bg_dark }

        -- Indent-blankline : let the indent plugin own these (set in indentaion.lua)
        -- We just clear any built-in highlight here.
        hl.IblIndent     = { fg = "NONE" }
        hl.IblWhitespace = { fg = "NONE" }
      end,
    },

    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },

  -- ========================================================
  -- ALTERNATES : available, but not active
  -- ========================================================
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    opts = { flavour = "mocha", transparent_background = false },
  },

  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    opts = { variant = "moon" },
  },

  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    opts = { theme = "wave" },
  },

  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
    opts = { contrast = "hard" },
  },

  -- ========================================================
  -- QUICK PICKER
  -- ========================================================
  {
    "LazyVim/LazyVim",
    config = function()
      vim.keymap.set("n", "<leader>cs", function()
        if pcall(require, "snacks") then
          require("snacks").picker.colorschemes()
        else
          vim.cmd("Telescope colorscheme")
        end
      end, { desc = "Pick colorscheme" })
    end,
  },
}

