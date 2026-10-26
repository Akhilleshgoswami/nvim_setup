vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end
vim.o.termguicolors = true
vim.o.background = "dark"
pcall(function() require("lazy").load({ plugins = { "jb.nvim" } }) end)
require("jb").load()
vim.g.colors_name = "jetbrains-dark"
