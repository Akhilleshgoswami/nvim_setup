-- Colors entrypoint — delegates to the Neovim sync layer.

local sync = require("sync.nvim-sync")

local M = {}

function M.apply(config, wezterm)
  sync.apply(config, wezterm)
end

-- Re-export helpers used by event handlers.
M.ui_colors = sync.ui_colors
M.current_theme = sync.current_theme

return M
