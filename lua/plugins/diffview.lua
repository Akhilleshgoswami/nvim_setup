return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local ui = require("akhilesh.ui")

    require("diffview").setup({
      view = {
        default = {
          layout = "diff2horizontal",
          winbar_info = true,
        },
        merge_tool = {
          layout = "diff3horizontal",
        },
      },
      diff_binaries = false,
      enhanced_diff_hl = true,
      use_icons = true,
      show_help_hints = false,
      watch_index = true,
      icons = {
        folder_closed = "",
        folder_open = "",
      },
      signs = {
        fold_closed = "",
        fold_open = "",
        done = " ",
      },
      view_config = {
        merge_tool = {
          disable_diagnostics = true,
        },
      },
      keymaps = {
        view = {
          ["<leader>e"] = false,
        },
      },
      hooks = {
        diff_buf_read = function()
          vim.opt_local.wrap = false
        end,
      },
    })

    local c = ui.colors()
    vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#1a2b1a" })
    vim.api.nvim_set_hl(0, "DiffChange", { bg = "#1a2233" })
    vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#2b1a1a", fg = c.red })
    vim.api.nvim_set_hl(0, "DiffText", { bg = "#283457" })
  end,
}
