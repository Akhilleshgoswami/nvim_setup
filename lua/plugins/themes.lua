-- Optional colorschemes. Catppuccin Mocha (transparent) is the default;
-- Umbra / Meridian remain first-party. Switch with `:Theme`.
--
-- Adding a theme: drop a spec here and, if its `:colorscheme` name isn't an
-- obvious prefix, teach `features/theme.lua` how to map name → plugin.

local function theme(spec)
  spec.lazy = true
  spec.priority = 1000
  return spec
end

return {
  theme({
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "mocha",
      transparent_background = true,
      float = { transparent = true },
      background = { dark = "mocha", light = "latte" },
      custom_highlights = function(colors)
        return {
          -- Fuzzy-match chars in results (was easy to miss on transparent bg).
          TelescopeMatching = { fg = colors.peach, bold = true },
          TelescopeSelection = { fg = colors.text, bg = colors.surface0, bold = true },
          TelescopeSelectionCaret = { fg = colors.peach, bg = colors.surface0, bold = true },
        }
      end,
      integrations = {
        alpha = true,
        blink_cmp = true,
        cmp = true,
        dashboard = true,
        gitsigns = true,
        treesitter = true,
        notify = true,
        noice = true,
        mason = true,
        neotree = true,
        nvimtree = true,
        which_key = true,
        harpoon = true,
        flash = true,
        aerial = true,
        dropbar = { enabled = true },
        indent_blankline = { enabled = true, scope_color = "lavender" },
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        telescope = { enabled = true },
        render_markdown = true,
        mini = true,
      },
    },
  }),

  theme({ "folke/tokyonight.nvim", opts = { style = "night", transparent = true } }),

  theme({ "rebelot/kanagawa.nvim", opts = { theme = "wave", transparent = true } }),

  theme({ "rose-pine/neovim", name = "rose-pine", opts = { variant = "auto", dark_variant = "main" } }),

  theme({ "ellisonleao/gruvbox.nvim", opts = { contrast = "soft", transparent_mode = true } }),

  theme({ "neanias/everforest-nvim", name = "everforest", opts = { background = "medium", transparent_background_level = 1 } }),

  theme({ "olimorris/onedarkpro.nvim", opts = {} }),

  theme({ "EdenEast/nightfox.nvim", opts = {} }),

  theme({ "nyoom-engineering/oxocarbon.nvim" }),

  theme({ "gbprod/nord.nvim", opts = {} }),

  theme({ "wtfox/luna.nvim", opts = {} }),

  theme({
    "nickkadutskyi/jb.nvim",
    name = "jb.nvim",
    opts = {},
  }),
}
