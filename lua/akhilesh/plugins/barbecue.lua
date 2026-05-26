-- ============================================================
--  lua/akhilesh/plugins/dropbar.lua
--  Breadcrumb bar — TokyoNight palette
-- ============================================================

return {
  "Bekaboo/dropbar.nvim",

  event = { "BufReadPre", "BufNewFile" },

  dependencies = {
    "nvim-telescope/telescope-fzf-native.nvim",
    "nvim-tree/nvim-web-devicons",
  },

  config = function()
    local dropbar_api = require("dropbar.api")

    -- =========================================================
    -- HIGHLIGHTS  (TokyoNight palette)
    -- =========================================================

    local function set_hl()
      local set = vim.api.nvim_set_hl

      -- Bar background — invisible seam with statusline / winbar
      set(0, "DropBarIconUIPickPivot",  { fg = "#ff79c6", bold = true })
      set(0, "DropBarMenuCurrentContext", { bg = "#162033", bold = true })

      -- Separator between crumbs  ›
      set(0, "DropBarIconUISeparator", {
        fg = "#3b4261",
        bg = "NONE",
      })

      -- Path segments
      set(0, "DropBarFileName", {
        fg = "#cdd6f4",
        bg = "NONE",
        bold = false,
      })

      -- Active / current segment  (last crumb)
      set(0, "DropBarFileNameModified", {
        fg = "#e0af68",
        bg = "NONE",
        italic = true,
      })

      -- Symbol kinds
      set(0, "DropBarKindFunction",  { fg = "#7aa2f7", bg = "NONE" })
      set(0, "DropBarKindMethod",    { fg = "#7aa2f7", bg = "NONE" })
      set(0, "DropBarKindClass",     { fg = "#bb9af7", bg = "NONE" })
      set(0, "DropBarKindStruct",    { fg = "#bb9af7", bg = "NONE" })
      set(0, "DropBarKindInterface", { fg = "#7dcfff", bg = "NONE" })
      set(0, "DropBarKindModule",    { fg = "#9ece6a", bg = "NONE" })
      set(0, "DropBarKindField",     { fg = "#cdd6f4", bg = "NONE" })
      set(0, "DropBarKindVariable",  { fg = "#cdd6f4", bg = "NONE" })
      set(0, "DropBarKindConstant",  { fg = "#ff9e64", bg = "NONE" })
      set(0, "DropBarKindProperty",  { fg = "#73daca", bg = "NONE" })
      set(0, "DropBarKindEnum",      { fg = "#f7768e", bg = "NONE" })
      set(0, "DropBarKindEnumMember",{ fg = "#f7768e", bg = "NONE" })
      set(0, "DropBarKindKeyword",   { fg = "#f7768e", bg = "NONE" })
      set(0, "DropBarKindNull",      { fg = "#6b7280", bg = "NONE" })
      set(0, "DropBarKindString",    { fg = "#9ece6a", bg = "NONE" })
      set(0, "DropBarKindNumber",    { fg = "#ff9e64", bg = "NONE" })
      set(0, "DropBarKindBoolean",   { fg = "#ff9e64", bg = "NONE" })
      set(0, "DropBarKindArray",     { fg = "#7dcfff", bg = "NONE" })
      set(0, "DropBarKindObject",    { fg = "#7dcfff", bg = "NONE" })
      set(0, "DropBarKindNamespace", { fg = "#7dcfff", bg = "NONE" })
      set(0, "DropBarKindPackage",   { fg = "#9ece6a", bg = "NONE" })
      set(0, "DropBarKindFile",      { fg = "#7aa2f7", bg = "NONE" })
      set(0, "DropBarKindFolder",    { fg = "#e0af68", bg = "NONE" })

      -- Pick-mode labels (the letter hints)
      set(0, "DropBarIconUIPickPivot", { fg = "#ff79c6", bold = true, bg = "NONE" })

      -- Menu
      set(0, "DropBarMenuNormalFloat",  { bg = "#0f172a", fg = "#cdd6f4" })
      set(0, "DropBarMenuFloatBorder",  { bg = "#0f172a", fg = "#1e293b" })
      set(0, "DropBarMenuHoverEntry",   { bg = "#162033", fg = "#7dcfff", bold = true })
      set(0, "DropBarMenuHoverIcon",    { bg = "#162033" })
      set(0, "DropBarMenuHoverSymbol",  { bg = "#162033", bold = true, italic = true })
    end

    set_hl()

    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.schedule(set_hl)
      end,
    })

    -- =========================================================
    -- SETUP
    -- =========================================================

    require("dropbar").setup({

      general = {
        enable = function(buf, win)
          -- only normal file buffers
          if vim.bo[buf].buftype ~= "" then
            return false
          end

          -- skip floating windows
          if vim.api.nvim_win_get_config(win).relative ~= "" then
            return false
          end

          local excluded = {
            "alpha", "dashboard", "starter",
            "lazy",  "mason",
            "help",  "toggleterm",
            "neo-tree", "NvimTree", "Trouble", "oil",
            "qf",    "snacks_dashboard", "edgy",
          }

          return not vim.tbl_contains(excluded, vim.bo[buf].filetype)
        end,
      },

      -- =====================================================
      -- ICONS
      -- =====================================================

      icons = {
        enable = true,

        kinds = {
          use_devicons = true,
        },

        ui = {
          bar = {
            separator = "  ›  ",  -- spaced chevron — clean breadcrumb look
            extends   = "…",
          },

          menu = {
            separator  = " ",
            indicator  = " ",
          },
        },
      },

      -- =====================================================
      -- BAR
      -- =====================================================

      bar = {
        padding = {
          left  = 2,
          right = 1,
        },

        pick = {
          pivots = "abcdefghijklmnopqrstuvwxyz",
        },

        truncate = true,

        sources = function(buf, _)
          local sources = require("dropbar.sources")
          local utils   = require("dropbar.utils")

          -- markdown → path + heading hierarchy
          if vim.bo[buf].ft == "markdown" then
            return {
              sources.path,
              sources.markdown,
            }
          end

          -- everything else → path + LSP, fall back to treesitter
          return {
            sources.path,
            utils.source.fallback({
              sources.lsp,
              sources.treesitter,
            }),
          }
        end,
      },

      -- =====================================================
      -- MENU
      -- =====================================================

      menu = {
        quick_navigation = true,

        win_configs = {
          border     = "rounded",
          style      = "minimal",
          winblend   = 8,
          col        = 1,
        },

        keymaps = {
          ["q"]     = function() require("dropbar.api").fuzzy_find_toggle() end,
          ["<Esc>"] = function()
            local menu = require("dropbar.api").get_current_dropbar_menu()
            if menu then menu:close() end
          end,
        },
      },
    })

    -- =========================================================
    -- KEYMAPS
    -- =========================================================

    local map = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { desc = desc, silent = true })
    end

    map("<leader>;", dropbar_api.pick,               "Dropbar pick")
    map("[;",        dropbar_api.goto_context_start,  "Context start")
    map("];",        dropbar_api.select_next_context, "Next context")
  end,
}
