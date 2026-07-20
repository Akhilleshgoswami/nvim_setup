-- The visible identity: statusline, winbar, breadcrumbs, cmdline,
-- notifications, indent guides, and the keymap guide.

local icons = require("umbra.icons")
local active_theme = require("themes.active")
local hl = require("umbra.hl")
local ui = require("umbra.tokens")
local motion = require("umbra.motion")

local function theme_fg(groups, fallback)
  return hl.first_fg(groups, fallback)
end

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
      -- Transient, important: which macro register is recording.
      local function macro()
        local reg = vim.fn.reg_recording()
        return reg ~= "" and (icons.ui.dot .. " rec @" .. reg) or ""
      end

      -- One dot: lit (accent) when a real language server is attached. The old
      -- statusline spelled out every client name — noise. The dot answers the
      -- only question that matters at a glance: "is intelligence live here?"
      local function lsp_dot()
        for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
          if client.name ~= "null-ls" and client.name ~= "copilot" then
            return icons.ui.dot
          end
        end
        return ""
      end

      -- Harpoon working set — the deliberate replacement for a bufferline.
      -- Shows only the files you chose to pin (1..6), active one emphasized.
      -- Guarded on package.loaded so it never force-loads Harpoon at startup.
      local function harpoon_marks()
        if not package.loaded["harpoon"] then return "" end
        local list = require("harpoon"):list()
        local items = list.items or {}
        if #items == 0 then return "" end
        local cur = vim.api.nvim_buf_get_name(0)
        local parts = {}
        for i, item in ipairs(items) do
          if i > 6 then break end
          local val = item.value or ""
          local name = val ~= "" and vim.fn.fnamemodify(val, ":t") or ("[" .. i .. "]")
          local active = val ~= "" and cur ~= "" and cur:sub(-#val) == val
          local grp = active and "UmbraHarpoonActive" or "UmbraHarpoonInactive"
          parts[#parts + 1] = ("%%#%s#%d %s%%*"):format(grp, i, name)
        end
        return icons.ui.bookmark .. " " .. table.concat(parts, "  ")
      end

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
        -- Left: where you are in the world (mode, branch, diff, working set).
        -- Center: calm, empty.
        -- Right: the current buffer's state (problems, LSP, position).
        sections = {
          lualine_a = {
            { "mode", fmt = function(m) return " " .. m:sub(1, 3) .. " " end, padding = { left = 0, right = 0 } },
          },
          lualine_b = {
            { "branch", icon = icons.git.branch, padding = { left = 1, right = 1 } },
          },
          lualine_c = {
            {
              "diff",
              symbols = { added = icons.git.added .. " ", modified = icons.git.modified .. " ", removed = icons.git.removed .. " " },
              padding = { left = 1, right = 1 },
            },
            { harpoon_marks, padding = { left = 1, right = 0 } },
            { macro, color = { fg = theme_fg({ "DiagnosticWarn", "WarningMsg" }, active_theme.palette().accent.rose) }, padding = { left = 1, right = 0 } },
          },
          lualine_x = {
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
            { lsp_dot, color = { fg = theme_fg({ "Function", "DiagnosticOk" }, active_theme.palette().accent.indigo) }, padding = { left = 0, right = 1 } },
          },
          lualine_y = {
            { "location", padding = { left = 1, right = 1 } },
          },
          lualine_z = {
            { "progress", padding = { left = 1, right = 1 } },
          },
        },
        inactive_sections = {
          lualine_c = {},
          lualine_x = { { "location", padding = { left = 1, right = 1 } } },
        },
        extensions = { "neo-tree", "lazy", "toggleterm", "trouble", "quickfix", "man" },
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
          stages = motion.enabled and "fade_in_slide_out" or "static",
          timeout = 2500,
          max_width = 62,
          max_height = 12,
          fps = motion.fps,
          render = "wrapped-compact",
          top_down = false,
          background_colour = hl.get("NormalFloat", "bg") or active_theme.palette().bg.float,
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
          cmdline = { pattern = "^:", icon = icons.ui.prompt, lang = "vim" },
          search_down = { kind = "search", pattern = "^/", icon = "\u{f0349}", lang = "regex" },
          search_up = { kind = "search", pattern = "^%?", icon = "\u{f0349}", lang = "regex" },
          lua = { pattern = "^:%s*lua%s+", icon = "\u{e620}", lang = "lua" },
          help = { pattern = "^:%s*he?l?p?%s+", icon = "?" },
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
          opts = { border = { style = ui.border }, win_options = { winblend = ui.opacity.float } },
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
          border = { style = ui.border, padding = { ui.space.none, ui.space.xs } },
          position = { row = "40%", col = "50%" },
          size = { width = 62, height = "auto" },
        },
        mini = { win_options = { winblend = ui.opacity.float } },
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
      indent = { char = icons.ui.separator, tab_char = icons.ui.separator },
      scope = { enabled = true, show_start = false, show_end = false },
      exclude = {
        filetypes = {
          "help", "alpha", "dashboard", "neo-tree", "Trouble", "trouble",
          "lazy", "mason", "notify", "toggleterm", "lazyterm", "aerial",
          "man", "gitcommit", "TelescopePrompt", "TelescopeResults",
          "dapui_scopes", "dapui_watches", "dapui_stacks", "dapui_breakpoints",
          "dapui_console", "dap-repl",
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
      win = { border = ui.border, padding = { ui.space.xs, ui.space.sm } },
      spec = {
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>h", group = "harpoon" },
        { "<leader>m", group = "markdown" },
        { "<leader>n", group = "notify" },
        { "<leader>o", group = "outline" },
        { "<leader>p", group = "project" },
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
