-- Assembles the full WezTerm configuration.
-- Every concern is a module with apply(config, wezterm) or setup(wezterm).

local M = {}

local CORE = {
  "core.fonts",
  "core.window",
  "core.performance",
  "core.tabbar",
  "core.terminal",
  "core.appearance",
  "core.colors",
  "core.keys",
}

local EVENTS = {
  "events.startup",
  "events.smart-tab",
  "events.update-status",
  "events.workspace",
}

function M.setup(config, wezterm)
  for _, name in ipairs(CORE) do
    require(name).apply(config, wezterm)
  end

  for _, name in ipairs(EVENTS) do
    require(name).setup(wezterm)
  end

  return config
end

return M
