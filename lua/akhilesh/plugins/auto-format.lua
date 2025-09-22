return {
	"stevearc/conform.nvim",
	lazy = false,
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "",
			desc = "[F]ormat buffer",
		},
	},
	opts = {
		notify_on_error = false,
		format_on_save = false, -- Disable auto-format on save
		formatters_by_ft = {
			typescript = { "prettiered" },
			javascriptreact = { "prettiered" },
			typescriptreact = { "prettiered" },
   go={"gofmt"},
   solidity = {"prettiered"}
			-- Add other filetypes as needed
		},
		-- Prettier-specific settings for consistent indentation
		prettier = {
			tabWidth = 2, -- Use 2 spaces for indentation
			useTabs = false, -- Use spaces instead of tabs
		},
	},
}
