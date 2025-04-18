return {
	"romgrk/barbar.nvim",
	dependencies = {
		"lewis6991/gitsigns.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	init = function()
		vim.g.barbar_auto_setup = false
	end,
	opts = {
		-- animation = true,
		-- insert_at_start = true,
		-- icons = {
		-- 	buffer_index = false,
		-- 	buffer_number = false,
		-- 	button = "",
		-- 	filetype = {
		-- 		custom_colors = false,
		-- 		enabled = true,
		-- 	},
		-- 	separator = { left = "▎", right = "" },
		-- 	separator_at_end = true,
		-- 	modified = { button = "●" },
		-- 	preset = "default",
		-- 	alternate = { filetype = { enabled = false } },
		-- 	current = { buffer_index = true },
		-- 	inactive = { button = "×" },
		-- 	visible = { modified = { buffer_number = false } },
	},
	version = "^1.0.0",
}
