-- return { -- Collection of various small independent plugins/modules
-- 	"echasnovski/mini.nvim",
-- 	config = function()
-- 		-- 		-- Better Around/Inside textobjects
-- 		-- 		--
-- 		-- 		-- Examples:
-- 		-- 		--  - va)  - [V]isually select [A]round [)]paren
-- 		-- 		--  - yinq - [Y]ank [I]nside [N]ext [']quote
-- 		-- 		--  - ci'  - [C]hange [I]nside [']quote
-- 		-- 		require("mini.ai").setup({ n_lines = 500 })

-- 		-- 		-- Add/delete/replace surroundings (brackets, quotes, etc.)
-- 		-- 		--
-- 		-- 		-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
-- 		-- 		-- - sd'   - [S]urround [D]elete [']quotes
-- 		-- 		-- - sr)'  - [S]urround [R]eplace [)] [']
-- 		-- 		require("mini.surround").setup()

-- 		-- 		-- Simple and easy statusline.
-- 		-- 		--  You could remove this setup call if you don't like it,
-- 		-- 		--  and try some other statusline plugin
-- 		-- 		local statusline = require("mini.statusline")
-- 		-- 		-- set use_icons to true if you have a Nerd Font
-- 		-- 		statusline.setup({ use_icons = vim.g.have_nerd_font })

-- 		-- 		-- You can configure sections in the statusline by overriding their
-- 		-- 		-- default behavior. For example, here we set the section for
-- 		-- 		-- cursor location to LINE:COLUMN
-- 		-- 		---@diagnostic disable-next-line: duplicate-set-field
-- 		-- 		statusline.section_location = function()
-- 		-- 			return "%2l:%-2v"
-- 		-- 		end

-- 		-- 		-- ... and there is more!
-- 		--  Check out: https://github.com/echasnovski/mini.nvim
-- 	end,
-- }
return {
	"nvim-lualine/lualine.nvim",
	event = "ColorScheme",
	config = function()
	-- Bubbles config for lualine
-- Author: lokesh-krishna
-- MIT license, see LICENSE for more details.

-- stylua: ignore
local colors = {
  blue   = '#80a0ff',
  cyan   = '#79dac8',
  black  = '#080808',
  white  = '#c6c6c6',
  red    = '#ff5189',
  violet = '#d183e8',
  grey   = '#303030',
}

		local bubbles_theme = {
			normal = {
				a = { fg = colors.black, bg = colors.violet },
				b = { fg = colors.white, bg = colors.grey },
				c = { fg = colors.white },
			},

			insert = { a = { fg = colors.black, bg = colors.blue } },
			visual = { a = { fg = colors.black, bg = colors.cyan } },
			replace = { a = { fg = colors.black, bg = colors.red } },

			inactive = {
				a = { fg = colors.white, bg = colors.black },
				b = { fg = colors.white, bg = colors.black },
				c = { fg = colors.white },
			},
		}

		require("lualine").setup({
			options = {
				theme = bubbles_theme,
				component_separators = "",
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
				lualine_b = { "filename", "branch" },
				lualine_c = {
					"%=", --[[ add your center compoentnts here in place of this comment ]]
				},
				lualine_x = {},
				lualine_y = { "filetype", "progress" },
				lualine_z = {
					{ "location", separator = { right = "" }, left_padding = 2 },
				},
			},
			inactive_sections = {
				lualine_a = { "filename" },
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = { "location" },
			},
			tabline = {},
			extensions = {},
		})
	end,
}
