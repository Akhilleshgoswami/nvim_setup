-- What happens when a language server attaches: keymaps, inlay hints,
-- document highlight, and the global diagnostics presentation.

local ui = require("umbra.tokens")

local M = {}

local function on_attach(client, bufnr)
  vim.b[bufnr].lsp_attached = true

  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
  end

  -- Navigation (Telescope-powered for previews; loads on demand).
  map("n", "gd", "<cmd>Telescope lsp_definitions<cr>", "Go to definition")
  map("n", "gr", "<cmd>Telescope lsp_references<cr>", "References")
  map("n", "gI", "<cmd>Telescope lsp_implementations<cr>", "Implementations")
  map("n", "gy", "<cmd>Telescope lsp_type_definitions<cr>", "Type definition")
  map("n", "gD", vim.lsp.buf.declaration, "Declaration")

  -- Docs & help.
  map("n", "K", function() vim.lsp.buf.hover({ border = ui.border }) end, "Hover")
  map({ "n", "i" }, "<C-k>", function() vim.lsp.buf.signature_help({ border = ui.border }) end, "Signature help")

  -- Actions & refactors. Extract function/variable and generate
  -- constructor/interface surface through the standard code-action menu
  -- (<leader>ca) in visual/normal mode, provided by the language server.
  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
  map("n", "<leader>cl", vim.lsp.codelens.run, "Run code lens")
  map("n", "<leader>cr", "<cmd>LspRestart<cr>", "Restart LSP")

  local function source_action(kind)
    return function()
      vim.lsp.buf.code_action({
        context = { only = { kind }, diagnostics = {} },
        apply = true,
      })
    end
  end
  map("n", "<leader>co", source_action("source.organizeImports"), "Organize imports")
  map("n", "<leader>cM", source_action("source.addMissingImports.ts"), "Add missing imports")
  map("n", "<leader>cu", source_action("source.removeUnused.ts"), "Remove unused")
  if pcall(require, "inc_rename") then
    vim.keymap.set("n", "<leader>rn", function()
      return ":IncRename " .. vim.fn.expand("<cword>")
    end, { buffer = bufnr, expr = true, desc = "Rename symbol" })
  else
    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
  end

  -- Diagnostics.
  map("n", "<leader>cd", function() vim.diagnostic.open_float({ border = ui.border }) end, "Line diagnostics")
  map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Next diagnostic")
  map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Prev diagnostic")

  -- Inlay hints (on by default where supported).
  if client:supports_method("textDocument/inlayHint") then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    map("n", "<leader>ch", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
    end, "Toggle inlay hints")
  end

  -- Highlight references of the symbol under the cursor.
  if client:supports_method("textDocument/documentHighlight") then
    local group = vim.api.nvim_create_augroup("umbra_lsp_highlight_" .. bufnr, { clear = true })
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = group,
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      group = group,
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end

  -- Treesitter owns syntax colour; skip flat semantic tokens that flatten it.
  client.server_capabilities.semanticTokensProvider = nil
end

-- Re-attach LSP to every open code buffer (see features/intelligence.lua).
function M.ensure_buffers()
  require("features.intelligence").ensure_lsp()
end

function M.setup()
  local ic = require("umbra.icons")

  vim.diagnostic.config({
    severity_sort = true,
    update_in_insert = false,
    underline = true,
    virtual_text = {
      spacing = ui.space.lg,
      source = "if_many",
      prefix = ic.ui.dot,
      severity = { min = vim.diagnostic.severity.HINT },
    },
    float = {
      border = ui.border,
      source = "if_many",
      header = "",
      prefix = "",
    },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = ic.diagnostics.Error,
        [vim.diagnostic.severity.WARN] = ic.diagnostics.Warn,
        [vim.diagnostic.severity.INFO] = ic.diagnostics.Info,
        [vim.diagnostic.severity.HINT] = ic.diagnostics.Hint,
      },
    },
  })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("umbra_lsp_attach", { clear = true }),
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client then
        on_attach(client, event.buf)
      end
    end,
  })
end

M.on_attach = on_attach

return M
