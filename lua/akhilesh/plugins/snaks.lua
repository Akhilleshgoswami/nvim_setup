-- ============================================================
--  lua/akhilesh/plugins/snacks.lua
--  Ultra Geeky Snacks Config
-- ============================================================

return {
  "folke/snacks.nvim",

  priority = 1000,
  lazy = false,

  opts = {

    -- ========================================================
    -- CORE
    -- ========================================================

    animate = {
      enabled = true,
      duration = 20,
      easing = "linear",
    },

    bigfile = {
      enabled = true,
      size = 1.5 * 1024 * 1024,
    },

    bufdelete = {
      enabled = true,
    },

    debug = {
      enabled = false,
    },

    dim = {
      enabled = true,
      scope = {
        min_size = 5,
        max_size = 20,
      },
    },

    git = {
      enabled = true,
    },

    gitbrowse = {
      enabled = true,
    },

    indent = {
      enabled = false,

      indent = {
        enabled = true,
        char = "▏",
      },

      animate = {
        enabled = false,
      },

      scope = {
        enabled = false,
        underline = false,
        only_current = false,
        char = "▎",
      },
    },

    input = {
      enabled = true,
    },

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
      width = { min = 30, max = 120 },
      height = { min = 1, max = 20 },
      margin = { top = 1, right = 2, bottom = 1 },
      padding = true,
      sort = { "level", "added" },
      style = "fancy",
    },

    quickfile = {
      enabled = true,
    },

    rename = {
      enabled = true,
    },

    scope = {
      enabled = true,
    },

    scroll = {
      enabled = true,

      animate = {
        duration = {
          step = 15,
          total = 180,
        },
      },
    },

    statuscolumn = {
      enabled = false,

      left = {
        "mark",
        "sign",
      },

      right = {
        "fold",
        "git",
      },

      folds = {
        open = true,
        git_hl = true,
      },

      git = {
        patterns = { "GitSign" },
      },
    },

    terminal = {
      enabled = true,

      win = {
        style = "terminal",
        border = "rounded",
      },
    },

    toggle = {
      enabled = true,
    },

    win = {
      enabled = true,

      backdrop = 60,

      wo = {
        winblend = 0,
      },
    },

    words = {
      enabled = true,

      debounce = 200,

      notify_jump = true,
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

      show = {
        statusline = false,
        tabline = false,
      },

      win = {
        backdrop = {
          transparent = false,
          blend = 95,
        },

        width = 0.75,
      },
    },

    -- ========================================================
    -- STYLES
    -- ========================================================

    styles = {

      notification = {
        border = "rounded",

        wo = {
          wrap = true,
          winblend = 10,
        },
      },

      lazygit = {
        width = 0.95,
        height = 0.95,
        border = "rounded",
      },

      terminal = {
        border = "rounded",
      },

      input = {
        relative = "cursor",
        row = 1,
        col = 0,
      },

      scratch = {
        border = "rounded",
      },
    },

    -- ========================================================
    -- DASHBOARD
    -- ========================================================

    dashboard = {

      preset = {

        header = [[

███╗   ██╗██╗   ██╗██╗███╗   ███╗
████╗  ██║██║   ██║██║████╗ ████║
██╔██╗ ██║██║   ██║██║██╔████╔██║
██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝

    AKHILESH'S CYBER TERMINAL

]],

        keys = {

          {
            icon = " ",
            key = "e",
            desc = "New File",
            action = ":ene | startinsert",
          },

          {
            icon = "󰱼 ",
            key = "f",
            desc = "Find Files",
            action = function()
              Snacks.picker.files()
            end,
          },

          {
            icon = "󰱼 ",
            key = "g",
            desc = "Live Grep",
            action = function()
              Snacks.picker.grep()
            end,
          },

          {
            icon = "󰋚 ",
            key = "r",
            desc = "Recent Files",
            action = function()
              Snacks.picker.recent()
            end,
          },

          {
            icon = "󰘬 ",
            key = "p",
            desc = "Projects",
            action = function()
              Snacks.picker.projects()
            end,
          },

          {
            icon = "󰒲 ",
            key = "l",
            desc = "Lazy",
            action = ":Lazy",
          },

          {
            icon = "󰊢 ",
            key = "q",
            desc = "Quit",
            action = ":qa",
          },
        },
      },

      sections = {

        { section = "header" },

        {
          section = "keys",
          gap = 1,
          padding = 2,
        },

        {
          icon = "󰋚 ",
          title = "Recent Files",
          section = "recent_files",
          indent = 2,
          padding = 1,
        },

        {
          icon = "󰘬 ",
          title = "Projects",
          section = "projects",
          indent = 2,
          padding = 1,
        },

        {
          section = "startup",
          padding = 1,
        },
      },
    },

    -- ========================================================
    -- PICKER
    -- ========================================================

    picker = {

      enabled = true,

      layout = {
        preset = "ivy",
      },

      matcher = {
        fuzzy = true,
        smartcase = true,
        ignorecase = true,
        sort_empty = false,
      },

      ui_select = true,

      formatters = {

        file = {
          truncate = 120,
        },
      },

      win = {

        input = {

          keys = {

            ["<Esc>"] = {
              "close",
              mode = { "n", "i" },
            },

            ["<C-j>"] = {
              "list_down",
              mode = { "i", "n" },
            },

            ["<C-k>"] = {
              "list_up",
              mode = { "i", "n" },
            },

            ["<C-q>"] = {
              "qflist",
              mode = { "i", "n" },
            },
          },
        },
      },
    },
  },

  -- ==========================================================
  -- KEYMAPS
  -- ==========================================================

  keys = {

    -- FILES
    {
      "<leader>ff",
      function()
        Snacks.picker.files()
      end,
      desc = "Find files",
    },

    {
      "<leader>fg",
      function()
        Snacks.picker.grep()
      end,
      desc = "Live grep",
    },

    {
      "<leader>fr",
      function()
        Snacks.picker.recent()
      end,
      desc = "Recent files",
    },

    {
      "<leader>fp",
      function()
        Snacks.picker.projects()
      end,
      desc = "Projects",
    },

    -- EXPLORER
    {
      "<leader>e",
      function()
        Snacks.explorer()
      end,
      desc = "Explorer",
    },

    -- GIT
    {
      "<leader>gg",
      function()
        Snacks.lazygit()
      end,
      desc = "Lazygit",
    },

    {
      "<leader>gb",
      function()
        Snacks.git.blame_line()
      end,
      desc = "Git blame",
    },

    {
      "<leader>go",
      function()
        Snacks.gitbrowse()
      end,
      desc = "Git browse",
    },

    -- TERMINAL
    {
      "<leader>tt",
      function()
        Snacks.terminal()
      end,
      desc = "Terminal",
    },

    {
      "<leader>td",
      function()
        Snacks.terminal("lazydocker")
      end,
      desc = "Lazydocker",
    },

    -- BUFFERS
    {
      "<leader>bd",
      function()
        Snacks.bufdelete()
      end,
      desc = "Delete buffer",
    },

    -- ZEN
    {
      "<leader>z",
      function()
        Snacks.zen()
      end,
      desc = "Zen mode",
    },

    -- NOTIFY
    {
      "<leader>un",
      function()
        Snacks.notifier.hide()
      end,
      desc = "Dismiss notifications",
    },

    -- WORDS
    {
      "]]",
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = "Next reference",
    },

    {
      "[[",
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = "Prev reference",
    },
  },

  -- ==========================================================
  -- INIT
  -- ==========================================================

  init = function()

    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",

      callback = function()

        Snacks.toggle.option("wrap", {
          name = "Wrap",
        }):map("<leader>uw")

        Snacks.toggle.option("spell", {
          name = "Spell",
        }):map("<leader>us")

        Snacks.toggle.option("relativenumber", {
          name = "Relative Number",
        }):map("<leader>uL")

        Snacks.toggle.dim():map("<leader>uD")

        Snacks.toggle.zen():map("<leader>uZ")

        Snacks.toggle.scroll():map("<leader>uS")

        Snacks.toggle.indent():map("<leader>uI")

        Snacks.toggle.words():map("<leader>uW")
      end,
    })
  end,
}
