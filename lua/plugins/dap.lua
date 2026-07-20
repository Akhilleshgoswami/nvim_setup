-- Debugging: a JetBrains/VS Code-class experience built on nvim-dap.
--   dap                 → the engine
--   dap-ui              → scopes / watches / call stack / breakpoints / console
--   dap-virtual-text    → inline variable values
--   dap-go / dap-python → language wiring
--   persistent-bps      → breakpoints survive restarts (per project)
--
-- Adapters (js-debug-adapter, delve, debugpy) are installed by
-- mason-tool-installer (see plugins/lsp.lua) to keep a single, race-free
-- installer. Everything is lazy: nothing here touches startup until a debug key.

local icons = require("umbra.icons")
local ui = require("umbra.tokens")

local function keys()
  local dap = function(fn)
    return function() require("dap")[fn]() end
  end
  local dapui = function(fn)
    return function() require("dapui")[fn]() end
  end
  local pb = function(fn)
    return function() require("persistent-breakpoints.api")[fn]() end
  end
  return {
    -- Control flow (VS Code / JetBrains function keys + <leader>d group).
    { "<F5>", dap("continue"), desc = "Debug: start/continue" },
    { "<leader>dc", dap("continue"), desc = "Start/continue" },
    { "<F10>", dap("step_over"), desc = "Debug: step over" },
    { "<leader>do", dap("step_over"), desc = "Step over" },
    { "<F11>", dap("step_into"), desc = "Debug: step into" },
    { "<leader>di", dap("step_into"), desc = "Step into" },
    { "<S-F11>", dap("step_out"), desc = "Debug: step out" },
    { "<leader>dO", dap("step_out"), desc = "Step out" },
    { "<leader>dC", dap("run_to_cursor"), desc = "Run to cursor" },
    { "<leader>dg", dap("goto_"), desc = "Go to line (no exec)" },
    { "<leader>dp", dap("pause"), desc = "Pause" },
    { "<leader>dR", dap("restart"), desc = "Restart" },
    { "<leader>dt", dap("terminate"), desc = "Terminate" },

    -- Breakpoints (persistent across restarts).
    { "<F9>", pb("toggle_breakpoint"), desc = "Debug: toggle breakpoint" },
    { "<leader>db", pb("toggle_breakpoint"), desc = "Toggle breakpoint" },
    { "<leader>dB", pb("set_conditional_breakpoint"), desc = "Conditional breakpoint" },
    { "<leader>dl", pb("set_log_point"), desc = "Log point" },
    { "<leader>dX", pb("clear_all_breakpoints"), desc = "Clear all breakpoints" },

    -- Inspection.
    { "<leader>du", dapui("toggle"), desc = "Toggle debug UI" },
    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL/console" },
    { "<leader>de", function() require("dapui").eval(nil, { enter = true }) end, mode = { "n", "v" }, desc = "Eval expression" },
    { "<leader>dw", function() require("dapui").elements.watches.add(vim.fn.expand("<cexpr>")) end, desc = "Watch expression" },
    { "<leader>df", function() require("dap").focus_frame() end, desc = "Focus current frame" },
  }
end

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        opts = {
          controls = { enabled = true },
          floating = { border = ui.border },
          layouts = {
            {
              position = "left",
              size = ui.panel.md,
              elements = {
                { id = "scopes", size = 0.35 },
                { id = "watches", size = 0.25 },
                { id = "stacks", size = 0.25 },
                { id = "breakpoints", size = 0.15 },
              },
            },
            {
              position = "bottom",
              size = 10,
              elements = {
                { id = "repl", size = 0.5 },
                { id = "console", size = 0.5 },
              },
            },
          },
          icons = { expanded = icons.ui.fold_open, collapsed = icons.ui.fold_closed, current_frame = "" },
        },
      },
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = { commented = true, virt_text_pos = "eol" },
      },
      {
        "Weissle/persistent-breakpoints.nvim",
        opts = { load_breakpoints_event = { "BufReadPost" } },
      },
      { "leoluz/nvim-dap-go", ft = "go", opts = {} },
      { "mfussenegger/nvim-dap-python", ft = "python" },
    },
    keys = keys,
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- ── Signs (soft, semantic colors) ──
      local sign = vim.fn.sign_define
      sign("DapBreakpoint", { text = "", texthl = "DapBreakpoint", numhl = "" })
      sign("DapBreakpointCondition", { text = "", texthl = "DapBreakpointCondition" })
      sign("DapLogPoint", { text = "", texthl = "DapLogPoint" })
      sign("DapStopped", { text = "", texthl = "DapStopped", linehl = "DapStoppedLine" })
      sign("DapBreakpointRejected", { text = "", texthl = "DapBreakpointRejected" })

      -- Sign colors are owned by the single ColorScheme reactor in
      -- features/theme.lua; apply them now in case DAP loads after the last
      -- theme change.
      pcall(function() require("features.theme").recolor_dap() end)

      -- ── UI opens/closes with the session ──
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

      -- ── Python (debugpy from mason) ──
      local ok_py, dap_python = pcall(require, "dap-python")
      if ok_py then
        local mason_py = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
        dap_python.setup(vim.uv.fs_stat(mason_py) and mason_py or "python3")
      end

      -- ── JavaScript / TypeScript (js-debug-adapter from mason) ──
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "js-debug-adapter",
          args = { "${port}" },
        },
      }
      local js_fts = { "javascript", "typescript", "javascriptreact", "typescriptreact" }
      for _, ft in ipairs(js_fts) do
        dap.configurations[ft] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
            sourceMaps = true,
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach to process",
            processId = function() return require("dap.utils").pick_process() end,
            cwd = "${workspaceFolder}",
            sourceMaps = true,
          },
        }
      end
    end,
  },
}
