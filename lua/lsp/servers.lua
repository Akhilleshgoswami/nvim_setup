-- Per-language server settings. Capabilities are applied globally via the
-- "*" config in plugins/lsp.lua, so entries here only carry what's specific.

local ts_inlay = {
  includeInlayParameterNameHints = "literals",
  includeInlayParameterNameHintsWhenArgumentMatchesName = false,
  includeInlayFunctionParameterTypeHints = true,
  includeInlayVariableTypeHints = false,
  includeInlayPropertyDeclarationTypeHints = true,
  includeInlayFunctionLikeReturnTypeHints = true,
  includeInlayEnumMemberValueHints = true,
}

return {
  lua_ls = {
    settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        codeLens = { enable = true },
        completion = { callSnippet = "Replace" },
        diagnostics = { globals = { "vim", "Snacks" } },
        hint = { enable = true, setType = true },
        format = { enable = false },
      },
    },
  },

  vtsls = {
    settings = {
      complete_function_calls = true,
      vtsls = {
        enableMoveToFileCodeAction = true,
        autoUseWorkspaceTsdk = true,
        experimental = { completion = { enableServerSideFuzzyMatch = true } },
      },
      typescript = {
        updateImportsOnFileMove = { enabled = "always" },
        suggest = { completeFunctionCalls = true },
        preferences = { importModuleSpecifier = "shortest" },
        inlayHints = ts_inlay,
      },
      javascript = {
        updateImportsOnFileMove = { enabled = "always" },
        inlayHints = ts_inlay,
      },
    },
  },

  eslint = {
    settings = { workingDirectories = { mode = "auto" } },
  },

  gopls = {
    settings = {
      gopls = {
        gofumpt = true,
        usePlaceholders = true,
        completeUnimported = true,
        staticcheck = true,
        analyses = { unusedparams = true, unusedwrite = true, nilness = true },
        hints = {
          assignVariableTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
      },
    },
  },

  basedpyright = {
    settings = {
      basedpyright = {
        analysis = {
          typeCheckingMode = "standard",
          autoImportCompletions = true,
          diagnosticMode = "openFilesOnly",
        },
      },
    },
  },

  ruff = {
    -- Let basedpyright own hover; ruff handles lint + import sorting.
    on_attach = function(client)
      client.server_capabilities.hoverProvider = false
    end,
  },

  tailwindcss = {
    settings = {
      tailwindCSS = {
        experimental = {
          classRegex = {
            { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
            { "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
            { "cn\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
          },
        },
      },
    },
  },

  jsonls = {
    settings = {
      json = {
        validate = { enable = true },
        schemas = require("schemastore").json.schemas(),
      },
    },
  },

  yamlls = {
    settings = {
      yaml = {
        keyOrdering = false,
        schemaStore = { enable = false, url = "" },
        schemas = require("schemastore").yaml.schemas(),
      },
    },
  },

  prismals = {},
  html = {},
  cssls = {},
  emmet_language_server = {},
  dockerls = {},
  docker_compose_language_service = {},
  bashls = {},
  marksman = {},
  sqlls = {},
  graphql = {},
}
