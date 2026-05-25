-- ============================================================
--  lua/akhilesh/plugins/nvim-lint.lua
--  Modern + Theme Adaptive + Clean Lint UI
-- ============================================================

return {
  "mfussenegger/nvim-lint",

  optional = true,

  event = {
    "BufReadPre",
    "BufNewFile",
  },

  opts = function()

    -- ========================================================
    -- THEME COLORS
    -- ========================================================

    local function hl(name, attr)
      local ok, h = pcall(vim.api.nvim_get_hl, 0, {
        name = name,
        link = false,
      })

      if not ok or not h[attr] then
        return nil
      end

      return string.format("#%06x", h[attr])
    end

    local colors = {
      bg      = hl("Normal", "bg") or "#111111",
      fg      = hl("Normal", "fg") or "#cdd6f4",

      red     = hl("DiagnosticError", "fg") or "#f7768e",
      yellow  = hl("DiagnosticWarn", "fg") or "#e0af68",
      blue    = hl("DiagnosticInfo", "fg") or "#7aa2f7",
      cyan    = hl("DiagnosticHint", "fg") or "#7dcfff",

      comment = hl("Comment", "fg") or "#565f89",
    }

    -- ========================================================
    -- HIGHLIGHTS
    -- ========================================================

    local function set_hl()
      local set = vim.api.nvim_set_hl

      set(0, "DiagnosticError", {
        fg = colors.red,
      })

      set(0, "DiagnosticWarn", {
        fg = colors.yellow,
      })

      set(0, "DiagnosticInfo", {
        fg = colors.blue,
      })

      set(0, "DiagnosticHint", {
        fg = colors.cyan,
      })

      set(0, "DiagnosticUnderlineError", {
        undercurl = true,
        sp = colors.red,
      })

      set(0, "DiagnosticUnderlineWarn", {
        undercurl = true,
        sp = colors.yellow,
      })

      set(0, "DiagnosticUnderlineInfo", {
        undercurl = true,
        sp = colors.blue,
      })

      set(0, "DiagnosticUnderlineHint", {
        undercurl = true,
        sp = colors.cyan,
      })

      set(0, "FloatBorder", {
        fg = colors.comment,
        bg = colors.bg,
      })
    end

    set_hl()

    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.schedule(set_hl)
      end,
    })

    -- ========================================================
    -- RETURN CONFIG
    -- ========================================================

    return {

      linters_by_ft = {

        -- ====================================================
        -- WEB
        -- ====================================================

        javascript = { "eslint_d" },
        typescript = { "eslint_d" },

        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },

        vue = { "eslint_d" },

        -- ====================================================
        -- LUA
        -- ====================================================

        lua = { "luacheck" },

        -- ====================================================
        -- GO
        -- ====================================================

        go = { "golangcilint" },

        -- ====================================================
        -- SHELL
        -- ====================================================

        sh = { "shellcheck" },
        bash = { "shellcheck" },

        -- ====================================================
        -- PYTHON
        -- ====================================================

        python = { "ruff" },

        -- ====================================================
        -- YAML / JSON
        -- ====================================================

        yaml = { "yamllint" },
        json = { "jsonlint" },

        -- ====================================================
        -- CMAKE
        -- ====================================================

        cmake = { "cmakelint" },
      },
    }
  end,

  config = function(_, opts)

    local lint = require("lint")

    lint.linters_by_ft = opts.linters_by_ft

    -- ========================================================
    -- LINT AUTOCMDS
    -- ========================================================

    vim.api.nvim_create_autocmd({
      "BufEnter",
      "BufWritePost",
      "InsertLeave",
    }, {
      callback = function()
        lint.try_lint()
      end,
    })

    -- ========================================================
    -- MANUAL LINT KEYMAP
    -- ========================================================

    vim.keymap.set(
      "n",
      "<leader>cl",
      function()
        lint.try_lint()
        vim.notify(
          "󰦨 Lint completed",
          vim.log.levels.INFO
        )
      end,
      { desc = "Run lint" }
    )

    -- ========================================================
    -- FLOAT DIAGNOSTICS
    -- ========================================================

    vim.diagnostic.config({

      virtual_text = false,

      underline = true,

      severity_sort = true,

      update_in_insert = false,

      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "●",
          [vim.diagnostic.severity.WARN]  = "●",
          [vim.diagnostic.severity.INFO]  = "●",
          [vim.diagnostic.severity.HINT]  = "●",
        },
      },

      float = {
        border = "rounded",
        source = "if_many",
        header = "",
        prefix = "",
      },
    })

    -- ========================================================
    -- AUTO FLOAT ON CURSOR HOLD
    -- ========================================================

    vim.api.nvim_create_autocmd("CursorHold", {
      callback = function()
        vim.diagnostic.open_float(nil, {
          focusable = false,
          close_events = {
            "BufLeave",
            "CursorMoved",
            "InsertEnter",
            "FocusLost",
          },

          border = "rounded",
          source = "if_many",
          prefix = "",
          scope = "cursor",
        })
      end,
    })
  end,
}
