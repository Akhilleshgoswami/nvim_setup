-- lua/akhilesh/plugins/colorscheme.lua
return {
  {
    "folke/tokyonight.nvim",
    lazy = false,    -- load at startup
    priority = 1000, -- load before all other plugins
    opts = {
      style = "night",        -- "night" | "storm" | "day" | "moon"
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = "dark",
        floats = "dark",
      },
      sidebars = { "qf", "help", "terminal", "neo-tree", "oil" },
      on_highlights = function(hl, c)
        -- Make the border of floating windows more visible
        hl.FloatBorder = { fg = c.blue0, bg = c.bg_float }
        -- Nicer line number highlight
        hl.CursorLineNr = { fg = c.orange, bold = true }
      end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd("colorscheme tokyonight")
    end,
  },
}
