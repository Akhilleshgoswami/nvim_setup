-- Editing ergonomics: surround, pairs, subword motions, jumps, marks, todos.

return {
  -- Surround: ys / ds / cs
  {
    "kylechui/nvim-surround",
    version = "*",
    keys = { "ys", "yss", "ds", "cs" },
    opts = {},
  },

  -- Auto pairs (blink handles bracket completion; this handles typing).
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      fast_wrap = { map = "<M-e>" },
      disable_filetype = { "TelescopePrompt", "vim" },
    },
  },

  -- Subword-aware w / e / b motions (camelCase, snake_case).
  {
    "chrisgrieser/nvim-spider",
    keys = {
      { "w", "<cmd>lua require('spider').motion('w')<cr>", mode = { "n", "o", "x" }, desc = "Spider w" },
      { "e", "<cmd>lua require('spider').motion('e')<cr>", mode = { "n", "o", "x" }, desc = "Spider e" },
      { "b", "<cmd>lua require('spider').motion('b')<cr>", mode = { "n", "o", "x" }, desc = "Spider b" },
      { "ge", "<cmd>lua require('spider').motion('ge')<cr>", mode = { "n", "o", "x" }, desc = "Spider ge" },
    },
    opts = { skipInsignificantPunctuation = true },
  },

  -- Flash: jump anywhere on screen.
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      modes = {
        char = { jump_labels = true },
        search = { enabled = false },
      },
      label = { rainbow = { enabled = false } },
    },
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash jump" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle flash search" },
    },
  },

  -- Marks & bookmarks in the sign column.
  {
    "chentoast/marks.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      default_mappings = true,
      builtin_marks = { ".", "<", ">", "^" },
      cyclic = true,
      refresh_interval = 250,
      sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
      bookmark_0 = { sign = "", virt_text = "bookmark" },
      mappings = {},
    },
  },

  -- Peek the line while typing `:123`.
  {
    "nacro90/numb.nvim",
    event = "CmdlineEnter",
    opts = { show_numbers = true, show_cursorline = true },
  },

  -- Todo / Fixme / Note comment highlighting + search.
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev todo" },
      { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Todo comments" },
      { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
    },
    opts = {
      signs = true,
      highlight = { multiline = false, keyword = "wide_bg", pattern = [[.*<(KEYWORDS)\s*:]] },
      search = { pattern = [[\b(KEYWORDS):]] },
      keywords = {
        FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "ISSUE" } },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        PERF = { icon = " ", alt = { "OPTIMIZE", "PERFORMANCE" } },
        SECURITY = { icon = " ", color = "error", alt = { "SEC", "VULN" } },
      },
    },
  },
}
