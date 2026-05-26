-- ============================================================
--  lua/akhilesh/plugins/hlchunk.lua
--  NEXUS CHUNK SYSTEM
--  Premium Block Visualization
--  Theme Friendly • Cool Palette
-- ============================================================

return {
  "shellRaining/hlchunk.nvim",

  event = {
    "BufReadPost",
    "BufNewFile",
  },

  config = function()
    ------------------------------------------------------------
    -- HIGHLIGHTS
    ------------------------------------------------------------

    local hl = vim.api.nvim_set_hl

    hl(0, "ChunkBlue", {
      fg = "#7aa2f7",
    })

    hl(0, "ChunkCyan", {
      fg = "#7dcfff",
    })

    hl(0, "ChunkTeal", {
      fg = "#73daca",
    })

    hl(0, "ChunkPurple", {
      fg = "#bb9af7",
    })

    hl(0, "ChunkViolet", {
      fg = "#9d7cd8",
    })

    hl(0, "ChunkSky", {
      fg = "#89ddff",
    })

    hl(0, "ChunkFg", {
      fg = "#c0caf5",
    })

    ------------------------------------------------------------
    -- HLCHUNK
    ------------------------------------------------------------

    require("hlchunk").setup({
      chunk = {
        enable = true,

        use_treesitter = true,

        notify = false,

        delay = 0,
        duration = 0,

        chars = {
          horizontal_line = "─",
          vertical_line = "│",
          left_top = "╭",
          left_bottom = "╰",
          right_arrow = "─",
        },

        style = {
          { fg = "#7aa2f7" }, -- blue
          { fg = "#7dcfff" }, -- cyan
          { fg = "#73daca" }, -- teal
          { fg = "#bb9af7" }, -- purple
          { fg = "#9d7cd8" }, -- violet
          { fg = "#89ddff" }, -- sky
          { fg = "#c0caf5" }, -- foreground
        },
      },

      indent = {
        enable = true,

        chars = {
          "│",
        },

        style = {
          {
            fg = "#3b4261",
          },
        },
      },

      blank = {
        enable = false,
      },

      line_num = {
        enable = false,
      },
    })

    ------------------------------------------------------------
    -- AUTO REFRESH ON COLORSCHEME CHANGE
    ------------------------------------------------------------

    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.defer_fn(function()
          pcall(vim.cmd, "HLChunkEnable")
        end, 100)
      end,
    })
  end,
}
