-- Moving through a large codebase: fuzzy finder, quick file marks,
-- diagnostics panel, symbol outline, and project switching.

local icons = require("utils.icons")

return {
  -- ── Telescope ──────────────────────────────────────────────────
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = vim.fn.executable("make") == 1 },
      "nvim-telescope/telescope-ui-select.nvim",
    },
    keys = {
      { "<leader><leader>", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fF", "<cmd>Telescope find_files hidden=true no_ignore=true<cr>", desc = "Find all files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Grep word", mode = { "n", "v" } },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
      { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
      { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols" },
      { "<leader>fS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace symbols" },
      { "<leader>fR", "<cmd>Telescope resume<cr>", desc = "Resume last picker" },
      { "<leader>f/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search in buffer" },
      { "<leader>fp", "<cmd>Telescope projects<cr>", desc = "Projects" },
    },
    opts = function()
      local actions = require("telescope.actions")
      return {
        defaults = {
          prompt_prefix = "  " .. icons.ui.prompt .. "  ",
          selection_caret = "  ",
          entry_prefix = "   ",
          multi_icon = " ",
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            prompt_position = "top",
            horizontal = { preview_width = 0.55, width = 0.87, height = 0.80 },
            vertical = { width = 0.75, height = 0.9, preview_height = 0.5 },
          },
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          winblend = 0,
          dynamic_preview_title = true,
          results_title = false,
          path_display = { "truncate" },
          file_ignore_patterns = { "%.git/", "node_modules/", "%.next/", "dist/", "target/", "%.lock" },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<esc>"] = actions.close,
              ["<C-u>"] = false,
            },
          },
        },
        pickers = {
          find_files = { hidden = true },
          buffers = {
            sort_mru = true,
            ignore_current_buffer = true,
            mappings = { i = { ["<C-d>"] = actions.delete_buffer } },
          },
        },
        extensions = {
          ["ui-select"] = { require("telescope.themes").get_dropdown() },
          fzf = { fuzzy = true, override_generic_sorter = true, override_file_sorter = true },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "ui-select")
      pcall(telescope.load_extension, "projects")
    end,
  },

  -- ── Harpoon (instant file marks) ──────────────────────────────
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = function()
      local keys = {
        { "<leader>ha", function() require("harpoon"):list():add() end, desc = "Harpoon add file" },
        { "<C-e>", function() local h = require("harpoon") h.ui:toggle_quick_menu(h:list()) end, desc = "Harpoon menu" },
        { "<leader>hn", function() require("harpoon"):list():next() end, desc = "Harpoon next" },
        { "<leader>hp", function() require("harpoon"):list():prev() end, desc = "Harpoon prev" },
      }
      for i = 1, 4 do
        keys[#keys + 1] = {
          "<leader>" .. i,
          function() require("harpoon"):list():select(i) end,
          desc = "Harpoon to file " .. i,
        }
      end
      return keys
    end,
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()
      harpoon:extend({
        UI_CREATE = function(ctx)
          vim.keymap.set("n", "<C-v>", function() harpoon.ui:select_menu_item({ vsplit = true }) end, { buffer = ctx.bufnr })
          vim.keymap.set("n", "<C-x>", function() harpoon.ui:select_menu_item({ split = true }) end, { buffer = ctx.bufnr })
        end,
      })
    end,
  },

  -- ── Diagnostics / references / quickfix panel ─────────────────
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (workspace)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnostics (buffer)" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols" },
      { "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Location list" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix list" },
      { "<leader>xr", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP references" },
    },
    opts = {
      focus = true,
      win = { border = "rounded" },
      icons = {
        indent = { top = "│ ", middle = "├╴", last = "╰╴", fold_open = "", fold_closed = "" },
        folder_closed = "",
        folder_open = "",
      },
    },
  },

  -- ── Symbol outline ─────────────────────────────────────────────
  {
    "stevearc/aerial.nvim",
    cmd = { "AerialToggle", "AerialOpen" },
    keys = {
      { "<leader>o", "<cmd>AerialToggle!<cr>", desc = "Outline (symbols)" },
    },
    opts = {
      backends = { "lsp", "treesitter", "markdown", "man" },
      layout = { min_width = 30, default_direction = "right", border = "rounded" },
      show_guides = true,
      guides = { mid_item = "├╴", last_item = "╰╴", nested_top = "│ ", whitespace = "  " },
      icons = icons.kinds,
      filter_kind = false,
    },
  },

  -- ── Project detection & switching ──────────────────────────────
  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    main = "project_nvim",
    opts = {
      detection_methods = { "lsp", "pattern" },
      patterns = { ".git", "package.json", "go.mod", "Cargo.toml", "pyproject.toml", "Makefile", ".root" },
      silent_chdir = true,
      scope_chdir = "global",
    },
  },
}
