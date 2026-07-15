-- AI, integrated natively. Everything defaults to the Copilot provider so no
-- extra API keys are needed; set OPENAI_API_KEY / ANTHROPIC_API_KEY to unlock
-- the other adapters. All specs are lazy — none of this touches startup.

return {
  -- Copilot engine. Ghost text is served through blink.cmp (see completion.lua),
  -- so the inline suggestion/panel are disabled to avoid a double UI.
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        gitcommit = true,
        yaml = true,
        help = false,
        ["*"] = true,
      },
    },
  },

  -- CodeCompanion: chat, inline edits, and an action palette.
  {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions", "CodeCompanionCmd" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "AI actions" },
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "AI chat toggle" },
      { "<leader>ai", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "AI inline prompt" },
      { "<leader>ad", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "AI add to chat" },
    },
    opts = {
      strategies = {
        chat = { adapter = "copilot" },
        inline = { adapter = "copilot" },
        cmd = { adapter = "copilot" },
      },
      display = {
        chat = {
          window = { layout = "vertical", width = 0.35, border = "rounded" },
          show_settings = false,
        },
        action_palette = { provider = "default" },
        diff = { provider = "default" },
      },
      opts = { log_level = "ERROR" },
    },
  },

  -- Avante: a Cursor-style AI side panel with apply-diff editing.
  {
    "yetone/avante.nvim",
    build = "make",
    cmd = { "AvanteAsk", "AvanteToggle", "AvanteChat", "AvanteEdit", "AvanteRefresh" },
    keys = {
      { "<leader>av", "<cmd>AvanteToggle<cr>", desc = "Avante toggle" },
      { "<leader>aA", "<cmd>AvanteAsk<cr>", mode = { "n", "v" }, desc = "Avante ask" },
      { "<leader>ae", "<cmd>AvanteEdit<cr>", mode = "v", desc = "Avante edit selection" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      "zbirenbaum/copilot.lua",
      "MeanderingProgrammer/render-markdown.nvim",
    },
    opts = {
      provider = "copilot",
      behaviour = { auto_suggestions = false, auto_set_keymaps = true },
      windows = { position = "right", width = 34, sidebar_header = { rounded = true } },
    },
  },

  -- Claude Code: the CLI, wired into the editor for context-aware sessions.
  {
    "coder/claudecode.nvim",
    cmd = { "ClaudeCode", "ClaudeCodeFocus", "ClaudeCodeSend", "ClaudeCodeTreeAdd" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>aC", "<cmd>ClaudeCode<cr>", desc = "Claude Code toggle" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Claude Code send selection" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Claude Code focus" },
    },
    opts = {
      terminal = { provider = "native", split_side = "right", split_width_percentage = 0.35 },
    },
  },
}
