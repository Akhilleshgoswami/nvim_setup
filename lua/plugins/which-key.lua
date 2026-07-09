-- ============================================================
--  lua/akhilesh/plugins/which-key.lua
--  Modern + Theme Adaptive + Clean Geek UI
-- ============================================================

return {
  "folke/which-key.nvim",

  event = "VeryLazy",

  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,

  opts = function()

    -- ========================================================
    -- THEME COLORS
    -- ========================================================

    local function hl(name, attr)
      local ok, h = pcall(vim.api.nvim_get_hl, 0, {
        name = name,
        link = false,
      })

      if not ok or not h[attr] then
        return nil
      end

      return string.format("#%06x", h[attr])
    end

    local colors = {
      bg      = hl("Normal", "bg") or "#111111",
      fg      = hl("Normal", "fg") or "#cdd6f4",

      blue    = hl("Function", "fg") or "#7aa2f7",
      green   = hl("String", "fg") or "#9ece6a",
      red     = hl("DiagnosticError", "fg") or "#f7768e",
      yellow  = hl("Type", "fg") or "#e0af68",
      purple  = hl("Statement", "fg") or "#bb9af7",
      cyan    = hl("Keyword", "fg") or "#7dcfff",

      comment = hl("Comment", "fg") or "#565f89",
    }

    -- ========================================================
    -- HIGHLIGHTS
    -- ========================================================

    local function set_hl()
      local set = vim.api.nvim_set_hl

      -- Main popup
      set(0, "WhichKeyNormal", {
        fg = colors.fg,
        bg = colors.bg,
      })

      set(0, "WhichKeyBorder", {
        fg = colors.comment,
        bg = colors.bg,
      })

      set(0, "WhichKeyTitle", {
        fg = colors.blue,
        bg = colors.bg,
        bold = true,
      })

      -- Keys
      set(0, "WhichKey", {
        fg = colors.cyan,
        bold = true,
      })

      set(0, "WhichKeySeparator", {
        fg = colors.comment,
      })

      set(0, "WhichKeyDesc", {
        fg = colors.fg,
      })

      set(0, "WhichKeyValue", {
        fg = colors.green,
      })

      set(0, "WhichKeyGroup", {
        fg = colors.purple,
        bold = true,
      })

      set(0, "WhichKeyIcon", {
        fg = colors.yellow,
      })

      set(0, "FloatBorder", {
        fg = colors.comment,
        bg = colors.bg,
      })
    end

    set_hl()

    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.schedule(set_hl)
      end,
    })

    -- ========================================================
    -- RETURN CONFIG
    -- ========================================================

    return {

      preset = "modern",

      delay = 200,

      notify = true,

      expand = 1,

      plugins = {

        marks = true,
        registers = true,
        spelling = {
          enabled = true,
          suggestions = 20,
        },

        presets = {
          operators = true,
          motions = true,
          text_objects = true,
          windows = true,
          nav = true,
          z = true,
          g = true,
        },
      },

      win = {
        border = "rounded",

        padding = { 1, 2 },

        title = true,

        title_pos = "center",

        zindex = 1000,

        wo = {
          winblend = 0,
        },
      },

      layout = {
        width = {
          min = 20,
        },

        spacing = 4,
      },

      icons = {

        breadcrumb = "󰳠",
        separator = "󰁔",
        group = "󰘦",

        mappings = true,

        keys = {
          Up = " ",
          Down = " ",
          Left = " ",
          Right = " ",

          C = "󰘴 ",
          M = "󰘵 ",
          D = "󰘳 ",
          S = "󰘶 ",

          CR = "󰌑 ",
          Esc = "󱊷 ",
          ScrollWheelDown = "󱕐 ",
          ScrollWheelUp = "󱕑 ",
          NL = "󰌑 ",
          BS = "󰁮 ",
          Space = "󱁐 ",
          Tab = "󰌒 ",
        },
      },

      show_help = true,
      show_keys = true,

      disable = {
        buftypes = {},
        filetypes = {},
      },

      spec = {

        -- ====================================================
        -- GROUPS
        -- ====================================================

        { "<leader>f", group = "󰱼 Find" },
        { "<leader>g", group = "󰊢 Git" },
        { "<leader>h", group = "󰡱 Hunk" },
        { "<leader>l", group = "󰒋 LSP" },
        { "<leader>t", group = "󰔟 Toggle" },
        { "<leader>x", group = "󰗼 Extras" },
        { "<leader>b", group = "󰓩 Buffer" },
        { "<leader>c", group = "󰘳 Code" },
        { "<leader>d", group = "󰃤 Debug" },
        { "<leader>r", group = "󰑕 Replace" },
        { "<leader>s", group = "󰱼 Search" },
        { "<leader>u", group = "󰔡 UI" },
        { "<leader>w", group = "󰖲 Window" },

        -- GitHub
        { "<leader>gp", group = "󰊤 Pull Requests" },
        { "<leader>gi", group = "󰆍 Issues" },

        -- Folding
        { "<leader>fo", desc = "Open Fold" },
        { "<leader>fc", desc = "Close Fold" },
        { "<leader>ft", desc = "Colorscheme (Telescope)" },
      },
    }
  end,
}
