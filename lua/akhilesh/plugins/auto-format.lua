return {
  "stevearc/conform.nvim",
  lazy = false,
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_fallback = true, timeout_ms = 1000 })
      end,
      mode = "",
      desc = "[F]ormat buffer",
    },
  },
  opts = {
    notify_on_error = true, -- Turn this on to see why it fails
    formatters_by_ft = {
      rust = { "rustfmt" },
      typescript = { "prettierd", "prettier", stop_after_first = true },
      javascriptreact = { "prettierd", "prettier", stop_after_first = true },
      typescriptreact = { "prettierd", "prettier", stop_after_first = true },
      go = { "gofmt" },
      -- solidity = { "prettierd", "prettier", stop_after_first = true },
    },
  },
}
