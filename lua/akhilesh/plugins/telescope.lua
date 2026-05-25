return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  event = "VimEnter",

  dependencies = {
    "nvim-lua/plenary.nvim",

    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },

    {
      "nvim-tree/nvim-web-devicons",
      enabled = vim.g.have_nerd_font,
    },

    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
    "folke/todo-comments.nvim",
  },

  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local builtin = require("telescope.builtin")
    local themes = require("telescope.themes")
    local previewers = require("telescope.previewers")

    -- ============================================================
    -- 🔥 FIX 1: PATCH ft_to_lang CRASH (ROOT CAUSE)
    -- ============================================================

    local utils_ok, utils = pcall(require, "telescope.utils")
    if utils_ok then
      utils.ft_to_lang = function()
        return nil
      end
    end

    -- ============================================================
    -- PALETTE
    -- ============================================================

    local c = {
      bg = "#1a1b26",
      bg_dark = "#16161e",
      bg_alt = "#1f2335",
      bg_highlight = "#292e42",
      fg = "#c0caf5",
      comment = "#565f89",
      orange = "#ff9e64",
      red = "#f7768e",
      green = "#9ece6a",
      yellow = "#e0af68",
    }

    -- ============================================================
    -- HIGHLIGHTS
    -- ============================================================

    local function set_hl()
      local set = vim.api.nvim_set_hl

      set(0, "TelescopeNormal", { bg = c.bg_dark, fg = c.fg })
      set(0, "TelescopeBorder", { bg = c.bg_dark, fg = c.bg_dark })

      set(0, "TelescopePromptNormal", { bg = c.bg_alt, fg = c.fg })
      set(0, "TelescopePromptBorder", { bg = c.bg_alt, fg = c.bg_alt })

      set(0, "TelescopeSelection", { bg = c.bg_highlight, fg = c.orange, bold = true })
      set(0, "TelescopeMatching", { fg = c.yellow, bold = true })

      set(0, "TelescopePreviewBorder", { bg = c.bg_dark, fg = c.bg_dark })
    end

    set_hl()

    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.schedule(set_hl)
      end,
    })

    -- ============================================================
    -- SAFE SETUP (NO TREESITTER INTEGRATION)
    -- ============================================================

    telescope.setup({
      defaults = {
        prompt_prefix = "   ",
        selection_caret = " ❯ ",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",

        winblend = 0,
        path_display = { "smart" },

        file_ignore_patterns = {
          "node_modules",
          "%.git/",
          "dist",
          "build",
        },

        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<Esc>"] = actions.close,
          },
        },

        -- 🔥 IMPORTANT: disable treesitter preview
        preview = {
          treesitter = false,
          filesize_limit = 2,
          timeout = 200,
        },

        -- 🔥 EXTRA SAFETY: avoid TS buffer processing entirely
        buffer_previewer_maker = function(filepath, bufnr, opts)
          vim.bo[bufnr].filetype = ""
          previewers.buffer_previewer_maker(filepath, bufnr, opts)
        end,
      },

      pickers = {
        find_files = {
          hidden = true,
        },

        buffers = {
          previewer = false,
        },

        colorscheme = {
          enable_preview = true,
        },
      },

      extensions = {
        ["ui-select"] = themes.get_dropdown({}),
        file_browser = {
          theme = "ivy",
          hijack_netrw = true,
        },
      },
    })

    -- ============================================================
    -- EXTENSIONS
    -- ============================================================

    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "ui-select")
    pcall(telescope.load_extension, "file_browser")

    -- ============================================================
    -- SAFE AUTOCMD
    -- ============================================================

    vim.api.nvim_create_autocmd("User", {
      pattern = "TelescopePreviewerLoaded",
      callback = function(args)
        local buf = args.buf
        if not buf or not vim.api.nvim_buf_is_valid(buf) then return end

        local ok, name = pcall(vim.api.nvim_buf_get_name, buf)
        if not ok or name == "" then return end

        vim.schedule(function()
          local ft = vim.filetype.match({ filename = name })
          if ft and ft ~= "" then
            pcall(function()
              vim.bo[buf].filetype = ft
            end)
          end
        end)
      end,
    })

    -- ============================================================
    -- KEYMAPS (SAFE VERSION)
    -- ============================================================

    local map = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { desc = desc, silent = true })
    end

    map("<leader>ff", builtin.find_files, "Find files")
    map("<leader>fg", builtin.live_grep, "Live grep")
    map("<leader>fb", builtin.buffers, "Buffers")
    map("<leader>fh", builtin.help_tags, "Help")

    map("<leader>/", function()
      pcall(function()
        builtin.current_buffer_fuzzy_find(themes.get_dropdown({
          previewer = false,
        }))
      end)
    end, "Buffer search")
  end,
}
