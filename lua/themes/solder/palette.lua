--- Solder — circuit board under a loupe (dimmed variant).
--- Contrast target ~7:1. Hue carries distinction; weight stays minimal.

local M = {}

M.bg = {
  base = "#1a1815",
  dark = "#161411",
  panel = "#221f1a",
  float = "#221f1a",
  overlay = "#282419",
  elevated = "#282419",
  active = "#282419",
  cursorline = "#282419",
  selection = "#282419",
  search = "#ac8a2c",
  match = "#282419",
}

M.fg = {
  base = "#b8ad9c",
  dim = "#b8ad9c",
  muted = "#655f52",
  faint = "#655f52",
  comment = "#655f52",
}

M.border = "#3a352b"
M.border_bright = "#443e33"

-- Five accents only. Aliases let Umbra helpers resolve.
M.accent = {
  copper = "#ab6f42",
  teal = "#46796f",
  green = "#6c8060",
  gold = "#ac8a2c",
  brown = "#93624f",

  ember = "#ab6f42",
  sage = "#6c8060",
  violet = "#46796f",
  rose = "#93624f",
  blue = "#ab6f42",
  cyan = "#46796f",
  emerald = "#6c8060",
  purple = "#46796f",
  orange = "#ab6f42",
  yellow = "#ac8a2c",
  red = "#a83e34",
  pink = "#93624f",
  indigo = "#46796f",
  sand = "#ac8a2c",
  mauve = "#46796f",
  peach = "#93624f",
  sky = "#46796f",
  coral = "#ab6f42",
}

M.git = {
  add = "#6c8060",
  change = "#ac8a2c",
  delete = "#a83e34",
  conflict = "#a83e34",
  ignored = "#655f52",
  untracked = "#46796f",
  renamed = "#ac8a2c",
}

M.diag = {
  error = "#a83e34",
  warn = "#ac8a2c",
  info = "#46796f",
  hint = "#46796f",
  ok = "#6c8060",
}

M.terminal = {
  black = "#1a1815",
  red = "#a83e34",
  green = "#6c8060",
  yellow = "#ac8a2c",
  blue = "#46796f",
  magenta = "#93624f",
  cyan = "#46796f",
  white = "#b8ad9c",
  bright_black = "#655f52",
  bright_red = "#a83e34",
  bright_green = "#7a9169",
  bright_yellow = "#bc9a38",
  bright_blue = "#528a7f",
  bright_magenta = "#a0705c",
  bright_cyan = "#528a7f",
  bright_white = "#cfc4b3",
}

M.none = "NONE"
M.fallback_base = "#1a1815"

return M
