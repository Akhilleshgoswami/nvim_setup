-- Typography rules as reusable highlight specs. One system decides how every
-- role reads: titles are bold + primary, metadata recedes, comments are italic.
-- highlights.lua and any handmade UI consume these instead of re-deciding.

local p = require("themes.umbra.palette")

local M = {}

M.title = { fg = p.accent.indigo, bold = true } -- window / section titles
M.heading = { fg = p.fg.base, bold = true } -- panel headings
M.label = { fg = p.accent.sand } -- keys / shortcuts
M.metadata = { fg = p.fg.muted } -- counts, sources, timestamps
M.breadcrumb = { fg = p.fg.dim } -- winbar path segments
M.comment = { fg = p.fg.comment, italic = true } -- prose that recedes
M.selected = { fg = p.fg.base, bg = p.bg.active, bold = true } -- current row
M.faint = { fg = p.fg.faint } -- guides, ghost UI

-- A diagnostic/severity label in its own color, always regular weight.
function M.severity(color)
  return { fg = color }
end

-- An accent-filled "block" title bar (reserved for primary surfaces).
function M.block(accent)
  return { fg = p.bg.dark, bg = accent, bold = true }
end

return M
