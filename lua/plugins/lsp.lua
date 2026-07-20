-- Language intelligence: servers, formatting, folding, progress.

local ui = require("umbra.tokens")

return {
  -- ── Mason (installer) ──────────────────────────────────────────
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall" },
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = ui.border,
        width = ui.float.lg.width,
        height = ui.float.lg.height,
        icons = { package_installed = "●", package_pending = "◍", package_uninstalled = "○" },
      },
    },
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    cmd = { "MasonToolsInstall", "MasonToolsUpdate" },
    event = "VeryLazy",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      run_on_start = true,
      start_delay = 3000,
      ensure_installed = {
        -- formatters / linters
        "stylua", "prettier", "prettierd", "goimports", "gofumpt",
        "shfmt", "sql-formatter", "hadolint",
        -- debug adapters (installed here via one coordinated installer to
        -- avoid mason "already installing" races).
        "js-debug-adapter", "delve", "debugpy",
      },
    },
  },

  -- ── LSP configuration ──────────────────────────────────────────
  {
    "neovim/nvim-lspconfig",
    -- Must be ready before Telescope can open a file from the dashboard.
    lazy = false,
    dependencies = {
      { "williamboman/mason.nvim", opts = {} },
      "williamboman/mason-lspconfig.nvim",
      "b0o/schemastore.nvim",
      "saghen/blink.cmp",
      { "folke/lazydev.nvim", ft = "lua", opts = {
        library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } },
      } },
      { "smjonas/inc-rename.nvim", opts = {} },
    },
    config = function()
      require("lsp.attach").setup()

      local servers = require("lsp.servers")

      -- Capabilities: base + folding (ufo) + blink completion.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }
      local ok_blink, blink = pcall(require, "blink.cmp")
      if ok_blink then
        capabilities = blink.get_lsp_capabilities(capabilities)
      end

      vim.lsp.config("*", { capabilities = capabilities })
      for name, cfg in pairs(servers) do
        vim.lsp.config(name, cfg)
      end

      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers),
        -- vtsls replaces ts_ls; glint is Ember-only and not in our stack.
        automatic_enable = { exclude = { "ts_ls", "glint" } },
      })

      -- Belt-and-suspenders: never spawn optional servers we don't configure.
      pcall(vim.lsp.enable, "glint", false)

      vim.schedule(function()
        require("features.intelligence").ensure_buffers()
      end)

      vim.g.umbra_lsp_ready = true
    end,
  },

  -- ── Formatting ─────────────────────────────────────────────────
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      { "<leader>cf", function() require("conform").format({ async = true, lsp_format = "fallback" }) end, mode = { "n", "v" }, desc = "Format buffer" },
      { "<leader>uf", function() vim.g.autoformat = not vim.g.autoformat vim.notify((vim.g.autoformat and "Enabled" or "Disabled") .. " format on save", vim.log.levels.INFO, { title = "Conform" }) end, desc = "Toggle format on save" },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        jsonc = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        scss = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        graphql = { "prettierd", "prettier", stop_after_first = true },
        go = { "goimports", "gofumpt" },
        rust = { "rustfmt" },
        python = { "ruff_format", "ruff_organize_imports" },
        sql = { "sql_formatter" },
        sh = { "shfmt" },
        prisma = { lsp_format = "prefer" },
      },
      format_on_save = function(bufnr)
        if vim.g.autoformat == false or vim.b[bufnr].autoformat == false then
          return
        end
        return { timeout_ms = 1000, lsp_format = "fallback" }
      end,
    },
  },

  -- ── LSP progress ───────────────────────────────────────────────
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      progress = {
        display = {
          done_icon = "✓",
          progress_icon = { pattern = "dots", period = 1 },
        },
      },
      notification = {
        window = { winblend = 0, border = "none", relative = "editor", align = "bottom" },
      },
    },
  },

  -- ── Folding (LSP + treesitter powered) ─────────────────────────
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "zR", function() require("ufo").openAllFolds() end, desc = "Open all folds" },
      { "zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds" },
      { "zK", function() require("ufo").peekFoldedLinesUnderCursor() end, desc = "Peek fold" },
    },
    opts = {
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
      fold_virt_text_handler = function(virt_text, lnum, end_lnum, width, truncate)
        local suffix = ("  %d lines"):format(end_lnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local target = width - sufWidth
        local cur = 0
        local result = {}
        for _, chunk in ipairs(virt_text) do
          local text = chunk[1]
          local w = vim.fn.strdisplaywidth(text)
          if target > cur + w then
            table.insert(result, chunk)
          else
            text = truncate(text, target - cur)
            table.insert(result, { text, chunk[2] })
            break
          end
          cur = cur + w
        end
        table.insert(result, { suffix, "Comment" })
        return result
      end,
    },
  },

  -- ── Premium Rust experience ────────────────────────────────────
  {
    "mrcjkb/rustaceanvim",
    version = "^6",
    lazy = false,
    ft = { "rust" },
    init = function()
      vim.g.rustaceanvim = {
        server = {
          on_attach = function(client, bufnr)
            require("lsp.attach").on_attach(client, bufnr)
          end,
          default_settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              checkOnSave = true,
              procMacro = { enable = true },
              inlayHints = { lifetimeElisionHints = { enable = "always" } },
            },
          },
        },
      }
    end,
  },
}
