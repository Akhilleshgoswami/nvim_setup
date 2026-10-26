-- GPU, FPS, scrollback, and rendering.

local prefs = require("core.config")

local M = {}

function M.apply(config, _wezterm)
  local p = prefs.performance
  config.front_end = p.front_end
  config.webgpu_power_preference = p.webgpu_power
  config.max_fps = p.max_fps
  config.animation_fps = p.animation_fps
  config.scrollback_lines = p.scrollback
  config.enable_scroll_bar = false
end

return M
