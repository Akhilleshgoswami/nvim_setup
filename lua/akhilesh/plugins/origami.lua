return {
	{
		"chrisgrieser/nvim-origami",
		event = "VeryLazy",

		opts = {
			foldKeymaps = {
				setup = false,
			},
		},

		config = function()
			vim.opt.foldmethod = "expr"
			vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
			vim.opt.foldenable = true
			vim.opt.foldlevel = 99
			vim.opt.foldlevelstart = 99
			vim.opt.cursorline = true

			vim.opt.signcolumn = "no"
			vim.opt.foldcolumn = "0"

			vim.opt.fillchars = {
				fold = " ",
				foldopen = "",
				foldclose = "",
				foldsep = " ",
				eob = " ",
			}

			vim.opt.winborder = "rounded"

			vim.opt.list =false
			vim.opt.listchars = {
				tab = "→ ",
				trail = "·",
				nbsp = "␣",
			}
		end,
	},
}
