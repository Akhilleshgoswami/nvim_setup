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
    local builtin  = require("telescope.builtin")
    local themes   = require("telescope.themes")

    -- =========================================================
    -- SAFE NO TREESITTER PATCH
    -- =========================================================

    local ok_utils, utils = pcall(require, "telescope.utils")

    if ok_utils then
      utils.ft_to_lang = function()
        return ""
      end
    end

    -- =========================================================
    -- COLORS
    -- =========================================================

    local c = {
      bg        = "#0b1020",
      bg_dark   = "#090d18",
      bg_soft   = "#111827",
      bg_result = "#0f172a",

      border  = "#1e293b",

      fg     = "#cdd6f4",
      muted  = "#6b7280",

      blue   = "#7aa2f7",
      cyan   = "#7dcfff",
      green  = "#9ece6a",
      yellow = "#f2cc60",
      purple = "#bb9af7",
      pink   = "#ff79c6",
    }

    -- =========================================================
    -- HIGHLIGHTS
    -- =========================================================

    local function set_hl()
      local set = vim.api.nvim_set_hl

      -- base
      set(0, "TelescopeNormal",  { bg = c.bg,      fg = c.fg })
      set(0, "TelescopeBorder",  { bg = c.bg,      fg = c.border })

      -- prompt
      set(0, "TelescopePromptNormal",  { bg = c.bg_soft, fg = c.fg })
      set(0, "TelescopePromptBorder",  { bg = c.bg_soft, fg = c.bg_soft })
      set(0, "TelescopePromptTitle",   { fg = c.bg, bg = c.blue, bold = true })
      set(0, "TelescopePromptPrefix",  { fg = c.pink, bold = true })
      set(0, "TelescopePromptCounter", { fg = c.muted })

      -- results
      set(0, "TelescopeResultsNormal", { bg = c.bg_result, fg = c.fg })
      set(0, "TelescopeResultsBorder", { bg = c.bg_result, fg = c.border })
      set(0, "TelescopeResultsTitle",  { fg = c.bg, bg = c.purple, bold = true })

      -- preview
      set(0, "TelescopePreviewNormal", { bg = c.bg_dark, fg = c.fg })
      set(0, "TelescopePreviewBorder", { bg = c.bg_dark, fg = c.border })
      set(0, "TelescopePreviewTitle",  { fg = c.bg, bg = c.green, bold = true })

      -- selection
      set(0, "TelescopeSelection",      { bg = "#162033", fg = c.cyan, bold = true })
      set(0, "TelescopeSelectionCaret", { fg = c.cyan, bold = true })
      set(0, "TelescopeMatching",       { fg = c.yellow, bold = true })

      -- multi-select
      set(0, "TelescopeMultiSelection", { fg = c.green, bold = true })
      set(0, "TelescopeMultiIcon",      { fg = c.green })

      -- float
      set(0, "NormalFloat",  { bg = c.bg })
      set(0, "FloatBorder",  { bg = c.bg, fg = c.border })
    end

    set_hl()

    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.schedule(set_hl)
      end,
    })

    -- =========================================================
    -- GLASS EFFECT
    -- =========================================================

    vim.opt.pumblend = 10
    vim.opt.winblend = 10

    -- =========================================================
    -- SHARED THEMES
    -- =========================================================

    local dropdown = themes.get_dropdown({
      border    = true,
      previewer = false,
      winblend  = 10,

      layout_config = {
        width  = 0.50,
        height = 0.45,
      },
    })

    local ivy = themes.get_ivy({
      border    = true,
      previewer = false,
      winblend  = 10,

      layout_config = {
        height = 0.38,
      },
    })

    -- =========================================================
    -- SETUP
    -- =========================================================

    telescope.setup({

      defaults = {
        prompt_prefix   = "   ",
        selection_caret = "▎ ",
        multi_icon      = "󰄵 ",
        entry_prefix    = "  ",

        sorting_strategy      = "ascending",
        layout_strategy       = "horizontal",
        dynamic_preview_title = true,

        path_display = { "truncate" },

        winblend = 10,

        layout_config = {
          prompt_position = "top",

          horizontal = {
            preview_width  = 0.50,
            preview_cutoff = 120,
          },

          width  = 0.92,
          height = 0.88,
        },

        -- borderless panels (bg colors create the separation)
        borderchars = {
          prompt  = { " ", " ", " ", " ", " ", " ", " ", " " },
          results = { " ", " ", " ", " ", " ", " ", " ", " " },
          preview = { " ", " ", " ", " ", " ", " ", " ", " " },
        },

        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<Esc>"] = actions.close,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<C-v>"] = actions.select_vertical,
            ["<C-s>"] = actions.select_horizontal,
            ["<C-t>"] = actions.select_tab,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,
          },
        },

        file_ignore_patterns = {
          "node_modules",
          ".git/",
          "dist",
          "build",
          "yarn.lock",
          "package-lock.json",
        },

        -- =====================================================
        -- PREVIEW  (treesitter off — fast + stable)
        -- =====================================================

        preview = {
          treesitter     = false,
          filesize_limit = 0.5,
          timeout        = 100,
        },

        buffer_previewer_maker = function(filepath, bufnr, opts)
          vim.bo[bufnr].syntax   = ""
          vim.bo[bufnr].filetype = ""

          require("telescope.previewers").buffer_previewer_maker(
            filepath, bufnr, opts
          )
        end,
      },

      -- =======================================================
      -- PICKERS
      -- =======================================================

      pickers = {
        find_files = {
          hidden    = true,
          previewer = false,
          theme     = "dropdown",
        },

        live_grep = {
          previewer = false,
          theme     = "ivy",
        },

        grep_string = {
          previewer = false,
          theme     = "ivy",
        },

        buffers = {
          previewer             = false,
          theme                 = "dropdown",
          sort_mru              = true,
          ignore_current_buffer = true,
        },

        oldfiles = {
          previewer = false,
          theme     = "dropdown",
        },

        help_tags = {
          previewer = false,
          theme     = "ivy",
        },

        diagnostics = {
          previewer = false,
          theme     = "ivy",
        },

        lsp_references = {
          previewer = false,
          theme     = "dropdown",
          show_line = false,
          trim_text = true,
        },

        lsp_definitions = {
          previewer = false,
          theme     = "dropdown",
        },

        current_buffer_fuzzy_find = {
          previewer = false,
          theme     = "dropdown",

          layout_config = {
            width  = 0.55,
            height = 0.40,
          },
        },

        colorscheme = {
          previewer      = false,
          enable_preview = true,
          theme          = "dropdown",
        },
      },

      -- =======================================================
      -- EXTENSIONS
      -- =======================================================

      extensions = {
        ["ui-select"] = dropdown,

        file_browser = {
          theme        = "dropdown",
          hijack_netrw = true,
          hidden       = true,
          grouped      = true,
          previewer    = false,
        },

        fzf = {
          fuzzy                   = true,
          override_generic_sorter = true,
          override_file_sorter    = true,
          case_mode               = "smart_case",
        },
      },
    })

    -- =========================================================
    -- LOAD EXTENSIONS
    -- =========================================================

    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "ui-select")
    pcall(telescope.load_extension, "file_browser")

    -- =========================================================
    -- KEYMAPS
    -- =========================================================

    local map = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { desc = desc, silent = true })
    end

    -- files ───────────────────────────────────────────────────

    map("<leader>ff", function()
      builtin.find_files(dropdown)
    end, "Find files")

    map("<leader>fr", function()
      builtin.oldfiles(dropdown)
    end, "Recent files")

    -- grep ────────────────────────────────────────────────────

    map("<leader>fg", function()
      builtin.live_grep(ivy)
    end, "Live grep")

    map("<leader>fw", function()
      builtin.grep_string(ivy)
    end, "Word under cursor")

    map("<leader>f/", function()
      builtin.current_buffer_fuzzy_find(dropdown)
    end, "Fuzzy in buffer")

    -- buffers / history ───────────────────────────────────────

    map("<leader>fb", function()
      builtin.buffers(dropdown)
    end, "Buffers")

    -- help ────────────────────────────────────────────────────

    map("<leader>fh", function()
      builtin.help_tags(ivy)
    end, "Help")

    -- diagnostics ─────────────────────────────────────────────

    map("<leader>fd", function()
      builtin.diagnostics(ivy)
    end, "Diagnostics")

    -- themes ──────────────────────────────────────────────────

    map("<leader>ft", function()
      builtin.colorscheme(dropdown)
    end, "Themes")

    -- explorer ────────────────────────────────────────────────

    map("<leader>fe", function()
      telescope.extensions.file_browser.file_browser({
        path          = "%:p:h",
        select_buffer = true,
      })
    end, "Explorer")

    -- todo ────────────────────────────────────────────────────

    map("<leader>fj", function()
      require("todo-comments").search()
    end, "Todo")
  end,
}
