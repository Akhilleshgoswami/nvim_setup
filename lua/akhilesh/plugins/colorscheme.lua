-- lua/akhilesh/plugins/colorscheme.lua
return {
  -- ── Schemes ────────────────────────────────────────────────
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      style = "night",
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
      flavour = "mocha",
    },
  },

  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    opts = {
      variant = "moon",
    },
  },

  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    opts = {
      theme = "wave",
    },
  },

  -- ── Active scheme ─────────────────────────────────────────
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    opts = { contrast = "hard" },
    config = function(_, opts)
      require("gruvbox").setup(opts)
      vim.cmd.colorscheme("gruvbox")
    end,
  },

  -- ── Keymaps (PUT IN CONFIG, NOT HERE) ─────────────────────
  {
    "LazyVim/LazyVim",
    config = function()
      vim.keymap.set("n", "<leader>cs", function()
        -- fallback if Snacks exists
        if pcall(require, "snacks") then
          require("snacks").picker.colorschemes()
        else
          vim.cmd("Telescope colorscheme")
        end
      end, { desc = "Pick colorscheme" })
    end,
  },
}
