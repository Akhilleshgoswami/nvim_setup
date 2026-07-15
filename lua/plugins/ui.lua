-- The visible identity: statusline, bufferline, breadcrumbs, cmdline,
-- notifications, indent guides, and the keymap guide.

local icons = require("utils.icons")
local palette = require("themes.umbra.palette")

return {
  -- Icon provider (shared).
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    opts = { color_icons = true, default = true },
  },

  -- ── Statusline ─────────────────────────────────────────────────
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      local function lsp_clients()
        local names = {}
        for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
          if client.name ~= "null-ls" and client.name ~= "copilot" then
            names[#names + 1] = client.name
          end
        end
        if #names == 0 then
          return ""
        end
        return "  " .. table.concat(names, " ")
      end

      local function macro()
        local reg = vim.fn.reg_recording()
        return reg ~= "" and ("  rec @" .. reg) or ""
      end

      local minimal_ft = { "neo-tree", "alpha", "toggleterm", "trouble", "aerial", "lazy", "mason" }

      return {
        options = {
          -- `auto` resolves to lua/lualine/themes/umbra.lua for Umbra, and to
          -- the active colorscheme's palette for every other theme — so the
          -- statusline follows `:Theme` without any manual wiring.
          theme = "auto",
          globalstatus = true,
          component_separators = "",
          section_separators = "",
          disabled_filetypes = { statusline = { "alpha" } },
          refresh = { statusline = 200 },
        },
        sections = {
          lualine_a = {
            { "mode", fmt = function(m) return " " .. m:sub(1, 3) end, padding = { left = 1, right = 1 } },
          },
          lualine_b = {
            { "branch", icon = icons.git.branch, padding = { left = 1, right = 1 } },
          },
          lualine_c = {
            {
              "diff",
              symbols = { added = icons.git.added .. " ", modified = icons.git.modified .. " ", removed = icons.git.removed .. " " },
              padding = { left = 1, right = 0 },
            },
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error .. " ",
                warn = icons.diagnostics.Warn .. " ",
                info = icons.diagnostics.Info .. " ",
                hint = icons.diagnostics.Hint .. " ",
              },
              padding = { left = 1, right = 1 },
            },
            {
              "filename",
              path = 1,
              symbols = { modified = " " .. icons.ui.modified, readonly = " " .. icons.ui.lock, unnamed = "[No Name]" },
              color = { fg = palette.fg.muted },
            },
          },
          lualine_x = {
            { macro, color = { fg = palette.accent.rose } },
            { lsp_clients, color = { fg = palette.fg.muted } },
            {
              function()
                local ok, conform = pcall(require, "conform")
                if not ok then return "" end
                local fmts = conform.list_formatters(0)
                return #fmts > 0 and ("󰉼 " .. fmts[1].name) or ""
              end,
              color = { fg = palette.fg.muted },
            },
          },
          lualine_y = {
            {
              function()
                local fmt = vim.bo.fileformat
                local enc = vim.bo.fileencoding
                local parts = {}
                if enc ~= "" and enc ~= "utf-8" then parts[#parts + 1] = enc end
                if fmt ~= "unix" then parts[#parts + 1] = fmt end
                return table.concat(parts, " ")
              end,
              color = { fg = palette.accent.sand },
            },
            { "filetype", icon_only = true, padding = { left = 1, right = 0 } },
          },
          lualine_z = {
            { "location", padding = { left = 1, right = 1 } },
            { "progress", padding = { left = 0, right = 1 } },
          },
        },
        inactive_sections = {
          lualine_c = { { "filename", path = 1, color = { fg = palette.fg.faint } } },
          lualine_x = { "location" },
        },
        extensions = { "neo-tree", "lazy", "toggleterm", "trouble", "quickfix", "man" },
      }
    end,
  },

  -- ── Bufferline (minimal, thin, no giant icons) ─────────────────
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<Tab>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Pin buffer" },
      { "<leader>bh", "<cmd>BufferLineCloseLeft<cr>", desc = "Close buffers left" },
      { "<leader>bl", "<cmd>BufferLineCloseRight<cr>", desc = "Close buffers right" },
      { "<leader>b1", "<cmd>BufferLineGoToBuffer 1<cr>", desc = "Buffer 1" },
      { "<leader>b2", "<cmd>BufferLineGoToBuffer 2<cr>", desc = "Buffer 2" },
      { "<leader>b3", "<cmd>BufferLineGoToBuffer 3<cr>", desc = "Buffer 3" },
    },
    opts = function()
      local p = palette
      return {
        options = {
          mode = "buffers",
          themable = true,
          numbers = "none",
          indicator = { style = "underline" },
          buffer_close_icon = icons.ui.close,
          modified_icon = icons.ui.modified,
          close_icon = icons.ui.close,
          left_trunc_marker = "",
          right_trunc_marker = "",
          max_name_length = 22,
          tab_size = 16,
          padding = 1,
          show_buffer_close_icons = false,
          show_close_icon = false,
          show_tab_indicators = true,
          separator_style = { "▏", "▏" },
          always_show_bufferline = false,
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(_, _, diag)
            local s = {}
            if diag.error then s[#s + 1] = icons.diagnostics.Error .. diag.error end
            if diag.warning then s[#s + 1] = icons.diagnostics.Warn .. diag.warning end
            return #s > 0 and (" " .. table.concat(s, " ")) or ""
          end,
          offsets = {
            {
              filetype = "neo-tree",
              text = "EXPLORER",
              text_align = "center",
              highlight = "NeoTreeTitleBar",
              separator = false,
            },
          },
          hover = { enabled = true, delay = 100, reveal = { "close" } },
        },
        highlights = {
          fill = { bg = p.bg.base },
          background = { fg = p.fg.muted, bg = p.bg.dark },
          buffer_selected = { fg = p.fg.base, bg = p.bg.base, bold = true, italic = false },
          buffer_visible = { fg = p.fg.dim, bg = p.bg.dark },
          separator = { fg = p.bg.base, bg = p.bg.dark },
          separator_selected = { fg = p.bg.base, bg = p.bg.base },
          separator_visible = { fg = p.bg.base, bg = p.bg.dark },
          indicator_selected = { fg = p.accent.indigo, bg = p.bg.base },
          modified = { fg = p.accent.sand, bg = p.bg.dark },
          modified_selected = { fg = p.accent.sand, bg = p.bg.base },
          modified_visible = { fg = p.accent.sand, bg = p.bg.dark },
          duplicate = { fg = p.fg.muted, bg = p.bg.dark, italic = true },
          duplicate_selected = { fg = p.fg.dim, bg = p.bg.base, italic = true },
          error_selected = { fg = p.diag.error, bg = p.bg.base },
          warning_selected = { fg = p.diag.warn, bg = p.bg.base },
          error = { fg = p.diag.error, bg = p.bg.dark },
          warning = { fg = p.diag.warn, bg = p.bg.dark },
        },
      }
    end,
  },

  -- ── Breadcrumbs / winbar ───────────────────────────────────────
  {
    "Bekaboo/dropbar.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>;", function() require("dropbar.api").pick() end, desc = "Breadcrumb pick" },
      { "]l", function() require("dropbar.api").select_next_context() end, desc = "Next context" },
    },
    opts = function()
      return {
        icons = {
          kinds = { symbols = setmetatable({}, { __index = function() return "" end }) },
          ui = { bar = { separator = " " .. icons.ui.chevron_right .. " ", extends = icons.ui.ellipsis } },
        },
        bar = {
          padding = { left = 1, right = 1 },
          sources = function(buf, _)
            local sources = require("dropbar.sources")
            if vim.bo[buf].ft == "markdown" then
              return { sources.markdown }
            end
            return {
              sources.path,
              { get_symbols = function(b, w, c)
                if vim.b[b].lsp_attached then
                  return sources.lsp.get_symbols(b, w, c)
                end
                return sources.treesitter.get_symbols(b, w, c)
              end },
            }
          end,
        },
      }
    end,
    config = function(_, opts)
      -- Populate kind symbols from our shared icon set.
      local symbols = {}
      for kind, glyph in pairs(icons.kinds) do
        symbols[kind] = glyph .. " "
      end
      opts.icons.kinds.symbols = symbols
      require("dropbar").setup(opts)
    end,
  },

  -- ── Command line + notifications + LSP UI ──────────────────────
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      {
        "rcarriga/nvim-notify",
        opts = {
          stages = "fade_in_slide_out",
          timeout = 2500,
          max_width = 62,
          max_height = 12,
          fps = 60,
          render = "wrapped-compact",
          top_down = false,
          background_colour = palette.bg.float,
          icons = {
            ERROR = icons.diagnostics.Error,
            WARN = icons.diagnostics.Warn,
            INFO = icons.diagnostics.Info,
            DEBUG = icons.ui.dot,
            TRACE = icons.ui.dot,
          },
        },
      },
    },
    opts = {
      cmdline = {
        view = "cmdline_popup",
        format = {
          cmdline = { pattern = "^:", icon = " ", lang = "vim" },
          search_down = { kind = "search", pattern = "^/", icon = "  ", lang = "regex" },
          search_up = { kind = "search", pattern = "^%?", icon = "  ", lang = "regex" },
          lua = { pattern = "^:%s*lua%s+", icon = "  ", lang = "lua" },
          help = { pattern = "^:%s*he?l?p?%s+", icon = " " },
        },
      },
      messages = { enabled = true, view = "mini" },
      lsp = {
        hover = { enabled = true },
        signature = { enabled = false }, -- blink owns signature help
        progress = { enabled = false }, -- fidget owns progress
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        documentation = {
          view = "hover",
          opts = { border = { style = "rounded" }, win_options = { winblend = 0 } },
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        lsp_doc_border = true,
      },
      views = {
        cmdline_popup = {
          border = { style = "rounded", padding = { 0, 1 } },
          position = { row = "40%", col = "50%" },
          size = { width = 62, height = "auto" },
        },
        mini = { win_options = { winblend = 0 } },
      },
      routes = {
        { filter = { event = "msg_show", any = { { find = "%d+L, %d+B" }, { find = "; after #%d+" }, { find = "; before #%d+" }, { find = "written" } } }, view = "mini" },
        { filter = { event = "msg_show", kind = "search_count" }, opts = { skip = true } },
      },
    },
    keys = {
      { "<leader>na", function() require("noice").cmd("all") end, desc = "Notification history" },
      { "<leader>nl", function() require("noice").cmd("last") end, desc = "Last message" },
      { "<leader>nd", function() require("noice").cmd("dismiss") end, desc = "Dismiss notifications" },
      { "<leader>un", function() require("noice").cmd("dismiss") end, desc = "Dismiss notifications" },
    },
  },

  -- ── Indent guides ──────────────────────────────────────────────
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = { char = "│", tab_char = "│" },
      scope = { enabled = true, show_start = false, show_end = false },
      exclude = {
        filetypes = {
          "help", "alpha", "dashboard", "neo-tree", "Trouble", "trouble",
          "lazy", "mason", "notify", "toggleterm", "lazyterm", "aerial",
          "man", "gitcommit", "TelescopePrompt", "TelescopeResults",
        },
      },
    },
  },

  -- ── Inline color previews (CSS/hex) ────────────────────────────
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      user_default_options = {
        names = false,
        css = true,
        tailwind = "both",
        mode = "virtualtext",
        virtualtext = "󱓻",
        virtualtext_inline = true,
      },
    },
  },

  -- ── Keymap guide ───────────────────────────────────────────────
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      delay = 300,
      icons = { mappings = false, separator = icons.ui.chevron_right },
      win = { border = "rounded", padding = { 1, 2 } },
      spec = {
        { "<leader>a", group = "ai" },
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>h", group = "harpoon" },
        { "<leader>n", group = "notify" },
        { "<leader>o", group = "outline" },
        { "<leader>q", group = "session" },
        { "<leader>r", group = "rename/refactor" },
        { "<leader>R", group = "rest/http" },
        { "<leader>s", group = "split" },
        { "<leader>t", group = "terminal" },
        { "<leader>u", group = "ui/toggle" },
        { "<leader>x", group = "diagnostics" },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
      },
    },
    keys = {
      { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer keymaps" },
    },
  },
}
