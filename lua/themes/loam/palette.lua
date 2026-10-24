--- Loam — potting bench / root cellar (balanced v3).
--- Dark background for fatigue; saturated accents for legibility.

local M = {}

M.bg = {
  base = "#211d17",
  dark = "#1c1812",
  panel = "#2a251c",
  float = "#2a251c",
  overlay = "#322b20",
  elevated = "#322b20",
  active = "#322b20",
  cursorline = "#322b20",
  selection = "#322b20",
  search = "#c9a227",
  match = "#322b20",
}

M.fg = {
  base = "#cabb9c",
  dim = "#cabb9c",
  muted = "#6f6553",
  faint = "#6f6553",
  comment = "#6f6553",
}

M.border = "#3d362a"
M.border_bright = "#474035"

-- Five accents. Aliases let Umbra helpers resolve.
M.accent = {
  ember = "#c98146",
  moss = "#86a25f",
  straw = "#c9a227",
  clay = "#bb725a",
  plum = "#96788a",

  terracotta = "#c98146",
  leaf = "#c9a227",
  ochre = "#bb725a",
  root = "#96788a",
  green = "#86a25f",
  gold = "#c9a227",
  brown = "#96788a",
  copper = "#c98146",
  teal = "#86a25f",
  emerald = "#86a25f",
  sage = "#86a25f",
  violet = "#96788a",
  rose = "#96788a",
  blue = "#bb725a",
  cyan = "#96788a",
  purple = "#96788a",
  orange = "#c98146",
  yellow = "#c9a227",
  red = "#b8503f",
  pink = "#96788a",
  indigo = "#96788a",
  sand = "#c9a227",
  mauve = "#96788a",
  peach = "#bb725a",
  sky = "#96788a",
  coral = "#c98146",
}

M.git = {
  add = "#86a25f",
  change = "#c9a227",
  delete = "#b8503f",
  conflict = "#b8503f",
  ignored = "#6f6553",
  untracked = "#96788a",
  renamed = "#c9a227",
}

M.diag = {
  error = "#b8503f",
  warn = "#c9a227",
  info = "#96788a",
  hint = "#96788a",
  ok = "#86a25f",
}

M.terminal = {
  black = "#211d17",
  red = "#b8503f",
  green = "#86a25f",
  yellow = "#c9a227",
  blue = "#96788a",
  magenta = "#96788a",
  cyan = "#86a25f",
  white = "#cabb9c",
  bright_black = "#6f6553",
  bright_red = "#c98146",
  bright_green = "#9ab073",
  bright_yellow = "#dab73f",
  bright_blue = "#a5859e",
  bright_magenta = "#a5859e",
  bright_cyan = "#9ab073",
  bright_white = "#e8ddc5",
}

M.none = "NONE"
M.fallback_base = "#211d17"

return M
