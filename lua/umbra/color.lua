-- Semantic color layer over the raw palette.
-- The palette holds primitives (named pigments); this file gives them meaning
-- (primary / success / warning / error …) and derives every tinted background
-- by blending, so no hand-picked hex ever escapes the palette again.

local active = require("themes.active")
local p = active.palette()
local hl = require("umbra.hl")

local M = { palette = p }

-- ── Semantic roles ──────────────────────────────────────────────
M.primary = p.accent.indigo
M.secondary = p.accent.blue
M.success = p.diag.ok
M.warning = p.diag.warn
M.error = p.diag.error
M.info = p.diag.info
M.hint = p.diag.hint
M.muted = p.fg.muted

-- ── Diff line backgrounds (soft, for full-line diff regions) ────
M.diff = {
  add = hl.blend(p.git.add, p.bg.base, 0.14),
  change = hl.blend(p.git.change, p.bg.base, 0.14),
  delete = hl.blend(p.git.delete, p.bg.base, 0.14),
  text = hl.blend(p.accent.blue, p.bg.base, 0.24),
}

-- ── Word-diff / inline backgrounds (a touch stronger) ───────────
M.inline = {
  add = hl.blend(p.git.add, p.bg.base, 0.22),
  change = hl.blend(p.accent.blue, p.bg.base, 0.22),
  delete = hl.blend(p.git.delete, p.bg.base, 0.24),
}

-- ── Indent guides — barely-there ────────────────────────────────
M.indent = hl.blend(p.fg.faint, p.bg.base, 0.35)

-- ── Debugger stop line ──────────────────────────────────────────
M.stopped_line = hl.blend(p.git.add, p.bg.base, 0.18)

-- Markdown heading tint: accent washed onto the editor base.
function M.heading_bg(accent)
  return hl.blend(accent, p.bg.base, 0.14)
end

-- Convenience passthroughs so consumers need only require this module.
M.bg = p.bg
M.fg = p.fg
M.accent = p.accent
M.git = p.git
M.diag = p.diag
M.border = p.border
M.border_bright = p.border_bright
M.none = p.none

return M
