-- ╭──────────────────────────────────────────────────────────────╮
-- │  WezTerm — modular config, theme-synced with Neovim (Umbra)  │
-- │  Entry only: path · builder · core.setup · return            │
-- ╰──────────────────────────────────────────────────────────────╯

local wezterm = require("wezterm")

-- Nested modules: lua/core/foo.lua → require("core.foo")
-- Packages:       lua/core/init.lua → require("core")
package.path = table.concat({
  wezterm.config_dir .. "/lua/?.lua",
  wezterm.config_dir .. "/lua/?/init.lua",
  package.path,
}, ";")

local config = wezterm.config_builder()
return require("core").setup(config, wezterm)
