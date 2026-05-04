return {
  "mmsaki/forgefmt.nvim",
  config = function()
    require("forgefmt").setup({
      auto_format = true, -- enable autoformat on save
    })
    vim.keymap.set("n", "<leader>f", ":ForgeFmt<CR>", { desc = "Forge Format" })
  end,
}
