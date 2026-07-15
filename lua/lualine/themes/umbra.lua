-- Lualine theme for Umbra, exposed here so lualine's `auto` theme resolves it
-- by name (`vim.g.colors_name == "umbra"`). When another colorscheme is active,
-- `auto` falls back to that theme's lualine palette — so the statusline always
-- matches the editor without us hard-coding a theme.
return require("themes.umbra").lualine()
