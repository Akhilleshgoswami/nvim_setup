return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    -- Only needed if you want a custom install dir; otherwise omit entirely
    require("nvim-treesitter").setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    -- Install parsers (async, no-op if already installed)
    require("nvim-treesitter").install({
      "bash", "c", "diff", "html",
      "lua", "go",
      "vim", "vimdoc", "typescript", "javascript",
    })
  end,
}
