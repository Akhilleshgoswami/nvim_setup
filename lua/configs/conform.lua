local options = {
  notify_on_error = true,
  formatters_by_ft = {
    lua = { "stylua" },
    rust = { "rustfmt" },
    typescript = { "prettierd", "prettier", stop_after_first = true },
    javascript = { "prettierd", "prettier", stop_after_first = true },
    javascriptreact = { "prettierd", "prettier", stop_after_first = true },
    typescriptreact = { "prettierd", "prettier", stop_after_first = true },
    go = { "gofmt" },
  },
}

return options
