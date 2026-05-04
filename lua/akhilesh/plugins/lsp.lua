return {
 "neovim/nvim-lspconfig",
 dependencies = {
  { "williamboman/mason.nvim", config = true },
  "williamboman/mason-lspconfig.nvim",
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  { "j-hui/fidget.nvim",       opts = {} },
  { "folke/neodev.nvim",       opts = {} },

  -- Completion and snippet plugins (for luasnip, cmp etc)
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },
 },

 config = function()
  -- Set completeopt for proper completion menu behavior
  vim.o.completeopt = "menu,menuone,noinsert"

  -- Diagnostic config
  vim.diagnostic.config({
   virtual_text = true,
   signs = true,
   underline = true,
   update_in_insert = false,
   severity_sort = true,
  })

  -- LSP attach autocmd and keymaps
  vim.api.nvim_create_autocmd("LspAttach", {
   group = vim.api.nvim_create_augroup("lsp_attach_config", { clear = true }),
   callback = function(event)
    local opts = { buffer = event.buf }

    local map = function(keys, func, desc)
     if desc then
      desc = "LSP: " .. desc
     end
     vim.keymap.set("n", keys, func, vim.tbl_extend("force", opts, { desc = desc }))
    end

    map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
    map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
    map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
    map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
    map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
    map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    -- map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
    map("K", vim.lsp.buf.hover, "Hover Documentation")
    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.server_capabilities.documentHighlightProvider then
     local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
     vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      buffer = event.buf,
      group = group,
      callback = vim.lsp.buf.document_highlight,
     })
     vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      buffer = event.buf,
      group = group,
      callback = vim.lsp.buf.clear_references,
     })
    end

    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
     map("<leader>th", function()
      if vim.lsp.inlay_hint.is_enabled() then
       vim.lsp.inlay_hint.disable()
      else
       vim.lsp.inlay_hint.enable()
      end
     end, "[T]oggle [H]ints")
    end
   end,
  })

  -- Setup capabilities with nvim-cmp
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = vim.tbl_deep_extend(
   "force",
   capabilities,
   require("cmp_nvim_lsp").default_capabilities()
  )

  local servers = {
       gopls = {
        capabilities = capabilities,
        settings = {
         gopls = {
          analyses = {
           unusedparams = true,
           unreachable = true,
          },
          staticcheck = true,
          completions = {
           unimported = true,
           usePlaceholders = true,
          },
         },
        },
       },
       lua_ls = {
        capabilities = capabilities,
        settings = {
         Lua = {
          completion = { callSnippet = "Replace" },
         },
        },
       },
       move_analyzer = {
        cmd = { "move-analyzer" },
        filetypes = { "move" },
        root_markers = { "Move.toml" },
        capabilities = capabilities,
       },
     

      },

      require("mason").setup({
       PATH = "skip",
       ui = {
        icons = {
         package_pending = " ",
         package_installed = " ",
         package_uninstalled = " ",
        },
       },
       max_concurrent_installers = 10,
      })

  local ensure_installed = vim.tbl_keys(servers)
  vim.list_extend(ensure_installed, { "stylua" })
  require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

  require("mason-lspconfig").setup({
   handlers = {
    function(server_name)
     local server_opts = servers[server_name] or {}
     require("lspconfig")[server_name].setup(server_opts)
    end,
   },
  })

  vim.lsp.handlers["textDocument/formatting"] = function() end

  require("luasnip.loaders.from_vscode").lazy_load()
 end,
}
