return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local diffview = require("diffview")
    diffview.setup({
      hooks = {
        view_closed = function(view)
          -- Optional debug log to avoid errors
          pcall(function()
            vim.cmd("echo ''") -- clear command line or any lingering commands
          end)
        end,
      }
    })
  end,
}
