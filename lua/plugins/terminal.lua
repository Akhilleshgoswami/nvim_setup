-- Integrated terminals: float / horizontal / vertical, multiple & persistent.

local ui = require("umbra.tokens")

return {
  "akinsho/toggleterm.nvim",
  version = "*",
  cmd = { "ToggleTerm", "TermExec" },
  keys = {
    { [[<C-\>]], "<cmd>ToggleTerm<cr>", mode = { "n", "t" }, desc = "Toggle terminal" },
    { "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
    { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Float terminal" },
    { "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Horizontal terminal" },
    { "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", desc = "Vertical terminal" },
    { "<leader>t2", "<cmd>2ToggleTerm<cr>", desc = "Terminal 2" },
    { "<leader>t3", "<cmd>3ToggleTerm<cr>", desc = "Terminal 3" },
    -- Task runner (auto-detects package manager / language, runs from root).
    { "<leader>tr", function() require("features.runner").run_project() end, desc = "Run project" },
    { "<leader>tR", function() require("features.runner").run_tests() end, desc = "Run tests" },
    { "<leader>tn", function() require("features.runner").npm_scripts() end, desc = "npm scripts" },
    { "<leader>tD", function() require("features.runner").docker() end, desc = "Docker menu" },
  },
  opts = {
    open_mapping = false,
    size = function(term)
      if term.direction == "horizontal" then
        return 15
      elseif term.direction == "vertical" then
        return math.floor(vim.o.columns * 0.4)
      end
      return 20
    end,
    shade_terminals = false,
    persist_size = true,
    persist_mode = true,
    close_on_exit = true,
    direction = "float",
    float_opts = {
      border = ui.border,
      width = function() return math.floor(vim.o.columns * ui.float.lg.width) end,
      height = function() return math.floor(vim.o.lines * ui.float.lg.height) end,
      winblend = ui.opacity.float,
      title_pos = ui.title.pos,
    },
    highlights = {
      Normal = { link = "Normal" },
      FloatBorder = { link = "FloatBorder" },
    },
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)

    vim.api.nvim_create_autocmd("TermOpen", {
      group = vim.api.nvim_create_augroup("umbra_toggleterm", { clear = true }),
      pattern = "term://*toggleterm#*",
      callback = function()
        local o = { buffer = 0, silent = true }
        vim.keymap.set("t", "<esc><esc>", [[<C-\><C-n>]], o)
        vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<cr>]], o)
        vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<cr>]], o)
        vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<cr>]], o)
        vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<cr>]], o)
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
      end,
    })
  end,
}
