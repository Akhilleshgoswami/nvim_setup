-- Visual composition that isn't fonts / window / colors / tabs.
-- Kept thin: most appearance concerns live in dedicated modules.

local M = {}

function M.apply(_config, _wezterm)
  -- Reserved for cross-cutting visual tweaks. Prefer core.fonts /
  -- core.window / core.tabbar / core.terminal for real settings.
end

return M
