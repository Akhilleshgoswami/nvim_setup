-- Optional colorschemes. Umbra is the handcrafted default (see themes/umbra);
-- switch to any of these with `:Theme`. They stay lazy — only the saved theme
-- loads at startup.
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
      background = { dark = "mocha", light = "latte" },
      integrations = {
        blink_cmp = true,
        gitsigns = true,
        treesitter = true,
        notify = true,
        noice = true,
        mason = true,
        neotree = true,
        which_key = true,
        harpoon = true,
        flash = true,
        aerial = true,
        dropbar = { enabled = true },
        indent_blankline = { enabled = true },
        native_lsp = { enabled = true },
        telescope = { enabled = true },
        render_markdown = true,
      },
    },
  }),

  theme({ "folke/tokyonight.nvim", opts = { style = "night" } }),

  theme({ "rebelot/kanagawa.nvim", opts = { theme = "wave" } }),

  theme({ "rose-pine/neovim", name = "rose-pine", opts = { variant = "auto", dark_variant = "main" } }),

  theme({ "ellisonleao/gruvbox.nvim", opts = { contrast = "soft" } }),

  theme({ "neanias/everforest-nvim", name = "everforest", opts = { background = "medium" } }),

  theme({ "olimorris/onedarkpro.nvim", opts = {} }),

  theme({ "EdenEast/nightfox.nvim", opts = {} }),

  theme({ "nyoom-engineering/oxocarbon.nvim" }),

  theme({ "gbprod/nord.nvim", opts = {} }),
}
