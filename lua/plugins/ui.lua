-- The visible identity: statusline, winbar, breadcrumbs, cmdline,
-- notifications, indent guides, and the keymap guide.

local icons = require("umbra.icons")
local theme_glyphs = require("themes.glyphs")
local active_theme = require("themes.active")
local hl = require("umbra.hl")
local ui = require("umbra.tokens")
local motion = require("umbra.motion")

local function theme_fg(groups, fallback)
  return hl.first_fg(groups, fallback)
end

local function lualine_is_catppuccin()
  local name = vim.g.colors_name or ""
  return name:find("^catppuccin") ~= nil
end

local function lualine_is_kiln()
  return (vim.g.colors_name or "") == "kiln"
end

local function lualine_is_solder()
  return (vim.g.colors_name or "") == "solder"
end

local function lualine_is_loam()
  return (vim.g.colors_name or "") == "loam"
end

local function loam_segment(accent)
  if not lualine_is_loam() then
    return nil
  end
  local pal = active_theme.palette()
  if accent == "muted" then
    return { bg = pal.bg.panel, fg = pal.fg.muted }
  end
  return { bg = pal.bg.panel, fg = pal.accent[accent] or pal.fg.base }
end

local function lualine_mode_hl()
  if lualine_is_catppuccin() or lualine_is_solder() then
    return nil
  end
  if lualine_is_loam() then
    local pal = active_theme.palette()
    local map = {
      n = pal.accent.ember,
      no = pal.accent.ember,
      i = pal.accent.moss,
      ic = pal.accent.moss,
      v = pal.accent.clay,
      V = pal.accent.clay,
      ["\22"] = pal.accent.clay,
      c = pal.accent.straw,
      cv = pal.accent.straw,
      ce = pal.accent.straw,
      R = pal.diag.error,
      Rv = pal.diag.error,
      r = pal.diag.error,
      rm = pal.diag.error,
      t = pal.accent.plum,
    }
    local m = vim.fn.mode()
    return {
      bg = pal.bg.panel,
      fg = map[m] or pal.accent.ember,
    }
  end
  if lualine_is_kiln() then
    local pal = active_theme.palette()
    local map = {
      n = pal.accent.ember,
      no = pal.accent.ember,
      i = pal.accent.sage,
      ic = pal.accent.sage,
      v = pal.accent.violet,
      V = pal.accent.violet,
      ["\22"] = pal.accent.violet,
      c = pal.accent.gold,
      cv = pal.accent.gold,
      ce = pal.accent.gold,
      R = pal.diag.error,
      Rv = pal.diag.error,
      r = pal.diag.error,
      rm = pal.diag.error,
      t = pal.accent.rose,
    }
    local m = vim.fn.mode()
    return {
      bg = pal.bg.panel,
      fg = map[m] or pal.accent.ember,
      gui = "bold",
    }
  end
  local pal = active_theme.palette()
  local map = {
    n = pal.accent.blue,
    no = pal.accent.blue,
    i = pal.accent.emerald,
    ic = pal.accent.emerald,
    v = pal.accent.mauve,
    V = pal.accent.mauve,
    ["\22"] = pal.accent.mauve,
    c = pal.accent.yellow,
    cv = pal.accent.yellow,
    ce = pal.accent.yellow,
    R = pal.accent.red,
    Rv = pal.accent.red,
    r = pal.accent.red,
    rm = pal.accent.red,
    t = pal.accent.teal,
  }
  local m = vim.fn.mode()
  return {
    bg = map[m] or pal.accent.blue,
    fg = pal.bg.base,
    gui = "bold",
  }
end

local function lualine_resolve_theme()
  local name = vim.g.colors_name or ""
  if name == "kiln" then
    return require("themes.kiln").lualine()
  end
  if name == "solder" then
    return require("themes.solder").lualine()
  end
  if name == "loam" then
    return require("themes.loam").lualine()
  end
  if name == "meridian" then
    return require("themes.meridian").lualine()
  end
  if name == "umbra" then
    return require("themes.umbra").lualine()
  end
  return "auto"
end

