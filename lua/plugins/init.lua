return {
  "nvim-lua/plenary.nvim",
  "christoomey/vim-tmux-navigator",

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        "williamboman/mason-lspconfig.nvim",
      },
      {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
      },
      {
        "j-hui/fidget.nvim",
        opts = {
          progress = {
            display = {
              done_icon = "",
              progress_icon = { pattern = "dots", period = 1 },
              override_lsp_progress = true,
            },
          },
          notification = {
            window = { border = "rounded", winblend = 0 },
          },
        },
      },
      { "folke/lazydev.nvim", ft = "lua", opts = {} },
    },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "stylua",
          "prettier",
          "prettierd",
        },
      })
      require "configs.lspconfig"
    end,
  },

  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "ConformInfo" },
    opts = require "configs.conform",
  },
}
