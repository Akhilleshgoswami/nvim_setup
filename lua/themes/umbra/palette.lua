--- Umbra — a handcrafted dark palette.
--- Soft blue-gray surfaces inspired by Cursor, Zed, Linear, Warp, and GitHub Dark Modern.
--- Tuned for 13–14" laptops: lifted background (no pure black), warm accents,
--- clear elevation layers, and desaturated syntax for long sessions.

local M = {}

-- ── Surfaces (elevation layers) ─────────────────────────────────
M.bg = {
  base = "#1A1E27", -- main editor
  dark = "#202532", -- statusline / tabline
  panel = "#202532", -- sidebar: neo-tree, trouble, aerial
  float = "#252B3B", -- floating windows, popups
  overlay = "#2B3245", -- nested surfaces / prompt row
  elevated = "#2B3245", -- hover / secondary float
  active = "#30384D", -- selected row / menu item
  cursorline = "#30384D",
  selection = "#39445D", -- visual selection
  search = "#39445D", -- search match backdrop
  match = "#30384D", -- matchparen
}

-- ── Foreground ──────────────────────────────────────────────────
M.fg = {
  base = "#E6EDF3", -- primary text
  dim = "#C9D1D9", -- parameters, secondary prose
  muted = "#A9B4C8", -- inactive UI, metadata
  faint = "#8A93A8", -- line numbers, guides
  comment = "#8A93A8", -- recessed but readable
}

M.border = "#3C475F"
M.border_bright = "#4A5570"

-- ── Accents (warm, calm — never neon) ───────────────────────────
M.accent = {
  blue = "#82AAFF", -- functions, links, info
  cyan = "#7FDBCA", -- types, hints
  emerald = "#A3D977", -- strings, success, git add
  purple = "#C792EA", -- keywords
  orange = "#F2A65A", -- numbers, warnings
  yellow = "#F5C76A", -- constants (numeric)
  red = "#F7768E", -- errors, tags
  pink = "#F29EC2", -- constants, decorators
  indigo = "#82AAFF", -- UI chrome, active line number
  teal = "#7FDBCA", -- types, labels
  sand = "#F5C76A", -- attributes, enums
  mauve = "#C792EA", -- imports, preproc
  rose = "#F7768E", -- deletions, builtins
  peach = "#F2A65A", -- floats, booleans
  green = "#A3D977", -- alias for emerald
  violet = "#C792EA", -- alias for purple
  sky = "#89B4FA", -- operators, properties, fields
  coral = "#F2A65A",
}

-- ── Git ─────────────────────────────────────────────────────────
M.git = {
  add = "#A3D977",
  change = "#82AAFF",
  delete = "#F7768E",
  conflict = "#C792EA",
  ignored = "#8A93A8",
  untracked = "#82AAFF",
  renamed = "#7FDBCA",
}

-- ── Diagnostics ─────────────────────────────────────────────────
M.diag = {
  error = "#F7768E",
  warn = "#F5C76A",
  info = "#82AAFF",
  hint = "#7FDBCA",
  ok = "#A3D977",
}

-- ── Terminal ANSI (matched to editor warmth) ────────────────────
M.terminal = {
  black = "#1A1E27",
  red = "#F7768E",
  green = "#A3D977",
  yellow = "#F5C76A",
  blue = "#82AAFF",
  magenta = "#C792EA",
  cyan = "#7FDBCA",
  white = "#E6EDF3",
  bright_black = "#8A93A8",
  bright_red = "#F29EC2",
  bright_green = "#B8E986",
  bright_yellow = "#FAD07B",
  bright_blue = "#9BB8FF",
  bright_magenta = "#D4A5F5",
  bright_cyan = "#95E8D8",
  bright_white = "#F0F3F8",
}

M.none = "NONE"

--- Fallback base when transparent mode strips bg.base.
M.fallback_base = "#1A1E27"

return M
