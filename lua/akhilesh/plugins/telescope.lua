-- ============================================================
-- lua/akhilesh/plugins/telescope.lua
-- ZERO CRASH + TREESITTER SAFE VERSION (FIXED)
-- ============================================================

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

    -- ============================================================
    -- SAFE UI HIGHLIGHTS
    -- ============================================================

    local function set_hl()
      local set = vim.api.nvim_set_hl

      set(0, "TelescopeNormal", { bg = "NONE" })
      set(0, "TelescopeBorder", { fg = "#00d4ff", bg = "NONE" })
      set(0, "TelescopeTitle", { fg = "#ff4fd8", bold = true })

      set(0, "TelescopePromptBorder", { fg = "#00d4ff" })
      set(0, "TelescopePromptTitle", { fg = "#00d4ff", bold = true })

      set(0, "TelescopeResultsBorder", { fg = "#444444" })
      set(0, "TelescopePreviewBorder", { fg = "#39ff14" })

      set(0, "TelescopeSelection", { fg = "#ffe66d", bold = true })
      set(0, "TelescopeSelectionCaret", { fg = "#ff4fd8" })

      set(0, "TelescopeMatching", { fg = "#39ff14", bold = true })
    end

    set_hl()

    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.schedule(set_hl)
      end,
    })

    -- ============================================================
    -- SAFE TELESCOPE SETUP (FIXED)
    -- ============================================================

    telescope.setup({
      defaults = {
        prompt_prefix = "   ",
        selection_caret = "❯ ",
        entry_prefix = "  ",

        sorting_strategy = "ascending",
        layout_strategy = "horizontal",

        winblend = 10,

        layout_config = {
          horizontal = {
            preview_width = 0.55,
          },
          width = 0.92,
          height = 0.90,
        },

        file_ignore_patterns = {
          "node_modules",
          ".git/",
          "dist",
          "build",
          "coverage",
        },

        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<Esc>"] = actions.close,
          },
        },

        -- 🚨 IMPORTANT FIX: DISABLE TREE-SITTER IN TELESCOPE
        preview = {
          treesitter = false,
        },
      },

      pickers = {
        find_files = {
          theme = "ivy",
          hidden = true,
        },

        live_grep = {
          theme = "ivy",
          additional_args = function()
            return { "--hidden" }
          end,
        },

        buffers = {
          theme = "dropdown",
          previewer = false,
        },

        current_buffer_fuzzy_find = {
          theme = "dropdown",
          previewer = false,
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

    -- extensions
    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "ui-select")
    pcall(telescope.load_extension, "file_browser")

    -- ============================================================
    -- SAFE FILETYPE FIX (NO CRASH, NO PLENARY OVERRIDE)
    -- ============================================================

    vim.api.nvim_create_autocmd("User", {
      pattern = "TelescopePreviewerLoaded",
      callback = function(args)
        local buf = args.buf
        if not buf or not vim.api.nvim_buf_is_valid(buf) then
          return
        end

        local bufname = vim.api.nvim_buf_get_name(buf)
        if bufname == "" then
          return
        end

        vim.schedule(function()
          if vim.filetype and vim.filetype.match then
            local ft = vim.filetype.match({ filename = bufname })
            if ft then
              vim.bo[buf].filetype = ft
            end
          end
        end)
      end,
    })

    -- ============================================================
    -- KEYMAPS
    -- ============================================================

    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
    vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help" })
    vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Recent files" })
    vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "Search word" })
    vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Diagnosbuiltin.diagnosticstics" })

    vim.keymap.set("n", "<leader>fc", function()
      telescope.extensions.file_browser.file_browser({
        path = "%:p:h",
        select_buffer = true,
      })
    end, { desc = "File browser" })

    -- SAFE BUFFER SEARCH (NO ft_to_lang CRASH)
    vim.keymap.set("n", "<leader>/", function()
      builtin.live_grep({
        grep_open_files = true,
        prompt_title = "Buffer Search",
        theme = themes.get_dropdown({
          previewer = false,
        }),
      })
    end, { desc = "Buffer search" })

    -- GLOBAL REPLACE
    vim.keymap.set("n", "<leader>rw", function()
      local word = vim.fn.expand("<cword>")
      local replacement = vim.fn.input("Replace " .. word .. " → ")

      if replacement ~= "" then
        vim.cmd("cfdo %s/" .. word .. "/" .. replacement .. "/g | update")
        vim.notify("Replaced " .. word .. " → " .. replacement)
      end
    end, { desc = "Global replace" })
  end,
}
