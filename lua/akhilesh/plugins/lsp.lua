return {
  "neovim/nvim-lspconfig",

  dependencies = {
    -- Mason
    { "williamboman/mason.nvim",                config = true },
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",

    -- UI
    { "j-hui/fidget.nvim",   opts = {} },
    { "folke/lazydev.nvim",  ft = "lua", opts = {} }, -- replaces neodev

    -- CMP
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },

    -- Snippets
    { "L3MON4D3/LuaSnip" },
    { "saadparwaiz1/cmp_luasnip" },
  },

  config = function()
    vim.o.completeopt = "menu,menuone,noinsert"

    -- ── Diagnostics ───────────────────────────────────────────
    vim.diagnostic.config({
      underline        = true,
      update_in_insert = false,
      virtual_text     = false,
      severity_sort    = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "●",
          [vim.diagnostic.severity.WARN]  = "●",
          [vim.diagnostic.severity.INFO]  = "●",
          [vim.diagnostic.severity.HINT]  = "●",
        },
      },
    })

    -- ── Fix position_encoding warning ─────────────────────────
    local orig_util = vim.lsp.util.make_position_params
    vim.lsp.util.make_position_params = function(window, position_encoding)
      position_encoding = position_encoding or "utf-16"
      return orig_util(window, position_encoding)
    end

    -- ── LSP keymaps (on attach) ───────────────────────────────
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp_attach_config", { clear = true }),
      callback = function(event)
        local opts = { buffer = event.buf }
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func,
            vim.tbl_extend("force", opts, { desc = "LSP: " .. (desc or "") }))
        end

        -- Go-to (snacks picker — remove telescope duplicates)
        map("gd",        function() Snacks.picker.lsp_definitions() end,       "Goto Definition")
        map("gr",        function() Snacks.picker.lsp_references() end,        "Goto References")
        map("gI",        function() Snacks.picker.lsp_implementations() end,   "Goto Implementation")
        map("gD",        function() Snacks.picker.lsp_declarations() end,      "Goto Declaration")
        map("gy",        function() Snacks.picker.lsp_type_definitions() end,  "Type Definition")
        map("<leader>ds",function() Snacks.picker.lsp_symbols() end,           "Document Symbols")
        map("<leader>ws",function() Snacks.picker.lsp_workspace_symbols() end, "Workspace Symbols")

        -- Actions
        map("<leader>rn", vim.lsp.buf.rename,    "Rename")
        map("<leader>ca", vim.lsp.buf.code_action,"Code Action")
        map("K",          vim.lsp.buf.hover,     "Hover")

        local client = vim.lsp.get_client_by_id(event.data.client_id)

        -- Document highlight
        if client and client.server_capabilities.documentHighlightProvider then
          local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer   = event.buf,
            group    = group,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer   = event.buf,
            group    = group,
            callback = vim.lsp.buf.clear_references,
          })
        end

        -- Inlay hints
        if client and client.server_capabilities.inlayHintProvider then
          map("<leader>th", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, "Toggle Hints")
        end
      end,
    })

    -- ── Capabilities ──────────────────────────────────────────
    local capabilities = vim.tbl_deep_extend("force",
      vim.lsp.protocol.make_client_capabilities(),
      require("cmp_nvim_lsp").default_capabilities(),
      {
        workspace = {
          fileOperations = {
            didRename  = true,
            willRename = true,
          },
        },
      }
    )

    -- ── Servers ───────────────────────────────────────────────
    local servers = {
      lua_ls = {
        capabilities = capabilities,
        settings = {
          Lua = {
            completion = { callSnippet = "Replace" },
          },
        },
      },

      gopls = {
        capabilities = capabilities,
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
              unreachable  = true,
            },
            staticcheck = true,
          },
        },
      },

      ts_ls = {  -- renamed from tsserver
        capabilities = capabilities,
        init_options = {
          preferences = {
            includeInlayParameterNameHints = "all",
            includeInlayVariableTypeHints  = true,
          },
        },
        settings = {
          javascript = { suggest = { completeFunctionCalls = true } },
          typescript = { suggest = { completeFunctionCalls = true } },
        },
      },
    }

    -- ── Mason ─────────────────────────────────────────────────
    require("mason").setup({
      PATH = "skip",
      ui = {
        icons = {
          package_pending    = " ",
          package_installed  = " ",
          package_uninstalled = " ",
        },
      },
    })

    require("mason-tool-installer").setup({
      ensure_installed = {
        "lua-language-server",
        "gopls",
        "typescript-language-server",
        "stylua",
      },
    })

    require("mason-lspconfig").setup({
      ensure_installed = { "lua_ls", "gopls", "ts_ls" },
      handlers = {
        function(server_name)
          local server_opts = servers[server_name] or { capabilities = capabilities }
          require("lspconfig")[server_name].setup(server_opts)
        end,
      },
    })

    -- ── Disable LSP formatting (use conform instead) ──────────
    vim.lsp.handlers["textDocument/formatting"] = function() end

    -- ── Snippets ──────────────────────────────────────────────
    require("luasnip.loaders.from_vscode").lazy_load()
  end,
}
