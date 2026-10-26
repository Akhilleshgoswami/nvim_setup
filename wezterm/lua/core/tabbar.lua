-- Tab bar options (visual formatting lives in events/smart-tab.lua).

local prefs = require("core.config")

local M = {}

function M.apply(config, _wezterm)
  local t = prefs.tabbar
  config.enable_tab_bar = t.enabled
  config.use_fancy_tab_bar = t.fancy
  config.show_new_tab_button_in_tab_bar = t.show_new_tab
  config.show_tab_index_in_tab_bar = t.show_index
  config.hide_tab_bar_if_only_one_tab = t.hide_if_only_one
  config.tab_bar_at_bottom = t.at_bottom
  config.tab_max_width = t.max_width
end

return M
