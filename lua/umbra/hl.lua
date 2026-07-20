-- Highlight math — the ONE implementation.
-- Replaces the three hand-rolled "read a highlight as hex" / "mix two colors"
-- copies that used to live in git.lua, dap.lua and wezterm.lua.

local M = {}

-- Blend `fg` over `bg` by alpha (0..1). Pure string math, safe to call at
-- module-load time (no Neovim API, works before a colorscheme is applied).
function M.blend(fg, bg, alpha)
  fg = tostring(fg):gsub("#", "")
  bg = tostring(bg):gsub("#", "")
  local function channel(i)
    local a = tonumber(fg:sub(i, i + 1), 16) or 0
    local b = tonumber(bg:sub(i, i + 1), 16) or 0
    return math.floor(a * alpha + b * (1 - alpha) + 0.5)
  end
  return string.format("#%02x%02x%02x", channel(1), channel(3), channel(5))
end

-- Read an attribute ("fg" | "bg" | "sp") of a highlight group as "#rrggbb",
-- following links. Returns nil when unset.
function M.get(group, attr)
  local ok, h = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
  if not ok or not h or type(h[attr]) ~= "number" then
    return nil
  end
  return string.format("#%06x", h[attr])
end

-- First non-nil fg among a list of candidate groups, else `fallback`.
function M.first_fg(groups, fallback)
  for _, g in ipairs(groups) do
    local v = M.get(g, "fg")
    if v then
      return v
    end
  end
  return fallback
end

return M
