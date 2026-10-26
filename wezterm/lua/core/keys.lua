-- Keybindings — grouped by concern. Behavior matches the previous flat list.
--
-- Two layers:
--   • LEADER (⌘-a, Ghostty-style) → panes, tabs, copy/search
--   • ⌘ (Cmd) → macOS/IDE muscle memory (never reaches Neovim)

local prefs = require("core.config")

local M = {}

local function panes(act)
  return {
    { key = "\\", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
    { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
    { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
    { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
    { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
    { key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = false }) },
    { key = "o", mods = "LEADER", action = act.RotatePanes("Clockwise") },
    { key = "LeftArrow", mods = "LEADER", action = act.AdjustPaneSize({ "Left", 4 }) },
    { key = "DownArrow", mods = "LEADER", action = act.AdjustPaneSize({ "Down", 4 }) },
    { key = "UpArrow", mods = "LEADER", action = act.AdjustPaneSize({ "Up", 4 }) },
    { key = "RightArrow", mods = "LEADER", action = act.AdjustPaneSize({ "Right", 4 }) },
    -- macOS ⌘ splits
    { key = "d", mods = "CMD", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "d", mods = "CMD|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "[", mods = "CMD", action = act.ActivatePaneDirection("Prev") },
    { key = "]", mods = "CMD", action = act.ActivatePaneDirection("Next") },
    { key = "LeftArrow", mods = "CMD|ALT", action = act.ActivatePaneDirection("Left") },
    { key = "RightArrow", mods = "CMD|ALT", action = act.ActivatePaneDirection("Right") },
    { key = "UpArrow", mods = "CMD|ALT", action = act.ActivatePaneDirection("Up") },
    { key = "DownArrow", mods = "CMD|ALT", action = act.ActivatePaneDirection("Down") },
    { key = "Enter", mods = "CMD|SHIFT", action = act.TogglePaneZoomState },
    { key = "w", mods = "CMD", action = act.CloseCurrentPane({ confirm = false }) },
  }
end

local function tabs(act)
  local keys = {
    { key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
    { key = "w", mods = "LEADER", action = act.CloseCurrentTab({ confirm = false }) },
    { key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
    { key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
    { key = "t", mods = "CMD", action = act.SpawnTab("CurrentPaneDomain") },
    { key = "[", mods = "CMD|SHIFT", action = act.ActivateTabRelative(-1) },
    { key = "]", mods = "CMD|SHIFT", action = act.ActivateTabRelative(1) },
  }
  for i = 1, 9 do
    keys[#keys + 1] = { key = tostring(i), mods = "CMD", action = act.ActivateTab(i - 1) }
    keys[#keys + 1] = { key = tostring(i), mods = "LEADER", action = act.ActivateTab(i - 1) }
  end
  return keys
end

local function font_size(act)
  return {
    { key = "-", mods = "CMD", action = act.DecreaseFontSize },
    { key = "=", mods = "CMD", action = act.IncreaseFontSize },
    { key = "0", mods = "CMD", action = act.ResetFontSize },
  }
end

local function search_clipboard(act)
  return {
    { key = "[", mods = "LEADER", action = act.ActivateCopyMode },
    { key = "f", mods = "LEADER", action = act.Search({ CaseInSensitiveString = "" }) },
    { key = "Space", mods = "LEADER", action = act.QuickSelect },
    { key = "f", mods = "CMD", action = act.Search({ CaseInSensitiveString = "" }) },
    { key = "k", mods = "CMD", action = act.ClearScrollback("ScrollbackAndViewport") },
  }
end

local function window_terminal(act)
  return {
    { key = "a", mods = "LEADER|CTRL", action = act.SendKey({ key = "a", mods = "CTRL" }) },
    { key = "r", mods = "LEADER", action = act.ReloadConfiguration },
    { key = "P", mods = "LEADER", action = act.ActivateCommandPalette },
    { key = "p", mods = "CMD|SHIFT", action = act.ActivateCommandPalette },
    { key = "Enter", mods = "CMD", action = act.ToggleFullScreen },
    { key = "r", mods = "CMD|SHIFT", action = act.ReloadConfiguration },
  }
end

local function concat(dst, src)
  for _, item in ipairs(src) do
    dst[#dst + 1] = item
  end
end

function M.apply(config, wezterm)
  local act = wezterm.action
  config.leader = prefs.leader

  local keys = {}
  concat(keys, window_terminal(act))
  concat(keys, panes(act))
  concat(keys, tabs(act))
  concat(keys, font_size(act))
  concat(keys, search_clipboard(act))
  config.keys = keys

  config.mouse_bindings = {
    {
      event = { Up = { streak = 1, button = "Left" } },
      mods = "CMD",
      action = act.OpenLinkAtMouseCursor,
    },
  }
end

return M
