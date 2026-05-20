
return {
  "stevearc/oil.nvim",

  lazy = false,

  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "SirZenith/oil-vcs-status",
  },

  keys = {
    {
      "-",
      "<CMD>Oil<CR>",
      desc = "Open parent directory",
    },

    {
      "<leader>e",
      "<CMD>Oil --float<CR>",
      desc = "Open Oil float",
    },
  },

  config = function()
    local oil = require("oil")

    oil.setup({
      default_file_explorer = true,

      columns = {
        "icon",
      },

      delete_to_trash = true,

      skip_confirm_for_simple_edits = true,

      prompt_save_on_select_new_entry = false,

      cleanup_delay_ms = 2000,

      constrain_cursor = "editable",

      watch_for_changes = true,

      win_options = {
        signcolumn = "yes:2",
        wrap = false,
      },

      float = {
        padding = 2,
        max_width = 90,
        max_height = 30,

        border = "rounded",

        win_options = {
          winblend = 10,
        },
      },

      view_options = {
        show_hidden = true,
        natural_order = true,
      },

      keymaps = {
        ["g?"] = "actions.show_help",

        ["<CR>"] = "actions.select",
        ["l"] = "actions.select",

        ["h"] = "actions.parent",

        ["q"] = "actions.close",
        ["<Esc>"] = "actions.close",

        ["<C-v>"] = "actions.select_vsplit",
        ["<C-s>"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",

        ["<C-p>"] = "actions.preview",

        ["r"] = "actions.refresh",

        ["."] = "actions.toggle_hidden",

        ["gx"] = "actions.open_external",
      },
    })

    -- Git status

    local status_const =
      require("oil-vcs-status.constant.status")

    local StatusType = status_const.StatusType

    require("oil-vcs-status").setup({
      status_symbol = {
        [StatusType.Added] = "",
        [StatusType.Modified] = "",
        [StatusType.Deleted] = "",
        [StatusType.Renamed] = "",
        [StatusType.Untracked] = "",
        [StatusType.Ignored] = "",
      },
    })

    -- Auto preview

    vim.api.nvim_create_autocmd("User", {
      pattern = "OilEnter",

      callback = function(args)
        vim.schedule(function()
          if vim.api.nvim_get_current_buf() == args.data.buf then
            pcall(oil.open_preview)
          end
        end)
      end,
    })
  end,
}
