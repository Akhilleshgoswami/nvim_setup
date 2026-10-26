-- Window chrome: decorations, padding, opacity, blur, size.

local prefs = require("core.config")

local M = {}

function M.apply(config, _wezterm)
  local w = prefs.window
  config.window_decorations = w.decorations
  config.window_padding = w.padding
  config.adjust_window_size_when_changing_font_size = false
  config.window_close_confirmation = "NeverPrompt"
  config.initial_cols = w.initial_cols
  config.initial_rows = w.initial_rows
  config.window_background_opacity = w.opacity
  config.macos_window_background_blur = w.macos_blur
  config.text_background_opacity = w.text_opacity
  config.inactive_pane_hsb = w.inactive_pane_hsb
end

return M
