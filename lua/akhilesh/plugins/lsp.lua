return {
  "neovim/nvim-lspconfig",

  dependencies = {
    -- ========================================================
    -- MASON
    -- ========================================================
    {
      "williamboman/mason.nvim",
      opts = {
        ui = {
          border = "rounded",
          icons = {
            package_installed = "󰄳",
            package_pending = "󰦬",
            package_uninstalled = "󰚌",
          },
        },
      },
    },

    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",

    -- ========================================================
    -- LSP UI
    -- ========================================================
    {
      "j-hui/fidget.nvim",
      opts = {
        progress = {
          display = {
            done_icon = "󰄳",
            progress_icon = { pattern = "dots" },
          },
        },
        notification = {
          window = {
            border = "rounded",
          },
        },
      },
    },

    { "folke/lazydev.nvim", ft = "lua", opts = {} },

    -- ========================================================
    -- CMP
    -- ========================================================
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "L3MON4D3/LuaSnip" },
    { "saadparwaiz1/cmp_luasnip" },
    { "rafamadriz/friendly-snippets" },
    { "onsails/lspkind.nvim" },
  },

  config = function()
    -- ========================================================
    -- DIAGNOSTICS
    -- ========================================================
    vim.diagnostic.config({
      underline = true,

      virtual_text = {
        prefix = "●",
        spacing = 4,
      },

      signs = true,
      update_in_insert = true,
      severity_sort = true,

      float = {
        border = "rounded",
        source = "always",
      },
    })

    -- ========================================================
    -- CMP
    -- ========================================================
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")

    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },

      completion = {
        completeopt = "menu,menuone,noinsert,noselect",
      },

      formatting = {
        format = lspkind.cmp_format({
          mode = "symbol_text",
          maxwidth = 50,
        }),
      },

      mapping = cmp.mapping.preset.insert({
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
      }),

      sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      },
    })

    -- ========================================================
    -- CAPABILITIES
    -- ========================================================
    local capabilities = vim.tbl_deep_extend(
      "force",
      vim.lsp.protocol.make_client_capabilities(),
      require("cmp_nvim_lsp").default_capabilities()
    )

    -- ========================================================
    -- SERVERS
    -- ========================================================
    local servers = {
      lua_ls = {
        capabilities = capabilities,

        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim", "Snacks" },
            },
          },
        },
      },

      gopls = {
        capabilities = capabilities,
      },

      ts_ls = {
        capabilities = capabilities,

        settings = {
          javascript = {
            validate = true,
          },

          typescript = {
            validate = true,
          },
        },
      },

      eslint = {
        capabilities = capabilities,
      },
    }

    -- ========================================================
    -- LSP ATTACH
    -- ========================================================
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, {
            buffer = event.buf,
            noremap = true,
            silent = true,
            desc = desc,
          })
        end

        -- ====================================================
        -- NAVIGATION
        -- ====================================================
        map("gd", vim.lsp.buf.definition, "Go to Definition")
        map("gr", vim.lsp.buf.references, "Go to References")
        map("gI", vim.lsp.buf.implementation, "Go to Implementation")
        map("gy", vim.lsp.buf.type_definition, "Go to Type Definition")

        -- ====================================================
        -- DIAGNOSTICS
        -- ====================================================
        map("<leader>de", vim.diagnostic.open_float, "Show Diagnostics")
        map("[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
        map("]d", vim.diagnostic.goto_next, "Next Diagnostic")
        map("<leader>q", vim.diagnostic.setloclist, "Diagnostics List")

        -- ====================================================
        -- LSP ACTIONS
        -- ====================================================
        map("K", vim.lsp.buf.hover, "Hover")
        map("<leader>rn", vim.lsp.buf.rename, "Rename")
        map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
      end,
    })

    -- ========================================================
    -- MASON
    -- ========================================================
    require("mason").setup()

    require("mason-tool-installer").setup({
      ensure_installed = {
        "lua-language-server",
        "gopls",
        "typescript-language-server",
        "eslint-lsp",
        "stylua",
      },
    })

    -- ========================================================
    -- LSPCONFIG
    -- ========================================================
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "gopls",
        "ts_ls",
        "eslint",
      },

      handlers = {
        function(server_name)
          local opts = servers[server_name] or {
            capabilities = capabilities,
          }

          require("lspconfig")[server_name].setup(opts)
        end,
      },
    })
  end,
}

