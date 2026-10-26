-- User preferences — the single place to tweak defaults.
-- Modules read from here; they do not hard-code magic numbers.

local M = {}

-- Active fallback theme name when Neovim sync is unavailable.
-- One of: loam | umbra | github | catppuccin | tokyonight | kanagawa
M.fallback_theme = "loam"

-- Fonts (first installed family wins).
M.fonts = {
  families = {
    "JetBrainsMono Nerd Font Mono",
    { family = "JetBrainsMono Nerd Font", weight = "Medium" },
    { family = "CaskaydiaCove Nerd Font", weight = "Medium" },
    { family = "CaskaydiaCove Nerd Font Mono", weight = "Medium" },
    "FiraCode Nerd Font",
    "Hack Nerd Font",
    "Symbols Nerd Font Mono",
    "Apple Color Emoji",
  },
  size = 13,
  line_height = 1.1,
  cell_width = 1.0,
  harfbuzz = { "calt=1", "liga=1" },
}

-- Window chrome.
M.window = {
  decorations = "TITLE | RESIZE",
  padding = { left = 8, right = 8, top = 6, bottom = 6 },
  opacity = 0.96,
  macos_blur = 20,
  text_opacity = 1.0,
  initial_cols = 170,
  initial_rows = 48,
  inactive_pane_hsb = { saturation = 0.9, brightness = 0.82 },
}

-- Tab bar.
M.tabbar = {
  enabled = true,
  fancy = false, -- custom format-tab-title
  hide_if_only_one = false,
  at_bottom = false,
  max_width = 32,
  show_new_tab = false,
  show_index = false,
}

-- Performance.
M.performance = {
  front_end = "WebGpu",
  webgpu_power = "HighPerformance",
  max_fps = 144,
  animation_fps = 60,
  scrollback = 100000,
}

-- Terminal QoL.
M.terminal = {
  shell = { "/bin/zsh", "-l" },
  audible_bell = "Disabled",
  check_updates = false,
  cursor_style = "SteadyBlock",
  hide_mouse_when_typing = true,
}

-- Leader key (Ghostty-style ⌘-a chord layer).
M.leader = { key = "a", mods = "CMD", timeout_milliseconds = 1000 }

return M