local function lualine_default_sections()
  return {
    lualine_a = {
      {
        "mode",
        fmt = function(s)
          return s:sub(1, 3):upper()
        end,
        color = lualine_mode_hl,
        padding = { left = 1, right = 1 },
      },
    },
    lualine_b = {
      {
        "branch",
        icon = theme_glyphs.statusline_branch_icon(),
        color = function()
          return loam_segment("straw")
        end,
        padding = { left = 1, right = 1 },
      },
      {
        "diff",
        symbols = theme_glyphs.statusline_diff_symbols(),
        color = function()
          return loam_segment("straw")
        end,
        padding = { left = 0, right = 1 },
      },
    },
    lualine_c = {
      {
        "filename",
        path = 1,
        symbols = {
          modified = "  " .. icons.ui.modified,
          readonly = "  " .. icons.ui.lock,
          unnamed = "[No Name]",
        },
        padding = { left = 1, right = 1 },
      },
      {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        symbols = theme_glyphs.statusline_diagnostic_symbols(),
        padding = { left = 0, right = 1 },
      },
    },
    lualine_x = {
      {
        function()
          local ok, vs = pcall(require, "venv-selector")
          if ok and vs and vs.venv then
            local p = vs.venv()
            if p and p ~= "" then
              return " " .. vim.fn.fnamemodify(p, ":t")
            end
          end
          if vim.env.CONDA_DEFAULT_ENV and vim.env.CONDA_DEFAULT_ENV ~= "" then
            return " " .. vim.env.CONDA_DEFAULT_ENV
          end
          if vim.env.VIRTUAL_ENV and vim.env.VIRTUAL_ENV ~= "" then
            return " " .. vim.fn.fnamemodify(vim.env.VIRTUAL_ENV, ":t")
          end
          local clients = vim.lsp.get_clients({ bufnr = 0, name = "basedpyright" })
          if #clients > 0 and clients[1].config.settings and clients[1].config.settings.python then
            local py = clients[1].config.settings.python.pythonPath
            if py and py ~= "" then
              local venv_dir = vim.fn.fnamemodify(py, ":h:h")
              return " " .. vim.fn.fnamemodify(venv_dir, ":t")
            end
          end
          return ""
        end,
        cond = function() return vim.bo.filetype == "python" end,
        padding = { left = 0, right = 1 },
      },
      {
        "filetype",
        color = function()
          return loam_segment("muted")
        end,
        padding = { left = 0, right = 1 },
      },
    },
    lualine_y = {
      {
        "location",
        color = function()
          return loam_segment("muted")
        end,
        padding = { left = 1, right = 1 },
      },
    },
    lualine_z = {
      {
        "progress",
        color = function()
          if lualine_is_loam() then
            return loam_segment("muted")
          end
          return lualine_mode_hl()
        end,
        padding = { left = 1, right = 1 },
      },
    },
  }
end

local function lualine_default_inactive_sections()
  return {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { "filename", path = 1 } },
    lualine_x = { { "location" } },
    lualine_y = {},
    lualine_z = {},
  }
end

local function lualine_build_sections()
  if lualine_is_solder() then
    return require("themes.solder").lualine_sections(icons)
  end
  return lualine_default_sections()
end

