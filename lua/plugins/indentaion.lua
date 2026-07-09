return {
  "shellRaining/hlchunk.nvim",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local ui = require("akhilesh.ui")

    local function palette()
      local c = ui.colors()
      return {
        chunk = {
          { fg = c.blue },
          { fg = c.cyan },
          { fg = c.green },
          { fg = c.purple },
          { fg = c.yellow },
          { fg = c.orange },
          { fg = c.fg },
        },
        indent = { { fg = c.fg_muted } },
      }
    end

    local p = palette()

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
        style = p.chunk,
      },
      indent = {
        enable = true,
        chars = { "│" },
        style = p.indent,
      },
      blank = { enable = false },
      line_num = { enable = false },
    })

    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.defer_fn(function()
          local colors = palette()
          pcall(function()
            require("hlchunk").setup({
              chunk = { style = colors.chunk },
              indent = { style = colors.indent },
            })
          end)
          pcall(vim.cmd, "HLChunkEnable")
        end, 50)
      end,
    })
  end,
}
