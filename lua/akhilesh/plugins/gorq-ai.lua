return {
	{
		"cdreetz/groq-nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("groq-nvim").setup({
				api_key = "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", -- replace with your actual key or use ENV
				model = "llama3-70b-8192",
			})
		end,
		event = "VeryLazy", -- Optional: load lazily to speed up startup
	},
}
