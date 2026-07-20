--- Umbra — a handcrafted dark palette.
--- Soft blue-gray surfaces inspired by Linear, Raycast, and GitHub Dark Modern.
--- Optimized for 13–14" laptops: lifted background (~15%), muted text (~88%),
--- clear elevation layers, and desaturated syntax — not near-black OLED crush.

local M = {}

-- ── Surfaces (elevation layers) ─────────────────────────────────
M.bg = {
  base = "#1A1E27", -- main editor
  dark = "#202532", -- statusline / tabline
  panel = "#202532", -- sidebar: neo-tree, trouble, aerial
  float = "#252B3B", -- floating windows, popups
  overlay = "#252B3B", -- nested surfaces / prompt row
  elevated = "#2A3142", -- hover / secondary float
  active = "#2F3850", -- selected row / menu item
  cursorline = "#262D3F",
  selection = "#2F3850", -- visual selection
  search = "#343D52", -- search match backdrop
  match = "#2F3850", -- matchparen
}

-- ── Foreground ──────────────────────────────────────────────────
M.fg = {
  base = "#E5E9F0", -- primary text (~88% brightness)
  dim = "#D8DEE9", -- parameters, secondary prose
  muted = "#8B95A7", -- inactive UI, metadata
  faint = "#6D7890", -- line numbers, guides
  comment = "#8B95A7", -- recessed but readable
}

M.border = "#343D52"
M.border_bright = "#3D4660"

-- ── Accents (slightly muted, never neon) ────────────────────────
M.accent = {
  blue = "#82AAFF", -- functions, links, info
  cyan = "#7FD1C5", -- types, hints
  emerald = "#A3D977", -- strings, success, git add
  purple = "#C792EA", -- keywords
  orange = "#F7C66F", -- numbers, warnings
  yellow = "#F7C66F", -- constants (numeric)
  red = "#F07178", -- errors, tags
  pink = "#F38BA8", -- constants, decorators
  indigo = "#8FB4FF", -- UI chrome, active line number
  teal = "#7FD1C5", -- types, labels
  sand = "#F7C66F", -- attributes, enums
  mauve = "#C792EA", -- imports, preproc
  rose = "#F38BA8", -- deletions, builtins
  peach = "#F7C66F", -- floats, booleans
  green = "#A3D977", -- alias for emerald
  violet = "#C792EA", -- alias for purple
  sky = "#89B4FA", -- operators, properties, fields
  coral = "#E8956B",
}

-- ── Git ─────────────────────────────────────────────────────────
M.git = {
  add = "#A3D977",
  change = "#82AAFF",
  delete = "#F07178",
  conflict = "#C792EA",
  ignored = "#6D7890",
  untracked = "#82AAFF",
  renamed = "#7FD1C5",
}

-- ── Diagnostics ─────────────────────────────────────────────────
M.diag = {
  error = "#F07178",
  warn = "#F7C66F",
  info = "#82AAFF",
  hint = "#7FD1C5",
  ok = "#A3D977",
}

-- ── Terminal ANSI (matched to editor warmth) ────────────────────
M.terminal = {
  black = "#1A1E27",
  red = "#F07178",
  green = "#A3D977",
  yellow = "#F7C66F",
  blue = "#82AAFF",
  magenta = "#C792EA",
  cyan = "#7FD1C5",
  white = "#E5E9F0",
  bright_black = "#6D7890",
  bright_red = "#F38BA8",
  bright_green = "#B8E986",
  bright_yellow = "#FAD07B",
  bright_blue = "#8FB4FF",
  bright_magenta = "#D4A5F5",
  bright_cyan = "#95E0D8",
  bright_white = "#F0F3F8",
}

M.none = "NONE"

--- Fallback base when transparent mode strips bg.base.
M.fallback_base = "#1A1E27"

return M
