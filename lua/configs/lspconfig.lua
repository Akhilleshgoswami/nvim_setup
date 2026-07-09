require("nvchad.configs.lspconfig").defaults()

local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok, blink = pcall(require, "blink.cmp")
if ok and blink.get_lsp_capabilities then
  capabilities = blink.get_lsp_capabilities(capabilities)
end

vim.diagnostic.config({
  underline = true,
  virtual_text = {
    prefix = " ",
    spacing = 2,
    severity = { min = vim.diagnostic.severity.HINT },
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = " ",
    },
  },
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "if_many",
    header = "",
    prefix = "",
  },
})

local servers = {
  lua_ls = {
    capabilities = capabilities,
    settings = {
      Lua = {
        diagnostics = { globals = { "vim", "Snacks" } },
      },
    },
  },
  gopls = { capabilities = capabilities },
  ts_ls = {
    capabilities = capabilities,
    settings = {
      javascript = { validate = true },
      typescript = { validate = true },
    },
  },
  eslint = { capabilities = capabilities },
}

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then
      return
    end

    -- Let Treesitter/base46 own syntax colors (avoid flat LSP semantic palette)
    if vim.lsp.semantic_tokens and vim.lsp.semantic_tokens.stop then
      pcall(vim.lsp.semantic_tokens.stop, event.buf, client.id)
    end

    if client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
    end

    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, {
        buffer = event.buf,
        noremap = true,
        silent = true,
        desc = desc,
      })
    end

    map("gd", vim.lsp.buf.definition, "Go to Definition")
    map("gr", vim.lsp.buf.references, "Go to References")
    map("gI", vim.lsp.buf.implementation, "Go to Implementation")
    map("gy", vim.lsp.buf.type_definition, "Go to Type Definition")
    map("<leader>de", vim.diagnostic.open_float, "Show Diagnostics")
    map("[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
    map("]d", vim.diagnostic.goto_next, "Next Diagnostic")
    map("<leader>q", vim.diagnostic.setloclist, "Diagnostics List")
    map("K", vim.lsp.buf.hover, "Hover")
    map("<leader>rn", vim.lsp.buf.rename, "Rename")
    map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
  end,
})

if vim.lsp.config then
  for name, cfg in pairs(servers) do
    vim.lsp.config(name, cfg)
  end
  vim.lsp.enable({ "lua_ls", "gopls", "ts_ls", "eslint" })
else
  require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "gopls", "ts_ls", "eslint" },
    handlers = {
      function(server_name)
        local opts = servers[server_name] or { capabilities = capabilities }
        require("lspconfig")[server_name].setup(opts)
      end,
    },
  })
end
