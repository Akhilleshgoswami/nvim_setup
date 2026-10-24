-- Cursor Agent CLI: terminal UI, MCP, diffs, and selection tracking.
-- Requires the Cursor CLI (`cursor-agent` / `agent`).
-- https://github.com/goodhee/cursoragent.nvim

local LOCAL_BIN = vim.fn.expand("~/.local/bin")

local function ensure_local_bin_on_path()
  local path = vim.env.PATH or ""
  if not path:find(LOCAL_BIN, 1, true) then
    vim.env.PATH = LOCAL_BIN .. ":" .. path
  end
end

local function resolve_cli()
  ensure_local_bin_on_path()
  local candidates = {
    LOCAL_BIN .. "/cursor-agent",
    LOCAL_BIN .. "/agent",
    "cursor-agent",
    "agent",
  }
  for _, cmd in ipairs(candidates) do
    if vim.fn.executable(cmd) == 1 then
      return cmd
    end
  end
  return nil
end

return {
  "goodhee/cursoragent.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = {
    "CursorAgent",
    "CursorAgentAgent",
    "CursorAgentAsk",
    "CursorAgentPlan",
    "CursorAgentResume",
    "CursorAgentSelection",
    "CursorAgentBuffer",
    "CursorAgentVersion",
  },
  keys = {
    { "<C-,>", "<cmd>CursorAgent<cr>", desc = "Toggle Cursor Agent" },
    { "<leader>aa", "<cmd>CursorAgent<cr>", desc = "Toggle Cursor Agent" },
    { "<leader>aA", "<cmd>CursorAgent<cr>", desc = "Cursor Agent (agent mode)" },
    { "<leader>aq", "<cmd>CursorAgentAsk<cr>", desc = "Cursor Agent (ask mode)" },
    { "<leader>ap", "<cmd>CursorAgentPlan<cr>", desc = "Cursor Agent (plan mode)" },
    { "<leader>ar", "<cmd>CursorAgentResume<cr>", desc = "Resume Cursor Agent" },
    { "<leader>as", "<cmd>CursorAgentSelection<cr>", mode = { "n", "v" }, desc = "Send selection to Cursor Agent" },
    { "<leader>ab", "<cmd>CursorAgentBuffer<cr>", desc = "Send buffer to Cursor Agent" },
  },
  opts = {
    terminal = {
      split_side = "right",
      split_width_percentage = 0.38,
      auto_close = false,
      git_repo_cwd = true,
      show_native_term_exit_tip = false,
    },
    auto_start = true,
    track_selection = true,
    keymaps = {
      toggle = {
        normal = "<C-,>",
        terminal = "<C-,>",
        variants = {},
      },
      window_navigation = true,
      scrolling = true,
    },
    -- Current CLI uses flags, not subcommands: `agent --mode=ask`.
    command_variants = {
      ask = "--mode=ask",
      plan = "--mode=plan",
      resume = "--resume",
    },
  },
  config = function(_, opts)
    local cli = resolve_cli()
    if not cli then
      vim.notify(
        "Cursor Agent CLI not found. Install it, then restart Neovim:\n  curl https://cursor.com/install -fsS | bash\n  echo 'export PATH=\"$HOME/.local/bin:$PATH\"' >> ~/.zshrc",
        vim.log.levels.ERROR,
        { title = "cursoragent.nvim" }
      )
      return
    end
    -- --trust skips the workspace prompt that otherwise hangs the nvim terminal.
    opts.terminal_cmd = cli .. " --trust"
    opts.terminal.provider = require("features.cursoragent_ui")
    require("cursoragent").setup(opts)
  end,
}
