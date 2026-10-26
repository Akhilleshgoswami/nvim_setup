-- Shell, cursor, bell, and other terminal QoL.

local prefs = require("core.config")

local M = {}

function M.apply(config, _wezterm)
  local t = prefs.terminal
  config.default_prog = t.shell
  config.audible_bell = t.audible_bell
  config.check_for_updates = t.check_updates
  config.default_cursor_style = t.cursor_style
  config.hide_mouse_cursor_when_typing = t.hide_mouse_when_typing == true
  if t.cursor_blink_rate then
    config.cursor_blink_rate = t.cursor_blink_rate
    config.cursor_blink_ease_in = "EaseOut"
    config.cursor_blink_ease_out = "EaseOut"
  end
end

return M
