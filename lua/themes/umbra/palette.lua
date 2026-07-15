-- Umbra — a bespoke, low-contrast premium dark palette.
-- Cool graphite base, soft off-white foreground, desaturated accents.
-- Tuned for 10+ hour sessions: nothing screams, everything reads.

local M = {}

M.bg = {
  base = "#101216", -- editor background (very dark, faint blue)
  dark = "#0B0C10", -- statusline caps / darker gutters
  panel = "#0E0F13", -- sidebars: neo-tree, trouble, aerial
  float = "#15171D", -- floating windows / popups
  overlay = "#191C23", -- nested floats / menus over floats
  active = "#1E222B", -- selected menu item / picker cursor row
  cursorline = "#181B22",
  selection = "#293040", -- visual selection (muted blue-gray)
  search = "#3A4152", -- search match backdrop
  match = "#2A3140", -- matchparen
}

M.fg = {
  base = "#C6CAD4", -- primary text (soft, never pure white)
  dim = "#9AA0AE", -- secondary text
  muted = "#6B7280", -- inactive line numbers, ghost UI
  faint = "#3D424D", -- borders-as-text, indent guides
  comment = "#565D6D", -- comments (recessed but legible)
}

M.border = "#242A35" -- refined float / split borders
M.border_bright = "#333B49" -- active window edge

-- Accents — desaturated, premium. Used sparingly.
M.accent = {
  rose = "#EB6F82", -- errors, deletions, tags
  coral = "#E8956B", -- rarely used warm
  peach = "#E8A87C", -- numbers, constants, booleans
  sand = "#E6C58C", -- types, attributes, warnings
  green = "#9BD09E", -- strings, additions
  teal = "#5FD1BE", -- escapes, regex, special, hints
  sky = "#9DC7E0", -- properties, fields
  blue = "#7FA7F0", -- functions, info
  indigo = "#8E9BF2", -- primary UI accent (normal mode)
  violet = "#B39DF3", -- keywords
  mauve = "#C79BE6", -- decorators, uncommon keywords
  pink = "#DB9BD0", -- special identifiers
}

-- Semantic git colors
M.git = {
  add = "#7FC891",
  change = "#D8B673",
  delete = "#D97284",
  conflict = "#C79BE6",
  ignored = "#565D6D",
  untracked = "#7FA7F0",
}

-- Diagnostics (soft)
M.diag = {
  error = "#E5788A",
  warn = "#E4C08A",
  info = "#82A9F0",
  hint = "#67C7B8",
  ok = "#9BD09E",
}

-- Terminal ANSI (cohesive with syntax)
M.terminal = {
  black = "#191C23",
  red = "#EB6F82",
  green = "#9BD09E",
  yellow = "#E6C58C",
  blue = "#7FA7F0",
  magenta = "#B39DF3",
  cyan = "#5FD1BE",
  white = "#C6CAD4",
  bright_black = "#565D6D",
  bright_red = "#EF8496",
  bright_green = "#AAD9AC",
  bright_yellow = "#EDCF9E",
  bright_blue = "#96B8F4",
  bright_magenta = "#C3B0F6",
  bright_cyan = "#7CD9C9",
  bright_white = "#E4E7EE",
}

M.none = "NONE"

return M
