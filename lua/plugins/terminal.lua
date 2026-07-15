-- Integrated terminals: float / horizontal / vertical, multiple & persistent.

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
      border = "rounded",
      width = function() return math.floor(vim.o.columns * 0.85) end,
      height = function() return math.floor(vim.o.lines * 0.8) end,
      winblend = 0,
      title_pos = "center",
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
