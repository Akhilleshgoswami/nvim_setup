-- Productivity tooling: sessions, undo history, focus mode, markdown,
-- an HTTP client, and a database UI.

local ui = require("umbra.tokens")

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
      -- The dashboard is always the landing screen. Sessions still save
      -- automatically per-project, but restoring is an explicit action
      -- (dashboard `s`, or `<leader>ql`) rather than something that hijacks
      -- startup and drops you straight into code.
      auto_restore = false,
      auto_save = true,
      auto_create = true,
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
      vim.g.undotree_SplitWidth = ui.panel.md
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
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {
      heading = { icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " } },
      code = { style = "full", width = "block", left_pad = 1, right_pad = 2 },
      bullet = { icons = { "●", "○", "◆", "◇" } },
      checkbox = { checked = { icon = "󰄲 " }, unchecked = { icon = "󰄱 " } },
      file_types = { "markdown" },
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
    init = function()
      -- Browser preview renders Mermaid/KaTeX and follows the cursor.
      vim.g.mkdp_theme = "dark"
      vim.g.mkdp_preview_options = { disable_sync_scroll = 0, katex = {}, mermaid = {} }
    end,
  },

  -- ── Paste images straight into Markdown (and AI chats) ─────────
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    cmd = { "PasteImage" },
    keys = { { "<leader>mi", "<cmd>PasteImage<cr>", desc = "Paste image from clipboard" } },
    opts = {
      default = {
        embed_image_as_base64 = false,
        prompt_for_file_name = true,
        drag_and_drop = { insert_mode = true },
        relative_to_current_file = true,
      },
      filetypes = {
        markdown = { url_encode_path = true, template = "![$CURSOR]($FILE_PATH)" },
      },
    },
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
      vim.g.db_ui_winwidth = ui.panel.md
    end,
  },
}
