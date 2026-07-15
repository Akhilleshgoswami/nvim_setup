-- ╭──────────────────────────────────────────────────────────────╮
-- │  Umbra — a handcrafted Neovim environment                      │
-- │  entry point: leaders → options → lazy → keymaps/autocmds      │
-- ╰──────────────────────────────────────────────────────────────╯

-- Ensure this config dir is on the runtimepath (so colors/umbra.lua resolves
-- even when launched outside ~/.config/nvim).
vim.opt.rtp:prepend(vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h"))

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Providers we never use — skip the startup probes.
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0

require("core.options")
require("core.lazy")
require("core.autocmds")
require("core.keymaps")
