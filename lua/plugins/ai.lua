-- Agentic AI & Intelligent Assistant Suite:
--   • neocursor: predictive inline ghost jumps
--   • codecompanion: agentic AI assistant with tools, slash commands, chat & MCP
--   • avante: Cursor-class multi-file editing & sidebar agent
--   • dressing: polished floating prompts and model pickers

local ui = require("umbra.tokens")

return {
  -- ── Neocursor: Predictive jump completion (disabled) ────────────
  {
    "teocns/neocursor.nvim",
    enabled = false,
  },

  -- ── Enhanced floating inputs and selection UI ───────────────────
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = {
        border = ui.border,
        win_options = { winblend = 0 },
      },
      select = {
        backend = { "telescope", "builtin" },
        telescope = require("telescope.themes").get_dropdown({
          layout_config = { width = 0.55, height = 0.40 },
        }),
      },
    },
  },

  -- ── CodeCompanion: Agentic AI Assistant (Chat, Tools, MCP) ─────
  {
    "olimorris/codecompanion.nvim",
    cmd = {
      "CodeCompanion",
      "CodeCompanionChat",
      "CodeCompanionCmd",
      "CodeCompanionActions",
    },
    keys = {
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", desc = "AI Chat (CodeCompanion)" },
      { "<leader>ai", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "AI Inline Prompt" },
      { "<leader>aP", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "AI Action Palette" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      strategies = {
        chat = {
          adapter = "anthropic",
        },
        inline = {
          adapter = "anthropic",
        },
      },
      display = {
        action_palette = {
          provider = "telescope",
        },
        chat = {
          window = {
            layout = "vertical",
            width = 0.38,
            border = ui.border,
          },
        },
      },
    },
  },

  -- ── Avante: Cursor-class Agentic AI IDE workflow ───────────────
  {
    "yetone/avante.nvim",
    cmd = { "AvanteAsk", "AvanteChat", "AvanteEdit", "AvanteToggle", "AvanteClear" },
    keys = {
      { "<leader>av", "<cmd>AvanteToggle<cr>", desc = "Avante: toggle AI sidebar" },
      { "<leader>ae", "<cmd>AvanteEdit<cr>", mode = { "n", "v" }, desc = "Avante: edit selection" },
      { "<leader>aR", "<cmd>AvanteClear<cr>", desc = "Avante: clear chat" },
    },
    version = false,
    opts = {
      provider = "claude",
      auto_suggestions_provider = "claude",
      mappings = {
        ask = "<leader>av",
        edit = "<leader>ae",
        refresh = "<leader>aR",
      },
    },
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      { "ColinKennedy/mega.cmdparse", dependencies = { "ColinKennedy/mega.logging" } },
    },
  },
}
