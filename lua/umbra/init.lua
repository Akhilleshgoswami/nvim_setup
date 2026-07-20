-- Umbra design system — one namespace, the single source of truth for the
-- editor's visual language. `local ui = require("umbra")` gives you tokens,
-- semantic colors, the glyph set, highlight math, the float factory, the
-- typography rules and the motion clock.

return {
  tokens = require("umbra.tokens"),
  color = require("umbra.color"),
  icons = require("umbra.icons"),
  hl = require("umbra.hl"),
  window = require("umbra.window"),
  text = require("umbra.text"),
  motion = require("umbra.motion"),
  palette = require("themes.umbra.palette"),
}
