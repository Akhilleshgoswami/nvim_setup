-- ============================================================
--  lua/akhilesh/plugins/ui-polish.lua
--  PREMIUM UI ENHANCEMENTS
--  Noice + Dressing for beautiful notifications & input
-- ============================================================

return {
	-- ========================================================
	-- NOICE: BEAUTIFUL UI FOR MESSAGES, CMDLINE, POPUPMENU
	-- ========================================================
	{
		"folke/noice.nvim",
		event = "VeryLazy",

		dependencies = {
			"MunifTanjim/nui.nvim",
		},

		config = function()
			local ui = require("akhilesh.ui")
			local c = ui.colors()

			require("noice").setup({
				-- ====================================================
				-- MESSAGES
				-- ====================================================

				messages = {
					enabled = true,

					view = "notify",
					view_error = "notify",
					view_warn = "notify",
					view_history = "messages",
					view_search = "virtualtext",
				},

				-- ====================================================
				-- CMDLINE
				-- ====================================================

				cmdline = {
					enabled = true,

					view = "cmdline_popup",

					format = {
						cmdline = {
							pattern = "^:",
							icon = " ",
							lang = "vim",
						},

						search_down = {
							kind = "search",
							pattern = "^/",
							icon = " ",
							lang = "regex",
						},

						search_up = {
							kind = "search",
							pattern = "^%?",
							icon = " ",
							lang = "regex",
						},

						filter = {
							pattern = "^:%s*!",
							icon = "$",
							lang = "bash",
						},

						lua = {
							pattern = "^:%s*lua%s+",
							icon = "󰢱",
							lang = "lua",
						},

						help = {
							pattern = "^:%s*h%s+",
							icon = "?",
						},
					},
				},

				-- ====================================================
				-- POPUPMENU (AUTOCOMPLETE)
				-- ====================================================

				popupmenu = {
					enabled = false,
					backend = "nui",
				},

				-- ====================================================
				-- LSPSIGNATURE
				-- ====================================================

				lsp = {
					progress = {
						enabled = true,
						format = "lsp_progress",
						format_done = "lsp_progress_done",
						throttle_ms = 100,

						view = "mini",
					},

					signature = {
						auto_open = {
							enabled = true,
						},
					},

					hover = {
						enabled = false,
					},

					message = {
						enabled = true,
					},

					documentation = {
						view = "hover",

						opts = {
							lang = "markdown",

							replace = true,
							render = "plain",

							format = { "{message}" },

							win_options = {
								concealcursor = "n",
								conceallevel = 2,
							},
						},
					},

					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
					},
				},

				-- ====================================================
				-- ROUTES
				-- ====================================================

				routes = {
					{
						filter = {
							event = "msg_show",
							any = {
								{ find = "%d+L, %d+B" },
								{ find = "; after #%d+" },
								{ find = "; before #%d+" },
								{ find = "%d+ fewer lines" },
								{ find = "%d+ more lines" },
							},
						},

						view = "mini",
					},

					{
						filter = {
							event = "lsp",
							kind = "message",
						},

						view = "mini",
					},
				},

				-- ====================================================
				-- VIEWS
				-- ====================================================

				views = {
					cmdline_popup = {
						position = {
							row = "85%",
							col = "50%",
						},
						size = {
							width = 64,
							height = "auto",
						},
						border = {
							style = "rounded",
							padding = { 0, 1 },
						},
						win_options = {
							winblend = ui.winblend,
							winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
						},
					},

					popupmenu = {
						relative = "editor",
						position = {
							row = 8,
							col = "50%",
						},

						size = {
							width = 60,
							height = 10,
						},

						border = {
							style = "rounded",
							padding = { 0, 1 },
						},

						win_options = {
							winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
						},
					},

					notify = {
						view = "notify",
					},

					mini = {
						view = "mini",
					},
				},

				-- ====================================================
				-- FORMAT
				-- ====================================================

				format = {
					level = {
						icons = {
							trace = "󰢱",
							debug = "",
							info = "󰋼",
							warn = "",
							error = "",
						},
					},
				},

				-- ====================================================
				-- STATUS
				-- ====================================================

				status = {
					hl_group = "NoiceStatusline",
				},
			})

			-- Highlights synced with unified UI palette
			vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = c.blue, bg = c.bg_float })
			vim.api.nvim_set_hl(0, "NoiceCmdlinePopupTitle", { fg = c.bg_dark, bg = c.blue, bold = true })
			vim.api.nvim_set_hl(0, "NoiceMini", { bg = c.bg_float, fg = c.fg_muted })
		end,
	},

	-- ========================================================
	-- DRESSING: BEAUTIFUL INPUT & SELECT UI
	-- ========================================================
	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",

		opts = {
			-- ====================================================
			-- INPUT
			-- ====================================================

			input = {
				enabled = true,

				default_prompt = "➜ ",

				prompt_align = "left",

				insert_only = true,

				start_in_insert = true,

				border = "rounded",
				prefer_width = 48,

				width = nil,

				max_width = { 140, 0.9 },

				min_width = { 20, 0.2 },

				relative = "cursor",

				position = "top",

				zindex = 1001,

				win_options = {
					winhighlight = "NormalFloat:Normal,FloatBorder:FloatBorder",
					winblend = 10,
				},

				get_config = nil,
			},

			-- ====================================================
			-- SELECT
			-- ====================================================

			select = {
				enabled = true,

				backend = { "builtin", "fzf" },

				trim_prompt = true,

				format_item_override = {},

				get_config = function(opts)
					if opts.kind == "codeaction" then
						return {
							backend = "builtin",

							max_width = { 200, 0.8 },

							min_width = { 20, 0.2 },

							width = nil,

							max_height = 0.9,

							min_height = { 10, 0.2 },

							relative = "editor",

							position = "50%",

							border = "rounded",

							zindex = 1001,

							win_options = {
								winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
								winblend = 10,
							},
						}
					end

					return {
						backend = "builtin",

						max_width = { 80, 0.8 },

						min_width = { 20, 0.2 },

						width = nil,

						max_height = 0.9,

						min_height = { 10, 0.2 },

						relative = "editor",

						position = "50%",

						border = "rounded",

						zindex = 1001,

						win_options = {
							winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
							winblend = 10,
						},
					}
				end,
			},
		},
	},
}