local function lualine_build_inactive_sections()
  if lualine_is_solder() then
    return require("themes.solder").lualine_inactive_sections()
  end
  return lualine_default_inactive_sections()
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
      local flat = lualine_is_kiln() or lualine_is_solder() or lualine_is_loam()

      return {
        options = {
          theme = lualine_resolve_theme(),
          globalstatus = true,
          component_separators = flat and { left = "", right = "" } or { left = "", right = "" },
          section_separators = flat and { left = "", right = "" } or { left = "", right = "" },
          disabled_filetypes = { statusline = { "alpha" }, winbar = { "alpha", "neo-tree", "cursoragent_terminal", "cursoragent_chat", "cursoragent_composer" } },
          refresh = { statusline = 100 },
        },
        sections = lualine_build_sections(),
        inactive_sections = lualine_build_inactive_sections(),
        extensions = { "neo-tree", "lazy", "toggleterm", "trouble", "quickfix", "man" },
      }
    end,
    config = function(_, opts)
      require("lualine").setup(opts)

      local group = vim.api.nvim_create_augroup("umbra_lualine_theme", { clear = true })

      -- Re-resolve theme table when colorscheme changes.
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = group,
        callback = function()
          local ok, lualine = pcall(require, "lualine")
          if not ok then
            return
          end
          local name = vim.g.colors_name
          local theme = "auto"
          local flat = name == "kiln" or name == "solder" or name == "loam"
          if name == "kiln" then
            theme = require("themes.kiln").lualine()
          elseif name == "solder" then
            theme = require("themes.solder").lualine()
          elseif name == "loam" then
            theme = require("themes.loam").lualine()
          elseif name == "meridian" then
            theme = require("themes.meridian").lualine()
          elseif name == "umbra" then
            theme = require("themes.umbra").lualine()
          end
          opts.options.theme = theme
          opts.options.component_separators = flat and { left = "", right = "" } or { left = "", right = "" }
          opts.options.section_separators = flat and { left = "", right = "" } or { left = "", right = "" }
          opts.sections = lualine_build_sections()
          opts.inactive_sections = lualine_build_inactive_sections()
          pcall(lualine.setup, opts)
        end,
      })

      -- Force a redraw so mode block colors flip immediately on mode change.
      vim.api.nvim_create_autocmd("ModeChanged", {
        group = group,
        callback = function()
          pcall(require("lualine").refresh, { place = { "statusline" } })
        end,
      })
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
          background_colour = "#000000",
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
          cmdline = { pattern = "^:", icon = "◇", lang = "vim" },
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
          border = { style = ui.border, padding = { ui.space.xs, ui.space.sm } },
          position = { row = "32%", col = "50%" },
          size = { width = 68, height = "auto" },
        },
        hover = {
          border = { style = ui.border },
          size = { max_width = 84, max_height = 24 },
        },
        mini = {
          timeout = 2800,
          position = { row = -2 },
          win_options = { winblend = ui.opacity.float },
        },
        notify = {
          border = { style = ui.border },
        },
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
      indent = {
        char = "│",
        tab_char = "│",
        highlight = "IblIndent",
      },
      scope = {
        enabled = true,
        show_start = false,
        show_end = false,
        highlight = "IblScope",
        char = "│",
      },
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
      preset = "helix",
      delay = 280,
      layout = { spacing = 4, width = { min = 24, max = 56 } },
      icons = {
        mappings = true,
        separator = " " .. icons.ui.chevron_right .. " ",
        group = "",
      },
      win = {
        border = ui.border,
        padding = { ui.space.sm, ui.space.md },
        title = true,
        title_pos = "center",
      },
      sort = { "local", "order", "group", "alphanum", "mod" },
      spec = {
        { "<leader>a", group = "agent", icon = "󰚩" },
        { "<leader>b", group = "buffer", icon = "󰓩" },
        { "<leader>c", group = "code", icon = "󰅩" },
        { "<leader>d", group = "debug", icon = "󰃤" },
        { "<leader>f", group = "find", icon = "󰍉" },
        { "<leader>g", group = "git", icon = "󰊢" },
        { "<leader>h", group = "harpoon", icon = "󰛢" },
        { "<leader>m", group = "markdown", icon = "󰍔" },
        { "<leader>n", group = "notify", icon = "󰎟" },
        { "<leader>o", group = "outline", icon = "󰙅" },
        { "<leader>p", group = "project", icon = "󰉋" },
        { "<leader>q", group = "session", icon = "󰦛" },
        { "<leader>r", group = "repl/refactor", icon = "󰑕" },
        { "<leader>R", group = "rest/http", icon = "󰖟" },
        { "<leader>s", group = "split", icon = "󰓩" },
        { "<leader>t", group = "terminal", icon = "󰆍" },
        { "<leader>T", group = "test", icon = "󰙨" },
        { "<leader>u", group = "ui/toggle", icon = "󰔎" },
        { "<leader>x", group = "diagnostics", icon = "󰒡" },
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
