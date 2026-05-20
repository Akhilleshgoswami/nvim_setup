-- lua/akhilesh/plugins/lualine.lua
return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    event = "VeryLazy",
    config = function()
      local noice_ok, noice = pcall(require, "noice")

      -- Custom colors matching tokyonight-night
      local colors = {
        bg       = "#1a1b26",
        fg       = "#c0caf5",
        yellow   = "#e0af68",
        cyan     = "#7dcfff",
        darkblue = "#1f2335",
        green    = "#9ece6a",
        orange   = "#ff9e64",
        violet   = "#9d7cd8",
        magenta  = "#bb9af7",
        blue     = "#7aa2f7",
        red      = "#f7768e",
      }

      local conditions = {
        buffer_not_empty = function()
          return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
        end,
        hide_in_width = function()
          return vim.fn.winwidth(0) > 80
        end,
      }

      -- Custom mode component — short labels
      local mode_map = {
        ["NORMAL"]   = "N",
        ["INSERT"]   = "I",
        ["VISUAL"]   = "V",
        ["V-LINE"]   = "VL",
        ["V-BLOCK"]  = "VB",
        ["COMMAND"]  = "C",
        ["REPLACE"]  = "R",
        ["TERMINAL"] = "T",
      }

      require("lualine").setup({
        options = {
          theme = "tokyonight",
          globalstatus = true,           -- single statusline across all windows
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = { "dashboard", "alpha", "snacks_dashboard" },
            winbar = {},
          },
        },
        sections = {
          lualine_a = {
            {
              "mode",
              fmt = function(str)
                return mode_map[str] or str
              end,
              separator = { left = "" },
              padding = { left = 1, right = 1 },
            },
          },
          lualine_b = {
            { "branch", icon = "", color = { fg = colors.violet, gui = "bold" } },
            {
              "diff",
              symbols = { added = " ", modified = " ", removed = " " },
              diff_color = {
                added    = { fg = colors.green },
                modified = { fg = colors.orange },
                removed  = { fg = colors.red },
              },
              cond = conditions.hide_in_width,
            },
          },
          lualine_c = {
            {
              "filename",
              file_status = true,
              path = 1, -- relative path
              shorting_target = 40,
              symbols = {
                modified = "  ",
                readonly = "  ",
                unnamed  = "[No Name]",
              },
              color = { fg = colors.fg },
              cond = conditions.buffer_not_empty,
            },
          },
          lualine_x = {
            -- Noice command in statusline (shows ex-command being typed)
            noice_ok and {
              noice.api.status.command.get,
              cond = noice.api.status.command.has,
              color = { fg = colors.orange },
            } or nil,
            -- Noice mode (e.g. recording macro)
            noice_ok and {
              noice.api.status.mode.get,
              cond = noice.api.status.mode.has,
              color = { fg = colors.orange },
            } or nil,
            -- Noice search (shows /search count)
            noice_ok and {
              noice.api.status.search.get,
              cond = noice.api.status.search.has,
              color = { fg = colors.cyan },
            } or nil,
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
              diagnostics_color = {
                error = { fg = colors.red },
                warn  = { fg = colors.yellow },
                info  = { fg = colors.cyan },
                hint  = { fg = colors.blue },
              },
            },
          },
          lualine_y = {
            { "filetype", colored = true, icon_only = false },
            { "encoding", cond = conditions.hide_in_width },
          },
          lualine_z = {
            { "progress", color = { fg = colors.fg } },
            { "location", separator = { right = "" }, padding = { left = 0, right = 1 } },
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        extensions = { "oil", "trouble", "lazy", "neo-tree", "quickfix" },
      })
    end,
  },
}
