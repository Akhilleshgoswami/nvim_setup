-- Startup / gui-startup hooks.

local logger = require("utils.logger")

local M = {}

function M.setup(wezterm)
  wezterm.on("gui-startup", function(_cmd)
    logger.info("gui-startup")
  end)

  wezterm.on("window-config-reloaded", function(_window, _pane)
    logger.info("config reloaded")
  end)
end

return M
