-- Moving through a large codebase: fuzzy finder, quick file marks,
-- diagnostics panel, symbol outline, and project switching.

local icons = require("umbra.icons")
local ui = require("umbra.tokens")

local function telescope()
  return require("telescope.builtin")
end

local function dropdown(opts)
  return require("telescope.themes").get_dropdown(vim.tbl_deep_extend("force", {
    previewer = false,
    layout_config = { width = 0.62, height = 0.45 },
  }, opts or {}))
end

local function is_loam()
  return (vim.g.colors_name or "") == "loam"
end

local function merge_loam_telescope_opts(opts)
  if not is_loam() then
    return opts
  end
  return vim.tbl_deep_extend("force", opts, require("themes.loam.telescope").opts())
end

return {
  -- ── Telescope ──────────────────────────────────────────────────
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "nvim-treesitter/nvim-treesitter",
      "neovim/nvim-lspconfig",
      "ahmedkhalf/project.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = vim.fn.executable("make") == 1 },
      "nvim-telescope/telescope-ui-select.nvim",
    },
    keys = {
      { "<leader><leader>", function() telescope().find_files({ hidden = true }) end, desc = "Find files" },
      { "<leader>ff", function() telescope().find_files({ hidden = true }) end, desc = "Find files" },
      { "<leader>fF", function() telescope().find_files({ hidden = true, no_ignore = true }) end, desc = "Find all files" },
      { "<leader>fg", function() telescope().live_grep() end, desc = "Live grep" },
      { "<leader>fw", function() telescope().grep_string() end, desc = "Grep word", mode = { "n", "v" } },
      {
        "<leader>fb",
        function()
          telescope().buffers(dropdown({
            sort_mru = true,
            ignore_current_buffer = true,
            path_display = { "smart" },
          }))
        end,
        desc = "Buffers",
      },
      { "<leader>fr", function() telescope().oldfiles() end, desc = "Recent files" },
      { "<leader>fh", function() telescope().help_tags(dropdown()) end, desc = "Help tags" },
      { "<leader>fk", function() telescope().keymaps(dropdown()) end, desc = "Keymaps" },
      { "<leader>fc", function() telescope().commands(dropdown()) end, desc = "Commands" },
      { "<leader>fd", function() telescope().diagnostics(dropdown()) end, desc = "Diagnostics" },
      { "<leader>fs", function() telescope().lsp_document_symbols(dropdown()) end, desc = "Document symbols" },
      { "<leader>fS", function() telescope().lsp_dynamic_workspace_symbols(dropdown()) end, desc = "Workspace symbols" },
      { "<leader>fR", function() telescope().resume() end, desc = "Resume last picker" },
      { "<leader>f/", function() telescope().current_buffer_fuzzy_find(dropdown()) end, desc = "Search in buffer" },
      { "<leader>fm", function() telescope().marks(dropdown()) end, desc = "Marks" },
      {
        "<leader>fp",
        function()
          pcall(require("telescope").extensions.projects.projects, {})
        end,
        desc = "Projects",
      },
      {
        "<leader>pp",
        function()
          pcall(require("telescope").extensions.projects.projects, {})
        end,
        desc = "Switch project",
      },
    },
    opts = function()
      local actions = require("telescope.actions")
      local base = {
        defaults = {
          prompt_prefix = " ◇ ",
          selection_caret = " ❯ ",
          entry_prefix = "   ",
          path_display = { "smart" },
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          winblend = 0,
          results_title = false,
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.58,
              width = 0.90,
              height = 0.88,
            },
            center = {
              width = 0.62,
              height = 0.45,
            },
          },
          file_ignore_patterns = {
            "%.git/",
            "node_modules/",
            "%.next/",
            "dist/",
            "target/",
            "%.lock",
            "%.DS_Store",
          },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<esc>"] = actions.close,
              ["<C-u>"] = false,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<C-f>"] = actions.preview_scrolling_up,
            },
            n = {
              ["q"] = actions.close,
              ["j"] = actions.move_selection_next,
              ["k"] = actions.move_selection_previous,
            },
          },
        },
        pickers = {
          find_files = { hidden = true },
          buffers = {
            sort_mru = true,
            ignore_current_buffer = true,
            theme = "dropdown",
            previewer = false,
            path_display = { "smart" },
            layout_config = { width = 0.62, height = 0.45 },
            mappings = {
              i = { ["<C-d>"] = actions.delete_buffer },
            },
          },
        },
        extensions = {
          ["ui-select"] = require("telescope.themes").get_dropdown({
            previewer = false,
            layout_config = { width = 0.52, height = 0.40 },
          }),
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      }
      return merge_loam_telescope_opts(base)
    end,
    config = function(_, opts)
      local base_opts = opts
      opts = merge_loam_telescope_opts(opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "ui-select")

      local tel_group = vim.api.nvim_create_augroup("umbra_telescope_theme", { clear = true })
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = tel_group,
        callback = function()
          if vim.g.colors_name ~= "loam" then
            return
          end
          local mod = require("themes.loam")
          local p = mod.resolved or mod.base_palette
          local tel = require("themes.loam.telescope")
          tel.apply_highlights(p)
          tel.apply_devicons(p)
          pcall(function()
            telescope.setup(merge_loam_telescope_opts(base_opts))
          end)
        end,
      })

      -- After Telescope opens a file, guarantee syntax + LSP attach.
      local action_set = require("telescope.actions.set")
      local edit = action_set.edit
      action_set.edit = function(prompt_bufnr, command)
        edit(prompt_bufnr, command)
        vim.schedule(function()
          vim.defer_fn(function()
            require("features.intelligence").ensure_buffers()
          end, 80)
        end)
      end
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
          pcall(vim.api.nvim_win_set_config, ctx.win_id, { border = ui.border })
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
      win = { border = ui.border },
      icons = {
        indent = {
          top = icons.tree.top,
          middle = icons.tree.mid_item,
          last = icons.tree.last_item,
          fold_open = icons.ui.fold_open,
          fold_closed = icons.ui.fold_closed,
        },
        folder_closed = icons.ui.fold_closed,
        folder_open = icons.ui.fold_open,
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
      layout = { min_width = ui.panel.sm, default_direction = "right", border = ui.border },
      show_guides = true,
      guides = {
        mid_item = icons.tree.mid_item,
        last_item = icons.tree.last_item,
        nested_top = icons.tree.top,
        whitespace = "  ",
      },
      icons = icons.kinds,
      filter_kind = false,
    },
  },

  -- ── Project detection & switching ──────────────────────────────
  {
    "ahmedkhalf/project.nvim",
    main = "project_nvim",
    opts = {
      detection_methods = { "lsp", "pattern" },
      patterns = { ".git", "package.json", "go.mod", "Cargo.toml", "pyproject.toml", "Makefile", ".root" },
      silent_chdir = true,
      scope_chdir = "global",
    },
    config = function(_, opts)
      require("project_nvim").setup(opts)
      pcall(require("telescope").load_extension, "projects")
    end,
  },
}
