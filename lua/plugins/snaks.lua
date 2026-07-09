-- ============================================================
--  lua/akhilesh/plugins/snaks.lua
--  Snacks : dashboard, picker, indent, terminal, notify, zen
--  Tokyonight Night-aligned
-- ============================================================
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    animate = {
      enabled = true,
      duration = 20,
      easing = "linear",
    },
    bigfile = {
      enabled = true,
      size = 1.5 * 1024 * 1024,
    },
    bufdelete = { enabled = true },
    debug     = { enabled = false },
    dim = {
      enabled = true,
      scope = { min_size = 5, max_size = 20 },
    },
    git       = { enabled = true },
    gitbrowse = { enabled = true },
    indent = {
      enabled = false,
    },
    explorer = {
      enabled = true,
      replace_netrw = false,
    },
    input = { enabled = true },
    lazygit = {
      enabled = true,
      configure = true,
    },
    notify = {
      enabled = true,
      timeout = 3000,
    },
    notifier = {
      enabled = true,
      timeout = 3000,
      width  = { min = 30, max = 120 },
      height = { min = 1, max = 20 },
      margin = { top = 1, right = 2, bottom = 1 },
      padding = true,
      sort  = { "level", "added" },
      style = "fancy",
      top_down = false,
    },
    quickfile = { enabled = true },
    rename    = { enabled = true },
    scope     = { enabled = true },
    scroll = {
      enabled = true,
      animate = {
        duration = { step = 15, total = 180 },
      },
    },
    statuscolumn = {
      enabled = false,
      left  = { "mark", "sign" },
      right = { "fold", "git" },
      folds = { open = true, git_hl = true },
      git   = { patterns = { "GitSign" } },
    },
    terminal = {
      enabled = true,
      win = { style = "terminal", border = "rounded" },
    },
    toggle = { enabled = true },
    win = {
      enabled = true,
      backdrop = 60,
      wo = { winblend = 0 },
    },
    words = {
      enabled = true,
      debounce = 200,
      notify_jump = false,
      modes = { "n" },
    },
    zen = {
      enabled = true,
      toggles = {
        dim = true,
        git_signs = false,
        mini_diff_signs = false,
        diagnostics = false,
        inlay_hints = false,
      },
      show = { statusline = false, tabline = false },
      win = {
        backdrop = { transparent = false, blend = 95 },
        width = 0.75,
      },
    },
    styles = {
      notification = {
        border = "rounded",
        wo = { wrap = true, winblend = 10 },
      },
      lazygit = {
        width = 0.92,
        height = 0.92,
        border = "rounded",
      },
      terminal = {
        border = "rounded",
        wo = { winblend = 0 },
      },
      input = {
        relative = "cursor",
        row = 1,
        col = 0,
        border = "rounded",
      },
      scratch = { border = "rounded" },
      explorer = {
        border = "none",
        wo = { winblend = 0 },
      },
      picker = {
        border = "rounded",
        wo = { winblend = 0 },
      },
    },
    dashboard = {
      enabled = false,
      width = 60,
      preset = {
        header = table.concat({
          "",
          "  ██╗  ██╗ █████╗ ██╗  ██╗██╗██╗     ███████╗███████╗██╗  ██╗",
          "  ██║ ██╔╝██╔══██╗██║  ██║██║██║     ██╔════╝██╔════╝██║  ██║",
          "  █████╔╝ ███████║███████║██║██║     █████╗  ███████╗███████║",
          "  ██╔═██╗ ██╔══██║██╔══██║██║██║     ██╔══╝  ╚════██║██╔══██║",
          "  ██║  ██╗██║  ██║██║  ██║██║███████╗███████╗███████║██║  ██║",
          "  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝",
          "",
          "         code  ·  craft  ·  conquer  ·  ship",
          "",
        }, "\n"),
        keys = {
          { icon = "󰈞", key = "f", desc = "Find File",       action = function() Snacks.picker.files() end },
          { icon = "󰈔", key = "n", desc = "New File",        action = ":ene | startinsert" },
          { icon = "󰱽", key = "g", desc = "Find Text",       action = function() Snacks.picker.grep() end },
          { icon = "󰋚", key = "r", desc = "Recent Files",    action = function() Snacks.picker.recent() end },
          { icon = "󰉋", key = "p", desc = "Projects",        action = function() Snacks.picker.projects() end },
          { icon = "󰒓", key = "c", desc = "Config",          action = function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end },
          { icon = "󰑖", key = "s", desc = "Restore Session", section = "session" },
          { icon = "󰒲", key = "l", desc = "Lazy",            action = ":Lazy" },
          { icon = "󰏗", key = "m", desc = "Mason",           action = ":Mason" },
          { icon = "󰗼", key = "q", desc = "Quit",            action = ":qa" },
        },
      },
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        {
          pane = 2,
          icon = " ",
          title = "Recent Files",
          section = "recent_files",
          indent = 2,
          padding = 1,
        },
        {
          pane = 2,
          icon = " ",
          title = "Projects",
          section = "projects",
          indent = 2,
          padding = 1,
        },
        {
          pane = 2,
          icon = " ",
          title = "Git Status",
          section = "terminal",
          enabled = function()
            return Snacks.git.get_root() ~= nil
          end,
          cmd = "git status --short --branch --renames",
          height = 5,
          padding = 1,
          ttl = 5 * 60,
          indent = 3,
        },
        { section = "startup", padding = 1 },
      },
    },
    picker = {
      enabled = true,
      layout = {
        preset = "default",
        preview = true,
        wo = { winblend = 0 },
      },
      sources = {
        explorer = {
          layout = { preset = "sidebar", preview = false },
          hidden = true,
          git_status = true,
          git_status_open = false,
          follow_file = true,
          win = {
            list = { border = "none" },
            input = { border = "none" },
          },
        },
      },
      matcher = {
        fuzzy = true,
        smartcase = true,
        ignorecase = true,
        sort_empty = false,
      },
      ui_select = true,
      formatters = {
        file = { truncate = 120 },
      },
      win = {
        input = {
          keys = {
            ["<Esc>"] = { "close",     mode = { "n", "i" } },
            ["<C-j>"] = { "list_down", mode = { "i", "n" } },
            ["<C-k>"] = { "list_up",   mode = { "i", "n" } },
            ["<C-q>"] = { "qflist",    mode = { "i", "n" } },
          },
        },
      },
    },
  },
  keys = {
    { "<leader>fg", function() Snacks.picker.grep()     end, desc = "Live grep" },
    { "<leader>fr", function() Snacks.picker.recent()   end, desc = "Recent files" },
    { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
    { "<leader>sg", function() Snacks.picker.grep()         end, desc = "Search in project (live grep)" },
    { "<leader>sw", function() Snacks.picker.grep_word()    end, mode = { "n", "x" }, desc = "Search word under cursor" },
    { "<leader>sf", function() Snacks.picker.files()        end, desc = "Search files" },
    { "<leader>sb", function() Snacks.picker.lines()        end, desc = "Search lines in buffer" },
    { "<leader>/", function() Snacks.picker.grep_buffers() end, desc = "Search in open buffers" },
    { "<leader>sr", function() Snacks.picker.resume()       end, desc = "Resume last search" },
    { "<leader>sh", function() Snacks.picker.help()         end, desc = "Search help" },
    { "<leader>sk", function() Snacks.picker.keymaps()      end, desc = "Search keymaps" },
    { "<leader>sc", function() Snacks.picker.commands()     end, desc = "Search commands" },
    { "<leader>sm", function() Snacks.picker.marks()        end, desc = "Search marks" },
    { "<leader>sR", function() Snacks.picker.registers()    end, desc = "Search registers" },
    { "<leader>sd", function() Snacks.picker.diagnostics()  end, desc = "Search diagnostics" },
    { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Search diagnostics (buffer)" },
    { "<leader>ss", function() Snacks.picker.lsp_symbols()           end, desc = "Document symbols" },
    { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "Workspace symbols" },
    { "<leader>sT", function() Snacks.picker.todo_comments()         end, desc = "Search TODOs" },
    { "<leader>sn", function() Snacks.picker.notifications()         end, desc = "Search notifications" },
    { "<leader>sj", function() Snacks.picker.jumps()                 end, desc = "Search jumplist" },
    { "<leader>sJ", function()
        Snacks.picker.grep({
          prompt = "  Project Jump ",
          regex = false,
          live = true,
          finder = "grep",
          format = "file",
          show_empty = true,
          supports_live = true,
          hidden = true,
        })
      end, desc = "Project-wide jump (grep every file)" },
      { "<leader>e", function() Snacks.explorer({ layout = { preset = "sidebar", preview = false } }) end, desc = "Explorer sidebar" },
    { "<leader>gg", function() Snacks.lazygit()              end, desc = "Lazygit" },
    { "<leader>gb", function() Snacks.git.blame_line()       end, desc = "Git blame" },
    { "<leader>go", function() Snacks.gitbrowse()            end, desc = "Git browse" },
    { "<leader>gl", function() Snacks.picker.git_log()       end, desc = "Git log" },
    { "<leader>gs", function() Snacks.picker.git_status()    end, desc = "Git status" },
    { "<leader>tt", function() Snacks.terminal()             end, desc = "Terminal" },
    { "<leader>td", function() Snacks.terminal("lazydocker") end, desc = "Lazydocker" },
    { "<leader>bd", function() Snacks.bufdelete()            end, desc = "Delete buffer" },
    { "<leader>z",  function() Snacks.zen()                  end, desc = "Zen mode" },
    { "<leader>un", function() Snacks.notifier.hide()        end, desc = "Dismiss notifications" },
    { "]]", function() Snacks.words.jump(vim.v.count1)  end, desc = "Next reference" },
    { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev reference" },
  },
  init = function()
    -- Redirect vim.notify to snacks notifier immediately at startup
    vim.notify = function(msg, level, opts)
      return Snacks.notify(msg, level, opts)
    end

    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        Snacks.toggle.option("wrap",           { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.option("spell",          { name = "Spell" }):map("<leader>us")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
        Snacks.toggle.dim():map("<leader>uD")
        Snacks.toggle.zen():map("<leader>uZ")
        Snacks.toggle.scroll():map("<leader>uS")
        Snacks.toggle.indent():map("<leader>uI")
        Snacks.toggle.words():map("<leader>uW")
      end,
    })
  end,
}
