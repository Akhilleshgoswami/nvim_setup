-- Syntax, indentation, and structural motions.
-- Pinned to the stable `master` API for reliability across parsers.

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    -- Load on VeryLazy so highlighting is ready before dashboard → Telescope.
    lazy = vim.fn.argc(-1) == 0,
    event = { "VeryLazy", "BufReadPost", "BufNewFile" },
    cmd = { "TSUpdate", "TSInstall", "TSInstallInfo" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash", "c", "comment", "css", "diff", "dockerfile", "git_config",
          "git_rebase", "gitcommit", "gitignore", "go", "gomod", "gosum",
          "gowork", "graphql", "html", "http", "javascript", "jsdoc", "json",
          "jsonc", "lua", "luadoc", "luap", "markdown", "markdown_inline",
          "prisma", "python", "query", "regex", "rust", "scss", "sql", "toml",
          "tsx", "typescript", "vim", "vimdoc", "yaml",
        },
        auto_install = true,
        sync_install = false,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
          disable = function(_, buf)
            return vim.b[buf].umbra_bigfile == true
          end,
        },
        indent = {
          enable = true,
          disable = { "yaml", "python" },
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            node_decremental = "<bs>",
            scope_incremental = false,
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = { query = "@function.outer", desc = "a function" },
              ["if"] = { query = "@function.inner", desc = "inner function" },
              ["ac"] = { query = "@class.outer", desc = "a class" },
              ["ic"] = { query = "@class.inner", desc = "inner class" },
              ["aa"] = { query = "@parameter.outer", desc = "a parameter" },
              ["ia"] = { query = "@parameter.inner", desc = "inner parameter" },
              ["ao"] = { query = "@conditional.outer", desc = "a conditional" },
              ["io"] = { query = "@conditional.inner", desc = "inner conditional" },
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]f"] = { query = "@function.outer", desc = "Next function" },
              ["]c"] = { query = "@class.outer", desc = "Next class" },
              ["]a"] = { query = "@parameter.inner", desc = "Next parameter" },
            },
            goto_previous_start = {
              ["[f"] = { query = "@function.outer", desc = "Prev function" },
              ["[c"] = { query = "@class.outer", desc = "Prev class" },
              ["[a"] = { query = "@parameter.inner", desc = "Prev parameter" },
            },
          },
          swap = {
            enable = true,
            swap_next = { ["<leader>cs"] = { query = "@parameter.inner", desc = "Swap next param" } },
            swap_previous = { ["<leader>cS"] = { query = "@parameter.inner", desc = "Swap prev param" } },
          },
        },
      })

      vim.treesitter.language.register("bash", "zsh")

      vim.g.umbra_treesitter_ready = true
      require("features.intelligence").ensure_treesitter()

      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("umbra_treesitter_reattach", { clear = true }),
        callback = function()
          vim.schedule(function()
            require("features.intelligence").ensure_treesitter()
          end)
        end,
      })
    end,
  },

  -- Auto close & rename JSX/HTML tags.
  {
    "windwp/nvim-ts-autotag",
    ft = {
      "html", "javascript", "typescript", "javascriptreact",
      "typescriptreact", "svelte", "vue", "tsx", "jsx", "xml", "markdown",
    },
    opts = {},
  },

  -- Context-aware commenting (embedded languages, JSX).
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
