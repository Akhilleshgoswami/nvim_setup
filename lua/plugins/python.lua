-- Python, LangChain, and Agentic AI development tooling:
--   • venv-selector: seamlessly pick virtualenvs (uv, poetry, conda, .venv) for LSP/DAP
--   • neotest + neotest-python: unit & agent tool test runner with DAP integration
--   • neogen: auto-generate Google-style docstrings (essential for LangChain @tool schemas)
--   • iron.nvim: interactive REPL for rapid AI prompt, chain, and embedding experimentation
--   • jupytext: transparent editing of Jupyter notebooks (.ipynb) as Python scripts

return {
  -- ── Python Virtualenv Switcher ───────────────────────────────────
  {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim",
      "mfussenegger/nvim-dap-python",
    },
    cmd = { "VenvSelect", "VenvSelectCached" },
    ft = "python",
    keys = {
      { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" },
      { "<leader>cV", "<cmd>VenvSelectCached<cr>", desc = "Retrieve VirtualEnv" },
    },
    opts = {
      options = {
        notify_user_on_venv_activation = true,
        cached_venv_automatic_activation = true,
        activate_venv_in_terminal = true,
        set_environment_variables = true,
      },
      search = {
        anaconda_envs = {
          command = "$FD 'bin/python$' ~/anaconda3/envs --no-ignore-vcs --full-path --color never",
          type = "anaconda",
        },
        anaconda_base = {
          command = "$FD '/python$' ~/anaconda3/bin --full-path --color never",
          type = "anaconda",
        },
      },
    },
  },

  -- ── Docstring generator for functions, classes, and LangChain @tool ─
  {
    "danymat/neogen",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = { "Neogen" },
    keys = {
      { "<leader>cg", function() require("neogen").generate() end, desc = "Generate docstring / annotations" },
    },
    opts = {
      snippet_engine = "luasnip",
      languages = {
        python = {
          template = {
            annotation_convention = "google",
          },
        },
      },
    },
  },

  -- ── Test runner (pytest, unittest) with DAP debugging ─────────
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
    },
    cmd = { "Neotest" },
    keys = {
      { "<leader>Tt", function() require("neotest").run.run() end, desc = "Test: run nearest" },
      { "<leader>Tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Test: run current file" },
      { "<leader>Ts", function() require("neotest").summary.toggle() end, desc = "Test: toggle summary" },
      { "<leader>To", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Test: show output" },
      { "<leader>TO", function() require("neotest").output_panel.toggle() end, desc = "Test: toggle output panel" },
      { "<leader>Td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Test: debug nearest" },
      { "<leader>TS", function() require("neotest").run.stop() end, desc = "Test: stop" },
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
            runner = "pytest",
          }),
        },
        status = { virtual_text = true },
        output = { open_on_run = true },
      })
    end,
  },

  -- ── Interactive REPL for rapid AI & prompt experimentation ─────
  {
    "Vigemus/iron.nvim",
    cmd = { "IronRepl", "IronRestart", "IronFocus", "IronHide" },
    keys = {
      { "<leader>rr", "<cmd>IronRepl<cr>", desc = "Toggle REPL" },
      { "<leader>rs", "<cmd>IronRestart<cr>", desc = "Restart REPL" },
      { "<leader>rf", "<cmd>IronFocus<cr>", desc = "Focus REPL" },
      { "<leader>rh", "<cmd>IronHide<cr>", desc = "Hide REPL" },
      { "<leader>rc", function() require("iron.core").send(nil, string.char(13)) end, desc = "Send to REPL" },
    },
    config = function()
      local iron = require("iron.core")
      iron.setup({
        config = {
          scratch_repl = true,
          repl_definition = {
            python = {
              command = function()
                local venv = vim.env.VIRTUAL_ENV or vim.env.CONDA_PREFIX
                if venv and vim.fn.executable(venv .. "/bin/ipython") == 1 then
                  return { venv .. "/bin/ipython", "--no-autoindent" }
                elseif venv and vim.fn.executable(venv .. "/bin/python3") == 1 then
                  return { venv .. "/bin/python3" }
                elseif venv and vim.fn.executable(venv .. "/bin/python") == 1 then
                  return { venv .. "/bin/python" }
                elseif vim.fn.executable("ipython") == 1 then
                  return { "ipython", "--no-autoindent" }
                end
                return { "python3" }
              end,
              format = require("iron.fts.common").bracketed_paste,
            },
          },
          repl_open_cmd = require("iron.view").split.vertical.botright(0.40),
        },
        keymaps = {
          send_motion = "<leader>rc",
          visual_send = "<leader>rc",
          send_file = "<leader>rF",
          send_line = "<leader>rl",
          send_until_cursor = "<leader>ru",
          send_mark = "<leader>rm",
          mark_motion = "<leader>rmc",
          mark_visual = "<leader>rmc",
          remove_mark = "<leader>rmd",
          cr = "<leader>r<cr>",
          interrupt = "<leader>r<space>",
          exit = "<leader>rq",
          clear = "<leader>rx",
        },
        highlight = {
          italic = true,
        },
        ignore_blank_lines = true,
      })
    end,
  },

  -- ── Jupyter Notebook transparent editing (.ipynb as .py) ───────
  {
    "goerz/jupytext.vim",
    ft = { "ipynb" },
    init = function()
      vim.g.jupytext_fmt = "py:percent"
      vim.g.jupytext_style = "percent"
    end,
  },
}
