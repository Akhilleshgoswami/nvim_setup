-- Enables `:colorscheme umbra`.
-- Optional global config (set before colorscheme loads):
--   vim.g.umbra_config = { transparent = true, italic_comments = true }
if vim.g.umbra_config then
  require("themes.umbra").setup(vim.g.umbra_config)
end
require("themes.umbra").apply()
