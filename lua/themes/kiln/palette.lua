--- Kiln — warm charcoal ash, clay, glaze, ember.
--- Locked design hues (matches Ghostty + Starship).

local M = {}

M.bg = {
  base = "#1c1814",
  dark = "#161410",
  panel = "#231f1a",
  float = "#231f1a",
  overlay = "#28231d",
  elevated = "#28231d",
  active = "#28231d",
  cursorline = "#28231d",
  selection = "#28231d",
  search = "#b8965c",
  match = "#28231d",
}

M.fg = {
  base = "#c9b8a4",
  dim = "#c9b8a4", -- punctuation/operators stay parchment (undecorated)
  muted = "#8a7c6c",
  faint = "#8a7c6c",
  comment = "#8a7c6c",
}

M.border = "#3a332c"
M.border_bright = "#4a4138"

-- Five accents only. Extra keys alias into the five so Umbra helpers resolve.
M.accent = {
  ember = "#c47a4a",
  sage = "#7a9a78",
  gold = "#b8965c",
  rose = "#a87870",
  violet = "#8a7a88",

  blue = "#c47a4a",
  cyan = "#8a7a88",
  emerald = "#7a9a78",
  purple = "#8a7a88",
  orange = "#c47a4a",
  yellow = "#b8965c",
  red = "#b85c4a",
  pink = "#a87870",
  indigo = "#8a7a88",
  teal = "#b8965c",
  sand = "#b8965c",
  mauve = "#8a7a88",
  peach = "#a87870",
  green = "#7a9a78",
  sky = "#8a7a88",
  coral = "#c47a4a",
}

M.git = {
  add = "#7a9a78",
  change = "#b8965c",
  delete = "#b85c4a",
  conflict = "#b85c4a",
  ignored = "#8a7c6c",
  untracked = "#8a7a88",
  renamed = "#b8965c",
}

M.diag = {
  error = "#b85c4a",
  warn = "#b8965c",
  info = "#8a7a88",
  hint = "#8a7a88",
  ok = "#7a9a78",
}

M.terminal = {
  black = "#2a251f",
  red = "#b85c4a",
  green = "#7a9a78",
  yellow = "#b8965c",
  blue = "#8a7a88",
  magenta = "#a87870",
  cyan = "#93ab8f",
  white = "#c9b8a4",
  bright_black = "#8a7c6c",
  bright_red = "#c47a4a",
  bright_green = "#8fae8b",
  bright_yellow = "#cdae76",
  bright_blue = "#a394a0",
  bright_magenta = "#bd918a",
  bright_cyan = "#a8c0a4",
  bright_white = "#e0d3c0",
}

M.none = "NONE"
M.fallback_base = "#1c1814"

return M
