return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,
  priority = 1000,
  config = function()
    require("nvim-treesitter").setup({
      ensure_installed = {
        "bash", "c", "diff", "html", "lua",
        "go", "vim", "vimdoc", "javascript", "typescript",
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
    })
  end,
}

