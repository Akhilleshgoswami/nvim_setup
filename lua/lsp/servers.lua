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

---Intelligently auto-detect Python interpreter for the current workspace.
---Checks:
---  1. Local virtual environments in workspace root (.venv, venv, .conda, env)
---  2. Explicitly activated virtualenv or non-base conda env from shell/terminal
---  3. Anaconda / Conda environments matching project directory name
---  4. Cached virtual environment chosen via venv-selector
---  5. Base conda env or system python3 as fallback
---@param root_dir string|nil
---@return string
local function find_python_path(root_dir)
  root_dir = root_dir or vim.fn.getcwd()

  local function is_exec(path)
    if path and vim.fn.executable(path) == 1 then
      return path
    end
    return nil
  end

  -- 1. Check local virtualenvs in workspace root (.venv, venv, .conda, env)
  local local_venv = is_exec(root_dir .. "/.venv/bin/python")
    or is_exec(root_dir .. "/venv/bin/python")
    or is_exec(root_dir .. "/.conda/bin/python")
    or is_exec(root_dir .. "/env/bin/python")
  if local_venv then
    return local_venv
  end

  -- 2. Check if a project-specific / non-base VIRTUAL_ENV or CONDA_PREFIX is active in the shell
  if vim.env.VIRTUAL_ENV then
    local venv_py = is_exec(vim.env.VIRTUAL_ENV .. "/bin/python")
    if venv_py then return venv_py end
  end
  if vim.env.CONDA_PREFIX and vim.env.CONDA_DEFAULT_ENV ~= "base"
    and not vim.env.CONDA_PREFIX:match("/anaconda%d*$")
    and not vim.env.CONDA_PREFIX:match("/miniconda%d*$") then
    local conda_py = is_exec(vim.env.CONDA_PREFIX .. "/bin/python")
    if conda_py then return conda_py end
  end

  -- 3. Check Anaconda / Conda envs matching current project directory name
  local proj_name = vim.fn.fnamemodify(root_dir, ":t")
  if proj_name and proj_name ~= "" then
    local named_conda = is_exec(vim.fn.expand("~/anaconda3/envs/" .. proj_name .. "/bin/python"))
      or is_exec(vim.fn.expand("~/.conda/envs/" .. proj_name .. "/bin/python"))
      or is_exec(vim.fn.expand("~/miniconda3/envs/" .. proj_name .. "/bin/python"))
    if named_conda then
      return named_conda
    end
  end

  -- 4. Check cached venv from venv-selector if available
  local cache_path = vim.fn.expand("~/.cache/venv-selector/venvs2.json")
  if vim.fn.filereadable(cache_path) == 1 then
    local ok, lines = pcall(vim.fn.readfile, cache_path)
    if ok and lines then
      local ok_json, data = pcall(vim.json.decode, table.concat(lines, ""))
      if ok_json and type(data) == "table" and data[root_dir] then
        local cached_py = is_exec(data[root_dir])
        if cached_py then return cached_py end
      end
    end
  end

  -- 5. Fallback: Base conda environment or system python3
  if vim.env.CONDA_PREFIX then
    local conda_base_py = is_exec(vim.env.CONDA_PREFIX .. "/bin/python")
    if conda_base_py then return conda_base_py end
  end

  return is_exec("python3") or is_exec("python") or "python3"
end

return {
  lua_ls = {
    settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        codeLens = { enable = true },
        completion = { callSnippet = "Replace" },
        diagnostics = { globals = { "vim" } },
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
    before_init = function(_, config)
      local current_py = config.settings
        and config.settings.python
        and config.settings.python.pythonPath

      if not current_py or current_py == "" or current_py == "python" or current_py == "python3" then
        local detected_py = find_python_path(config.root_dir)
        if detected_py then
          config.settings = config.settings or {}
          config.settings.python = config.settings.python or {}
          config.settings.python.pythonPath = detected_py
          local venv_dir = vim.fn.fnamemodify(detected_py, ":h:h")
          config.settings.python.venv = vim.fn.fnamemodify(venv_dir, ":t")
          config.settings.python.venvPath = vim.fn.fnamemodify(venv_dir, ":h")
        end
      end
    end,
    settings = {
      python = {},
      basedpyright = {
        analysis = {
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = "openFilesOnly",
          autoImportCompletions = true,
          typeCheckingMode = "basic",
          inlayHints = {
            variableTypes = false,
            callArgumentNames = false,
            functionReturnTypes = false,
            genericTypes = false,
          },
          diagnosticSeverityOverrides = {
            reportMissingTypeStubs = "none",
            reportUnknownMemberType = "none",
            reportUnknownVariableType = "none",
            reportUnknownArgumentType = "none",
            reportUnknownParameterType = "none",
            reportMissingParameterType = "none",
            reportUnusedCallResult = "none",
            reportArgumentType = "none",
            reportAssignmentType = "none",
            reportCallIssue = "none",
            reportAttributeAccessIssue = "none",
          },
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
