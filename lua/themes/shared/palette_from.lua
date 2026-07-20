--- Normalize Umbra palette for shared consumers.

local M = {}

---@param p table Umbra resolved palette
---@return table
function M.umbra(p)
  local a = p.accent
  return {
    bg = p.bg.base,
    bg_dim = p.bg.dark,
    bg_float = p.bg.float,
    bg_alt = p.bg.overlay,
    bg_select = p.bg.active,
    bg_search = p.bg.search,
    fg = p.fg.base,
    fg_dim = p.fg.dim,
    fg_faint = p.fg.muted,
    line_nr = p.fg.faint,
    blue = a.blue,
    mint = a.emerald,
    sage = a.emerald,
    gold = a.orange,
    amber = a.indigo,
    border = p.border,
    none = p.none,
  }
end

return M
