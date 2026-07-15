-- Productivity tooling: sessions, undo history, focus mode, markdown,
-- an HTTP client, and a database UI.

return {
  -- ── Session management ─────────────────────────────────────────
  {
    "rmagatti/auto-session",
    lazy = false,
    keys = {
      { "<leader>ql", "<cmd>SessionRestore<cr>", desc = "Restore session" },
      { "<leader>qs", "<cmd>SessionSave<cr>", desc = "Save session" },
      { "<leader>qd", "<cmd>SessionDelete<cr>", desc = "Delete session" },
    },
    opts = {
      auto_restore = false,
      auto_save = true,
      suppressed_dirs = { "~/", "~/Downloads", "/", "/tmp" },
      bypass_save_filetypes = { "alpha", "neo-tree" },
      -- Keep Telescope out of the startup path.
      session_lens = { load_on_setup = false },
    },
  },

  -- ── Undo history ───────────────────────────────────────────────
  {
    "mbbill/undotree",
    cmd = { "UndotreeToggle", "UndotreeShow" },
    keys = { { "<leader>uu", "<cmd>UndotreeToggle<cr>", desc = "Undo tree" } },
    init = function()
      vim.g.undotree_WindowLayout = 3
      vim.g.undotree_SplitWidth = 34
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
  },

  -- ── Focus / zen mode ───────────────────────────────────────────
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = { { "<leader>uz", "<cmd>ZenMode<cr>", desc = "Zen mode" } },
    opts = {
      window = { backdrop = 0.95, width = 0.72, options = { number = false, relativenumber = false, signcolumn = "no" } },
      plugins = {
        options = { laststatus = 0 },
        gitsigns = { enabled = false },
      },
    },
  },

  -- ── Markdown: in-editor rendering + browser preview ────────────
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion", "Avante" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {
      heading = { icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " } },
      code = { style = "full", width = "block", left_pad = 1, right_pad = 2 },
      bullet = { icons = { "●", "○", "◆", "◇" } },
      checkbox = { checked = { icon = "󰄲 " }, unchecked = { icon = "󰄱 " } },
      file_types = { "markdown", "codecompanion", "Avante" },
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    keys = { { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown preview" } },
  },

  -- ── REST / HTTP client ─────────────────────────────────────────
  {
    "mistweaverco/kulala.nvim",
    ft = { "http", "rest" },
    keys = {
      { "<leader>Rs", function() require("kulala").run() end, desc = "Send request" },
      { "<leader>Ra", function() require("kulala").run_all() end, desc = "Send all requests" },
      { "<leader>Rt", function() require("kulala").toggle_view() end, desc = "Toggle response view" },
      { "<leader>Rc", function() require("kulala").copy() end, desc = "Copy as curl" },
    },
    opts = { global_keymaps = false, display_mode = "split" },
  },

  -- ── Database UI ────────────────────────────────────────────────
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    keys = { { "<leader>uD", "<cmd>DBUIToggle<cr>", desc = "Database UI" } },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_win_position = "left"
      vim.g.db_ui_winwidth = 32
    end,
  },
}
