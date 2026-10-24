-- File exploration: neo-tree as the sidebar/float tree, oil for editing
-- the filesystem like a buffer.

local icons = require("umbra.icons")
local ui = require("umbra.tokens")

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      -- One sidebar, many sources. Everything docks left and reuses the same
      -- window, so switching Files → Buffers → Git never spawns extra splits.
      { "<leader>e", "<cmd>Neotree toggle reveal left source=filesystem<cr>", desc = "Explorer: files" },
      { "<leader>E", "<cmd>Neotree float reveal source=filesystem<cr>", desc = "Explorer (float)" },
      { "<leader>ge", "<cmd>Neotree focus left source=git_status<cr>", desc = "Explorer: git status" },
      { "<leader>be", "<cmd>Neotree focus left source=buffers<cr>", desc = "Explorer: buffers" },
    },
    opts = function()
      local base = {
      close_if_last_window = true,
      popup_border_style = ui.border,
      enable_git_status = true,
      enable_diagnostics = true,
      use_popups_for_input = true,
      sources = { "filesystem", "buffers", "git_status" },
      source_selector = {
        winbar = true,
        content_layout = "center",
        tabs_layout = "equal",
        separator = { left = "", right = "" },
        sources = {
          { source = "filesystem", display_name = " \u{f024b} Files " },
          { source = "buffers", display_name = " \u{f0219} Buffers " },
          { source = "git_status", display_name = " \u{f062c} Git " },
        },
      },
      default_component_configs = {
        container = { enable_character_fade = true },
        indent = {
          indent_size = 2,
          padding = 1,
          with_markers = true,
          indent_marker = icons.tree.indent,
          last_indent_marker = icons.tree.last,
          with_expanders = true,
          expander_collapsed = icons.ui.fold_closed,
          expander_expanded = icons.ui.fold_open,
          expander_highlight = "NeoTreeExpander",
        },
        icon = {
          folder_closed = "󰉋",
          folder_open = "󰝰",
          folder_empty = "󰉖",
          folder_empty_open = "󰷏",
          default = "󰈔",
        },
        modified = { symbol = icons.ui.modified },
        name = { trailing_slash = false, use_git_status_colors = true },
        -- Git status glyphs follow the active built-in theme (see themes/glyphs.lua).
        git_status = {
          symbols = require("themes.glyphs").neo_tree_git(),
        },
        diagnostics = {
          symbols = {
            hint = icons.diagnostics.Hint,
            info = icons.diagnostics.Info,
            warn = icons.diagnostics.Warn,
            error = icons.diagnostics.Error,
          },
        },
      },
      window = {
        position = "left",
        width = ui.panel.md,
        mapping_options = { noremap = true, nowait = true },
        mappings = {
          ["<space>"] = "none",
          ["l"] = "open",
          ["h"] = "close_node",
          ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
          ["<cr>"] = "open",
          ["s"] = "open_vsplit",
          ["S"] = "open_split",
          ["<Tab>"] = "next_source",
          ["<S-Tab>"] = "prev_source",
          ["Y"] = function(state)
            vim.fn.setreg("+", state.tree:get_node().path)
          end,
          ["O"] = function(state)
            vim.ui.open(state.tree:get_node().path)
          end,
        },
      },
      -- Floating explorer: rounded, compact, preview-ready.
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true, leave_dirs_open = false },
        use_libuv_file_watcher = true,
        group_empty_dirs = true,
        hijack_netrw_behavior = "disabled",
        window = {
          mappings = {
            ["H"] = "toggle_hidden",
          },
        },
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_by_name = { ".git", "node_modules", ".DS_Store", ".cache" },
          never_show = { ".DS_Store", "thumbs.db" },
        },
      },
      buffers = {
        follow_current_file = { enabled = true },
        group_empty_dirs = true,
        show_unloaded = true,
      },
      git_status = {
        window = {
          mappings = {
            ["A"] = "git_add_all",
            ["ga"] = "git_add_file",
            ["gu"] = "git_unstage_file",
            ["gr"] = "git_revert_file",
            ["gc"] = "git_commit",
            ["gp"] = "git_push",
            ["gg"] = "git_commit_and_push",
            ["<cr>"] = "open",
            ["l"] = "open",
          },
        },
      },
      event_handlers = {
        {
          event = "neo_tree_window_after_open",
          handler = function(args)
            if args.position == "left" or args.position == "right" then
              vim.cmd("wincmd =")
            end
          end,
        },
      },
      }
      return require("features.neotree_diffstat").configure(base)
    end,
    config = function(_, opts)
      require("neo-tree").setup(opts)
      require("features.neotree_diffstat").setup_autocmd()

      vim.api.nvim_create_autocmd({ "BufWritePost", "FocusGained", "TermClose", "TermLeave" }, {
        group = vim.api.nvim_create_augroup("umbra_neotree_git", { clear = true }),
        callback = function()
          if package.loaded["neo-tree.sources.git_status"] then
            pcall(function()
              require("neo-tree.sources.git_status").refresh()
            end)
          end
        end,
      })
    end,
  },

  -- Edit the filesystem as a normal buffer.
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = true,
    cmd = "Oil",
    keys = {
      { "-", function() require("oil").open_float() end, desc = "Open parent (oil)" },
      { "<leader>-", "<cmd>Oil<cr>", desc = "Open parent (oil split)" },
    },
    opts = {
      default_file_explorer = false,
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name)
          return name == ".." or name == ".git"
        end,
      },
      float = {
        padding = ui.space.md,
        border = ui.border,
        max_width = 90,
        max_height = 30,
        win_options = { winblend = ui.opacity.float },
      },
      keymaps = {
        ["<C-h>"] = false,
        ["<C-l>"] = false,
        ["q"] = "actions.close",
        ["<C-p>"] = "actions.preview",
        ["gd"] = { "actions.toggle_detail" },
      },
    },
  },
}
