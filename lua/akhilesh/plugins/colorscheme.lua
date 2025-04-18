return {

	-- Or with configuration

	"catppuccin/nvim",
	lazy = false, -- make sure we load this during startup if it is your main colorscheme
	priority = 1000, -- make sure to load this before all the other start plugins
	config = function()
		-- require("github-theme").setup({
		-- 	-- ...
		-- })

		vim.cmd("colorscheme catppuccin-mocha")
	end,
}
