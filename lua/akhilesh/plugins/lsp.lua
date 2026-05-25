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
            package_installed = " ",
            package_pending = " ",
            package_uninstalled = " ",
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
            done_icon = " ",
            progress_icon = {
              pattern = "dots",
            },
          },
        },

        notification = {
          window = {
            border = "rounded",
            winblend = 0,
          },
        },
      },
    },

    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {},
    },

    -- ========================================================
    -- CMP
    -- ========================================================

    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },

    -- ========================================================
    -- SNIPPETS
    -- ========================================================

    { "L3MON4D3/LuaSnip" },
    { "saadparwaiz1/cmp_luasnip" },
    { "rafamadriz/friendly-snippets" },

    -- ========================================================
    -- ICONS
    -- ========================================================

    { "onsails/lspkind.nvim" },
  },

  config = function()

    -- ========================================================
    -- DIAGNOSTICS UI
    -- ========================================================

    vim.diagnostic.config({

      underline = true,
      update_in_insert = false,
      severity_sort = true,
      virtual_text = false,

      float = {
        border = "rounded",
        source = "if_many",
        header = "",
        prefix = "",
      },

      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.INFO] = " ",
          [vim.diagnostic.severity.HINT] = " ",
        },
      },
    })

    -- ========================================================
    -- BORDER UI
    -- ========================================================

    local border = "rounded"

    vim.lsp.handlers["textDocument/hover"] =
      vim.lsp.with(vim.lsp.handlers.hover, {
        border = border,
      })

    vim.lsp.handlers["textDocument/signatureHelp"] =
      vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = border,
      })

    -- ========================================================
    -- FIX UTF-16 WARNING
    -- ========================================================

    local orig_util = vim.lsp.util.make_position_params

    vim.lsp.util.make_position_params = function(window, position_encoding)
      position_encoding = position_encoding or "utf-16"
      return orig_util(window, position_encoding)
    end

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

      window = {
        completion = cmp.config.window.bordered({
          border = border,
          winhighlight = "Normal:Pmenu,CursorLine:PmenuSel,Search:None",
        }),

        documentation = cmp.config.window.bordered({
          border = border,
        }),
      },

      formatting = {
        format = lspkind.cmp_format({
          mode = "symbol_text",

          maxwidth = 50,

          symbol_map = {
            Copilot = " ",
          },
        }),
      },

      mapping = cmp.mapping.preset.insert({

        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-j>"] = cmp.mapping.select_next_item(),

        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),

        ["<C-Space>"] = cmp.mapping.complete(),

        ["<CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        }),

        ["<Tab>"] = cmp.mapping(function(fallback)

          if cmp.visible() then
            cmp.select_next_item()

          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()

          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)

          if cmp.visible() then
            cmp.select_prev_item()

          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)

          else
            fallback()
          end
        end, { "i", "s" }),
      }),

      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      }),
    })

    -- ========================================================
    -- CAPABILITIES
    -- ========================================================

    local capabilities = vim.tbl_deep_extend(
      "force",

      vim.lsp.protocol.make_client_capabilities(),

      require("cmp_nvim_lsp").default_capabilities(),

      {
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      }
    )

    -- ========================================================
    -- LSP ATTACH
    -- ========================================================

    vim.api.nvim_create_autocmd("LspAttach", {

      group = vim.api.nvim_create_augroup(
        "akhilesh-lsp-attach",
        { clear = true }
      ),

      callback = function(event)

        local map = function(keys, func, desc)
          vim.keymap.set(
            "n",
            keys,
            func,
            {
              buffer = event.buf,
              desc = "LSP: " .. desc,
            }
          )
        end

        -- ====================================================
        -- GOTO
        -- ====================================================

        map("gd", function()
          Snacks.picker.lsp_definitions()
        end, "Goto Definition")

        map("gr", function()
          Snacks.picker.lsp_references()
        end, "Goto References")

        map("gI", function()
          Snacks.picker.lsp_implementations()
        end, "Goto Implementation")

        map("gD", function()
          Snacks.picker.lsp_declarations()
        end, "Goto Declaration")

        map("gy", function()
          Snacks.picker.lsp_type_definitions()
        end, "Type Definitions")

        -- ====================================================
        -- ACTIONS
        -- ====================================================

        map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
        map("<leader>rn", vim.lsp.buf.rename, "Rename")
        map("K", vim.lsp.buf.hover, "Hover")

        map("<leader>ds", function()
          Snacks.picker.lsp_symbols()
        end, "Document Symbols")

        map("<leader>ws", function()
          Snacks.picker.lsp_workspace_symbols()
        end, "Workspace Symbols")

        local client = vim.lsp.get_client_by_id(event.data.client_id)

        -- ====================================================
        -- DOCUMENT HIGHLIGHT
        -- ====================================================

        if client and client.server_capabilities.documentHighlightProvider then

          local group = vim.api.nvim_create_augroup(
            "lsp-highlight",
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

        -- ====================================================
        -- INLAY HINTS
        -- ====================================================

        if client and client.server_capabilities.inlayHintProvider then

          map("<leader>uh", function()
            vim.lsp.inlay_hint.enable(
              not vim.lsp.inlay_hint.is_enabled()
            )
          end, "Toggle Inlay Hints")
        end
      end,
    })

    -- ========================================================
    -- SERVERS
    -- ========================================================

    local servers = {

      -- ======================================================
      -- LUA
      -- ======================================================

      lua_ls = {

        capabilities = capabilities,

        settings = {

          Lua = {

            runtime = {
              version = "LuaJIT",
            },

            diagnostics = {
              globals = {
                "vim",
                "Snacks",
              },
            },

            workspace = {

              checkThirdParty = false,

              library = {
                vim.env.VIMRUNTIME,
                "${3rd}/luv/library",
              },
            },

            completion = {
              callSnippet = "Replace",
            },

            telemetry = {
              enable = false,
            },
          },
        },
      },

      -- ======================================================
      -- GO
      -- ======================================================

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

      -- ======================================================
      -- TYPESCRIPT
      -- ======================================================

      ts_ls = {

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

    -- ========================================================
    -- MASON
    -- ========================================================

    require("mason").setup()

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
        "ts_ls",
      },

      handlers = {

        function(server_name)

          local opts =
            servers[server_name]
            or {
              capabilities = capabilities,
            }

          require("lspconfig")[server_name].setup(opts)
        end,
      },
    })

    -- ========================================================
    -- DISABLE FORMATTING
    -- ========================================================

    vim.lsp.handlers["textDocument/formatting"] =
      function() end
  end,
}
