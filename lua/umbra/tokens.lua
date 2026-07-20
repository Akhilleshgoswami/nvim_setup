-- Umbra design tokens — the single source of truth for UI geometry.
-- Nothing in the config declares a border, width, padding, opacity, or z-index
-- directly; it consumes one of these. Change the system here, once.

local M = {}

-- One border, everywhere.
M.border = "rounded"
M.border_chars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }

-- Spacing scale (in cells). The only legal padding values.
--   xs=1  sm=2  md=3  lg=4  xl=6  xxl=8
M.space = { none = 0, xs = 1, sm = 2, md = 3, lg = 4, xl = 6, xxl = 8 }

-- Docked panel widths (columns) — one scale for every side panel.
M.panel = {
  sm = 30, -- outline / trouble
  md = 36, -- explorer / git / buffers / undotree / DB UI / debug
  lg = 48, -- diff file panel
}

-- Floating-window sizes as fractions of the editor.
M.float = {
  sm = { width = 0.40, height = 0.40 },
  md = { width = 0.62, height = 0.62 },
  lg = { width = 0.82, height = 0.80 },
}

-- Opacity (winblend). Umbra is crisp by default; backdrop dims the world
-- behind a modal surface.
M.opacity = { solid = 0, float = 0, backdrop = 40 }

-- Z-index ladder so overlapping floats always stack predictably.
M.zindex = {
  content = 10,
  panel = 20,
  float = 30,
  popup = 40,
  notify = 50,
  palette = 60,
}

-- Title styling. "plain" = quiet text; "block" is reserved for primary
-- surfaces (pickers, explorer) that earn an accent-filled bar.
M.title = { style = "plain", pos = "center", prefix = " ", suffix = " " }

-- Icon rendering hint (Nerd Font mono keeps glyph cells uniform).
M.icon = { variant = "mono", pad = " " }

return M
