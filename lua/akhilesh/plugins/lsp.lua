return {
  "neovim/nvim-lspconfig",

  dependencies = {
    -- Mason
    { "williamboman/mason.nvim", config = true },
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",

    -- UI
    { "j-hui/fidget.nvim", opts = {} },
    { "folke/neodev.nvim", opts = {} },

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

    -- Diagnostics
    vim.diagnostic.config({
      virtual_text = true,
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
    })

    -- Fix position_encoding warning
    local orig_util = vim.lsp.util.make_position_params

    vim.lsp.util.make_position_params = function(window, position_encoding)
      position_encoding = position_encoding or "utf-16"
      return orig_util(window, position_encoding)
    end

    -- LSP keymaps
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp_attach_config", { clear = true }),

      callback = function(event)
        local opts = { buffer = event.buf }

        local map = function(keys, func, desc)
          if desc then
            desc = "LSP: " .. desc
          end

          vim.keymap.set(
            "n",
            keys,
            func,
            vim.tbl_extend("force", opts, { desc = desc })
          )
        end

        map("gd", require("telescope.builtin").lsp_definitions, "Goto Definition")
        map("gr", require("telescope.builtin").lsp_references, "Goto References")
        map("gI", require("telescope.builtin").lsp_implementations, "Goto Implementation")

        map(
          "<leader>D",
          require("telescope.builtin").lsp_type_definitions,
          "Type Definition"
        )

        map(
          "<leader>ds",
          require("telescope.builtin").lsp_document_symbols,
          "Document Symbols"
        )

        map(
          "<leader>ws",
          require("telescope.builtin").lsp_dynamic_workspace_symbols,
          "Workspace Symbols"
        )

        map("<leader>rn", vim.lsp.buf.rename, "Rename")
        map("K", vim.lsp.buf.hover, "Hover")
        map("gD", vim.lsp.buf.declaration, "Goto Declaration")

        local client = vim.lsp.get_client_by_id(event.data.client_id)

        -- Highlight references
        if client and client.server_capabilities.documentHighlightProvider then
          local group = vim.api.nvim_create_augroup(
            "lsp_document_highlight",
            { clear = false }
          )

          vim.api.nvim_create_autocmd(
            { "CursorHold", "CursorHoldI" },
            {
              buffer = event.buf,
              group = group,
              callback = vim.lsp.buf.document_highlight,
            }
          )

          vim.api.nvim_create_autocmd(
            { "CursorMoved", "CursorMovedI" },
            {
              buffer = event.buf,
              group = group,
              callback = vim.lsp.buf.clear_references,
            }
          )
        end

        -- Inlay hints
        if client and client.server_capabilities.inlayHintProvider then
          map("<leader>th", function()
            vim.lsp.inlay_hint.enable(
              not vim.lsp.inlay_hint.is_enabled()
            )
          end, "Toggle Hints")
        end
      end,
    })

    -- Capabilities
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    capabilities = vim.tbl_deep_extend(
      "force",
      capabilities,
      require("cmp_nvim_lsp").default_capabilities()
    )

    -- Servers
    local servers = {
      lua_ls = {
        capabilities = capabilities,

        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
          },
        },
      },

      gopls = {
        capabilities = capabilities,

        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
              unreachable = true,
            },

            staticcheck = true,
          },
        },
      },

      tsserver = {
        capabilities = capabilities,

        init_options = {
          preferences = {
            includeInlayParameterNameHints = "all",
            includeInlayVariableTypeHints = true,
          },
        },

        settings = {
          javascript = {
            suggest = {
              completeFunctionCalls = true,
            },
          },

          typescript = {
            suggest = {
              completeFunctionCalls = true,
            },
          },
        },
      },
    }

    -- Mason
    require("mason").setup({
      PATH = "skip",

      ui = {
        icons = {
          package_pending = " ",
          package_installed = " ",
          package_uninstalled = " ",
        },
      },
    })

    -- Install automatically
    require("mason-tool-installer").setup({
      ensure_installed = {
        "lua-language-server",
        "gopls",
        "typescript-language-server",
        "stylua",
      },
    })

    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "gopls",
        "tsserver",
      },

      handlers = {
        function(server_name)
          local server_opts = servers[server_name] or {}

          require("lspconfig")[server_name].setup(server_opts)
        end,
      },
    })

    -- Disable formatting
    vim.lsp.handlers["textDocument/formatting"] = function() end

    -- Snippets
    require("luasnip.loaders.from_vscode").lazy_load()
  end,
}
