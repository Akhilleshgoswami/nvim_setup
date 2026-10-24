--- Meridian — WCAG-tuned palette (from the original theme spec).
--- Contrasts verified against bg #1b1e23.

local M = {}

M.bg = {
  base = "#1b1e23",
  dark = "#16181d",
  panel = "#16181d",
  float = "#21252c",
  overlay = "#21252c",
  elevated = "#2b3038",
  active = "#2b3038",
  cursorline = "#21252c",
  selection = "#2b3038",
  search = "#37404f",
  match = "#2b3038",
}

M.fg = {
  base = "#aebbcf", -- 8.60:1 AAA
  dim = "#7f8ba3", -- 4.87:1
  muted = "#7a86a3", -- 4.59:1 comments
  faint = "#68738f", -- 3.53:1 line numbers
  comment = "#7a86a3",
}

M.border = "#343a45"
M.border_bright = "#3e4552"

M.accent = {
  blue = "#7c9fd6", -- 6.20:1 keywords / functions / UI
  cyan = "#72b8c9", -- 7.49:1 info / properties
  emerald = "#82c39a", -- 8.13:1 strings
  purple = "#a880c2", -- 5.20:1 special / macros
  orange = "#d69a72", -- 6.94:1 constants
  yellow = "#d6b878", -- 8.74:1 warnings
  red = "#d67d7d", -- 5.64:1 errors
  pink = "#c98fb0",
  indigo = "#7c9fd6",
  teal = "#6cb8ae", -- 7.25:1 types
  sand = "#d6b878",
  mauve = "#a880c2",
  rose = "#d67d7d",
  peach = "#d69a72",
  green = "#82c39a",
  violet = "#a880c2",
  sky = "#72b8c9",
  coral = "#d69a72",
  gold = "#d6b878",
}

M.git = {
  add = "#82c39a",
  change = "#d6b878",
  delete = "#d67d7d",
  conflict = "#a880c2",
  ignored = "#7a86a3",
  untracked = "#7c9fd6",
  renamed = "#6cb8ae",
}

M.diag = {
  error = "#d67d7d",
  warn = "#d6b878",
  info = "#72b8c9",
  hint = "#6cb8ae",
  ok = "#82c39a",
}

M.terminal = {
  black = "#1b1e23",
  red = "#d67d7d",
  green = "#82c39a",
  yellow = "#d6b878",
  blue = "#7c9fd6",
  magenta = "#a880c2",
  cyan = "#6cb8ae",
  white = "#aebbcf",
  bright_black = "#68738f",
  bright_red = "#e09090",
  bright_green = "#95d0ab",
  bright_yellow = "#e0c88a",
  bright_blue = "#90b0e0",
  bright_magenta = "#b894d0",
  bright_cyan = "#82c8be",
  bright_white = "#c4d0e0",
}

M.none = "NONE"
M.fallback_base = "#1b1e23"

return M
