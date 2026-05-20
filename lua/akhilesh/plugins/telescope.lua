return {
"nvim-telescope/telescope.nvim",
event = "VimEnter",
branch = "0.1.x",
dependencies = {
  "nvim-lua/plenary.nvim",
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    "folke/todo-comments.nvim",
    build = "make",
    cond = function()
      return vim.fn.executable("make") == 1
    end,
  },
  { "nvim-telescope/telescope-ui-select.nvim" },
  { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
},
config = function()
  local actions = require("telescope.actions")

  require("telescope").setup({
    defaults = {
      prompt_prefix = "   ",
      selection_caret = "  ",
      entry_prefix = "   ",
      path_display = { "truncate" },
      file_ignore_patterns = {
        "dist",
        "target",
        "node_modules",
        "pack/plugins",
      },
      sorting_strategy = "ascending",
      layout_config = {
        horizontal = {
          prompt_position = "top",
          preview_width = 0.55,
        },
        width = 0.87,
        height = 0.80,
      },
      mappings = {
        n = {
          ["q"]  = actions.close,
          ["dd"] = actions.delete_buffer,
        },
        i = {
          -- ✅ send ALL results to quickfix
          ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
          -- ✅ send SELECTED results to quickfix
          ["<A-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        },
      },
    },
  })

  pcall(require("telescope").load_extension, "fzf")
  pcall(require("telescope").load_extension, "ui-select")

  local builtin = require("telescope.builtin")

  vim.keymap.set('n', '<leader>fh',
    "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>")
  vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
  vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
  vim.keymap.set("n", "<leader>pf", builtin.find_files, { desc = "[S]earch [F]iles" })
  vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
  vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
  vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
  vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
  vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
  vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
  vim.keymap.set("n", "<leader>b", builtin.buffers, { desc = "[ ] Find existing buffers" })
  vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })

  -- ✅ Global word replace keymap
  vim.keymap.set("n", "<leader>rw", function()
    local word = vim.fn.expand("<cword>")  -- grabs word under cursor
    local replacement = vim.fn.input("Replace [" .. word .. "] with: ")
    if replacement ~= "" then
      vim.cmd("cfdo %s/" .. word .. "/" .. replacement .. "/g | update")
      vim.notify("Replaced [" .. word .. "] with [" .. replacement .. "] globally!", vim.log.levels.INFO)
    end
  end, { desc = "[R]eplace [W]ord globally" })

  vim.keymap.set("n", "<leader>/", function()
    builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
      winblend = 10,
      previewer = false,
    }))
  end, { desc = "[/] Fuzzily search in current buffer" })

  vim.keymap.set("n", "<leader>s/", function()
    builtin.live_grep({
      grep_open_files = true,
      prompt_title = "Live Grep in Open Files",
    })
  end, { desc = "[S]earch [/] in Open Files" })

  vim.keymap.set("n", "<leader>sn", function()
    builtin.find_files({ cwd = vim.fn.stdpath("config") })
  end, { desc = "[S]earch [N]eovim files" })
end,
}
