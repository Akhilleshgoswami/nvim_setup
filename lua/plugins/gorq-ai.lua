return {
  {
    "cdreetz/groq-nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    config = function()
      require("groq-nvim").setup({
        api_key = vim.env.GROQ_API_KEY,
        model = "llama3-70b-8192",
      })
    end,
  },
}
