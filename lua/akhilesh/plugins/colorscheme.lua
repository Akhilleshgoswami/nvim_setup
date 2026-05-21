-- lua/akhilesh/plugins/colorscheme.lua
return {
  -- ── Schemes ────────────────────────────────────────────────
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      style       = "night", -- night | storm | moon | day
      transparent = false,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
      },
    },
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    opts = {
      flavour = "mocha", -- latte | frappe | macchiato | mocha
    },
  },

  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    opts = {
      variant = "moon", -- auto | main | moon | dawn
    },
  },

  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    opts = {
      theme = "wave", -- wave | dragon | lotus
    },
  },

  -- ── Active scheme (change this one line to switch) ─────────
  {
    "ellisonleao/gruvbox.nvim",
    lazy    = false,
    priority = 1000,
    opts = { contrast = "hard" },
    config = function(_, opts)
      require("gruvbox").setup(opts)
      vim.cmd.colorscheme("gruvbox")
    end,
  },
  vim.keymap.set("n", "<leader>cs", function()
  Snacks.picker.colorschemes()
end, { desc = "Pick colorscheme"})
}

