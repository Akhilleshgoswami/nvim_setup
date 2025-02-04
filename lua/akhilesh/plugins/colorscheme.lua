return {
	-- You can easily change to a different colorscheme.
	-- Change the name of the colorscheme plugin below, and then
	-- change the command in the config to whatever the name of that colorscheme is.
	-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
	"askfiy/visual_studio_code",
	priority = 1000, -- Make sure to load this before all the other start plugins.
	config = function()
		-- 		require("catppuccin").setup({
		-- 			transparent_background = true,
		-- 		})
		-- 		-- Optional: Configure highlights if needed
		-- 		vim.cmd([[
		-- augroup TransparentBackground
		-- autocmd!
		-- autocmd ColorScheme * highlight Normal ctermbg=none guibg=none
		-- autocmd ColorScheme * highlight NonText ctermbg=none guibg=none
		-- augroup END
		--
		-- ]])
		vim.cmd.colorscheme("visual_studio_code")
	end,
}
