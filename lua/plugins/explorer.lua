-- File exploration: neo-tree as the sidebar/float tree, oil for editing
-- the filesystem like a buffer.

local icons = require("utils.icons")

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
    opts = {
      close_if_last_window = true,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      sources = { "filesystem", "buffers", "git_status" },
      source_selector = {
        winbar = true,
        content_layout = "center",
        sources = {
          { source = "filesystem", display_name = "  Files " },
          { source = "buffers", display_name = "  Buffers " },
          { source = "git_status", display_name = "  Git " },
        },
      },
      default_component_configs = {
        indent = {
          with_markers = true,
          indent_marker = "│",
          last_indent_marker = "╰",
          with_expanders = true,
          expander_collapsed = icons.ui.fold_closed,
          expander_expanded = icons.ui.fold_open,
        },
        modified = { symbol = icons.ui.modified },
        -- VS Code-style letter badges (colored by the theme's NeoTreeGit* groups).
        git_status = {
          symbols = {
            added = "A",
            modified = "M",
            deleted = "D",
            renamed = "R",
            untracked = "U",
            ignored = "!",
            unstaged = "",
            staged = "",
            conflict = "C",
          },
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
        width = 32,
        mappings = {
          ["<space>"] = "none",
          ["l"] = "open",
          ["h"] = "close_node",
          ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = false } },
          ["<cr>"] = "open",
          ["s"] = "open_vsplit",
          ["S"] = "open_split",
          -- Cycle Files → Buffers → Git in place, so one sidebar serves all.
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
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        group_empty_dirs = true,
        window = {
          mappings = {
            ["H"] = "toggle_hidden", -- filesystem-only; avoids warnings in other sources
          },
        },
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_by_name = { ".git", "node_modules", ".DS_Store" },
          never_show = { ".DS_Store" },
        },
      },
      -- Full git workflow from the sidebar: stage/unstage/revert files and
      -- commit/push — no need to leave the editor. (Enter/l opens the diff.)
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
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)

      -- Keep git badges fresh after writes / staging / focus — but only when a
      -- neo-tree git view is actually loaded, so this never breaks lazy-loading.
      -- (neo-tree's file watcher already handles most cases; this covers the rest.)
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
    lazy = false,
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
        padding = 3,
        border = "rounded",
        max_width = 90,
        max_height = 30,
        win_options = { winblend = 0 },
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
