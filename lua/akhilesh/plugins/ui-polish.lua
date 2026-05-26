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
			"rcarriga/nvim-notify",
		},

		config = function()
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
					enabled = true,
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
						["cmp.entry.get_documentation"] = true,
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
							row = 5,
							col = "50%",
						},

						size = {
							width = 60,
							height = "auto",
						},

						border = {
							style = "rounded",
							padding = { 1, 2 },
						},

						filter_options = {},

						win_options = {
							winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
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

			-- Highlights
			local c = {
				bg = "#0a0e18",
				fg = "#e0e8f4",
				blue = "#7aa2f7",
				cyan = "#7dcfff",
				yellow = "#f2cc60",
				red = "#f7768e",
				green = "#9ece6a",
			}

			vim.api.nvim_set_hl(0, "NoiceStatusline", { bg = c.bg, fg = c.blue })
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

				prefer_width = 40,

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

	-- ========================================================
	-- NVIM-NOTIFY: BEAUTIFUL NOTIFICATIONS
	-- ========================================================
	{
		"rcarriga/nvim-notify",
		event = "VeryLazy",

		config = function()
			local notify = require("notify")

			notify.setup({
				fps = 60,

				render = "default",

				stages = "fade_in_slide_out",

				timeout = 3000,

				max_width = 80,

				max_height = 25,

				background_colour = "Normal",

				icons = {
					DEBUG = "",
					ERROR = "",
					INFO = "󰋼",
					TRACE = "󰢱",
					WARN = "",
				},

				on_open = nil,

				on_close = nil,

				should_notify = function(message, level)
					if level < 2 then
						return false
					end

					if message.event == "notify" and not message.message then
						return false
					end

					return true
				end,
			})

			vim.notify = notify

			-- Highlights
			local c = {
				bg = "#0a0e18",
				fg = "#e0e8f4",
				blue = "#7aa2f7",
				cyan = "#7dcfff",
				yellow = "#f2cc60",
				red = "#f7768e",
				green = "#9ece6a",
			}

			vim.api.nvim_set_hl(0, "NotifyINFOBody", { bg = "NONE", fg = c.fg })
			vim.api.nvim_set_hl(0, "NotifyWARNBody", { bg = "NONE", fg = c.fg })
			vim.api.nvim_set_hl(0, "NotifyERRORBody", { bg = "NONE", fg = c.fg })
			vim.api.nvim_set_hl(0, "NotifyDEBUGBody", { bg = "NONE", fg = c.fg })

			vim.api.nvim_set_hl(0, "NotifyINFOBorder", { fg = c.blue })
			vim.api.nvim_set_hl(0, "NotifyWARNBorder", { fg = c.yellow })
			vim.api.nvim_set_hl(0, "NotifyERRORBorder", { fg = c.red })
			vim.api.nvim_set_hl(0, "NotifyDEBUGBorder", { fg = c.cyan })
		end,
	},
}
