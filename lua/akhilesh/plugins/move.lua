return {
	{
		"0xmovses/move.vim",
		ft = "move", -- Load the plugin only for .move files
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = { "move" }, -- Ensure Move language support
			highlight = {
				enable = true, -- Enable syntax highlighting
			},
		},
	},
}
