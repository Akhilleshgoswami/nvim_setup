-- Bootstrap lazy.nvim and load every plugin spec under lua/plugins/.

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Paint the editor with our own theme before UI plugins load, so there is
-- never a flash of the default colorscheme.
pcall(vim.cmd.colorscheme, "umbra")

require("lazy").setup({
  spec = { { import = "plugins" } },
  defaults = { lazy = true },
  install = { colorscheme = { "umbra" } },
  checker = { enabled = true, notify = false, frequency = 86400 },
  change_detection = { enabled = true, notify = false },
  ui = {
    size = { width = 0.82, height = 0.8 },
    border = "rounded",
    backdrop = 100,
    title = " lazy ",
    icons = {
      cmd = "", config = "", event = "", ft = "", init = "",
      import = "", keys = "", lazy = "󰒲 ", loaded = "●", not_loaded = "○",
      plugin = "", runtime = "", require = "", source = "", start = "",
      task = "✓", list = { "●", "➜", "★", "‒" },
    },
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "matchit", "matchparen", "netrwPlugin", "tarPlugin",
        "tohtml", "tutor", "zipPlugin", "rplugin", "spellfile",
      },
    },
  },
})

-- Theme system: register `:Theme`/persistence, then restore the last-used
-- colorscheme (Umbra by default). Runs after setup so lazy can pull in the
-- saved theme's plugin on demand.
local theme = require("features.theme")
theme.setup()
theme.load_saved()

-- Fast, discoverable access to the plugin manager.
vim.keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy (plugins)" })
