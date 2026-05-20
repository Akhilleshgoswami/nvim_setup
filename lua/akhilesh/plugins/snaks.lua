-- lua/akhilesh/plugins/snacks.lua
return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- ─── Dashboard ────────────────────────────────────────────────────
      dashboard = {
        enabled = true,
        preset = {
          -- Shown above the buttons
          header = [[
           "                                                     ",
  "    ▄▄▄       ██ ▄█▀ ██░ ██  ██▓ ██▓    ▓█████   ██████  ██░ ██         ",
  "   ▒████▄     ██▄█▒ ▓██░ ██▒▓██▒▓██▒    ▓█   ▀ ▒██    ▒ ▓██░ ██▒        ",
  "   ▒██  ▀█▄  ▓███▄░ ▒██▀▀██░▒██▒▒██░    ▒███   ░ ▓██▄   ▒██▀▀██░        ",
  "   ░██▄▄▄▄██ ▓██ █▄ ░▓█ ░██ ░██░▒██░    ▒▓█  ▄   ▒   ██▒░▓█ ░██         ",
  "    ▓█   ▓██▒▒██▒ █▄░▓█▒░██▓░██░░██████▒░▒████▒▒██████▒▒░▓█▒░██▓        ",
  "    ▒▒   ▓▒█░▒ ▒▒ ▓▒ ▒ ░░▒░▒░▓  ░ ▒░▓  ░░░ ▒░ ░▒ ▒▓▒ ▒ ░ ▒ ░░▒░▒        ",
  "                                                                       ",
  "              ~/blockchain ~/backend ~/nvim                           ",
  "                                                                       ",
  ]],
          -- Custom keys shown on the dashboard
          keys = {
            { icon = " ", key = "f", desc = "Find File",       action = ":lua Snacks.picker.files()" },
            { icon = " ", key = "n", desc = "New File",        action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text",       action = ":lua Snacks.picker.grep()" },
            { icon = " ", key = "r", desc = "Recent Files",    action = ":lua Snacks.picker.recent()" },
            { icon = " ", key = "c", desc = "Config",          action = ":lua Snacks.picker.files({ cwd = vim.fn.stdpath('config') })" },
            { icon = " ", key = "s", desc = "Restore Session", action = ":lua require('persistence').load()", enabled = package.loaded["persistence"] ~= nil },
            { icon = "󰒲 ", key = "l", desc = "Lazy",            action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit",            action = ":qa" },
          },
        },
        sections = {
          { section = "header" },
          { icon = " ", title = "Keymaps",       section = "keys",      indent = 2, padding = 1 },
          { icon = " ", title = "Recent Files",  section = "recent_files", indent = 2, padding = 1, limit = 5 },
          { icon = " ", title = "Projects",      section = "projects",  indent = 2, padding = 1 },
          {
            icon = " ",
            title = "Git Status",
            section = "terminal",
            enabled = vim.fn.isdirectory(".git") == 1,
            cmd = "git --no-pager diff --stat -B -M -C HEAD 2>/dev/null | head -20",
            height = 5,
            padding = 1,
            ttl = 5 * 60,
            indent = 3,
          },
          { section = "startup" },
        },
      },

      -- ─── Notifier (replaces nvim-notify when used standalone) ─────────
      notifier = {
        enabled = true,   -- set false if you use nvim-notify via noice
        timeout = 3000,
        width = { min = 40, max = 0.4 },
        height = { min = 1, max = 0.6 },
        margin = { top = 0, right = 1, bottom = 0 },
        padding = true,
        sort = { "level", "added" },
        icons = {
          error = " ",
          warn  = " ",
          info  = " ",
          debug = " ",
          trace = " ",
        },
        style = "compact",
        top_down = false,
      },

      -- ─── Picker (fzf-style finder) ─────────────────────────────────────
      picker = {
        enabled = true,
      },

      -- ─── Useful QoL snacks ─────────────────────────────────────────────
      bigfile  = { enabled = true },   -- disable features for big files
      indent   = { enabled = true },   -- indent guides
      input    = { enabled = true },   -- nicer vim.ui.input
      quickfile = { enabled = true },  -- fast file opening
      scroll   = { enabled = true },   -- smooth scrolling
      statuscolumn = { enabled = true }, -- nicer sign/fold column
      words    = { enabled = true },   -- highlight word under cursor

      -- ─── Disabled (we use noice for these) ────────────────────────────
      lazygit  = { enabled = true },
    },
    keys = {
      -- Picker
      { "<leader>ff", function() Snacks.picker.files() end,         desc = "Find Files" },
      { "<leader>fg", function() Snacks.picker.grep() end,          desc = "Grep" },
      { "<leader>fr", function() Snacks.picker.recent() end,        desc = "Recent Files" },
      { "<leader>fb", function() Snacks.picker.buffers() end,       desc = "Buffers" },
      { "<leader>fh", function() Snacks.picker.help() end,          desc = "Help" },
      { "<leader>fc", function() Snacks.picker.command_history() end, desc = "Command History" },
      -- Git
      { "<leader>gg", function() Snacks.lazygit() end,              desc = "Lazygit" },
      { "<leader>gb", function() Snacks.git.blame_line() end,       desc = "Git Blame Line" },
      -- Scratch
      { "<leader>.",  function() Snacks.scratch() end,              desc = "Toggle Scratch Buffer" },
      { "<leader>S",  function() Snacks.scratch.select() end,       desc = "Select Scratch Buffer" },
      -- Notifications
      { "<leader>un", function() Snacks.notifier.hide() end,        desc = "Dismiss Notifications" },
      -- Words (jump to next/prev usage)
      { "]]",         function() Snacks.words.jump(vim.v.count1) end,  desc = "Next Reference",  mode = { "n", "t" } },
      { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference",  mode = { "n", "t" } },
    },
  },
}
