--- Shared helpers for building Umbra highlight groups.

local M = {}

---@param fg string
---@param bg string
---@param alpha number
---@return string
function M.blend(fg, bg, alpha)
  fg = fg:gsub("#", "")
  bg = bg:gsub("#", "")
  if fg == "NONE" or bg == "NONE" then
    return bg ~= "NONE" and ("#" .. bg) or fg
  end
  local function ch(i)
    local a = tonumber(fg:sub(i, i + 1), 16) or 0
    local b = tonumber(bg:sub(i, i + 1), 16) or 0
    return math.floor(a * alpha + b * (1 - alpha) + 0.5)
  end
  return string.format("#%02x%02x%02x", ch(1), ch(3), ch(5))
end

---@param palette table
---@param config UmbraConfig
---@return table
function M.resolve_palette(palette, config)
  local p = vim.deepcopy(palette)
  if config.palette and next(config.palette) then
    p = vim.tbl_deep_extend("force", p, config.palette)
  end
  if config.transparent then
    p.bg.base = p.none
    p.bg.dark = p.none
  end
  if config.bright_cursorline then
    local fb = p.fallback_base or palette.fallback_base or "#1A1E27"
    p.bg.cursorline = M.blend(p.fg.faint, p.bg.base == p.none and fb or p.bg.base, 0.12)
  end
  return p
end

---@param palette table
---@return table Derived semantic colors for diffs, indents, headings.
function M.semantic(p)
  local base = p.bg.base == p.none and (p.fallback_base or "#1A1E27") or p.bg.base
  return {
    diff = {
      add = M.blend(p.git.add, base, 0.14),
      change = M.blend(p.git.change, base, 0.14),
      delete = M.blend(p.git.delete, base, 0.14),
      text = M.blend(p.accent.blue, base, 0.22),
    },
    inline = {
      add = M.blend(p.git.add, base, 0.22),
      change = M.blend(p.accent.blue, base, 0.20),
      delete = M.blend(p.git.delete, base, 0.24),
    },
    indent = M.blend(p.fg.faint, base, 0.35),
    heading_bg = function(accent)
      return M.blend(accent, base, 0.14)
    end,
  }
end

---@param groups table<string, vim.api.keyset.highlight>[]
---@return table<string, vim.api.keyset.highlight>
function M.merge(...)
  local out = {}
  for i = 1, select("#", ...) do
    out = vim.tbl_deep_extend("force", out, select(i, ...))
  end
  return out
end

---@param spec table
---@param style? table
---@return table
function M.style(spec, style)
  if not style then
    return spec
  end
  return vim.tbl_extend("force", vim.deepcopy(spec), style)
end

return M
