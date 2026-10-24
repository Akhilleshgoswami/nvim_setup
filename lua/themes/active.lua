--- Resolve the active built-in theme palette (kiln, meridian, solder, loam, or umbra).

local M = {}

---@return table palette
function M.palette()
  local name = vim.g.colors_name
  if name == "kiln" then
    local mod = require("themes.kiln")
    return mod.resolved or mod.base_palette or mod.palette
  end
  if name == "umbra" then
    local mod = require("themes.umbra")
    return mod.resolved or mod.base_palette or mod.palette
  end
  if name == "meridian" then
    local mod = require("themes.meridian")
    return mod.resolved or mod.base_palette or mod.palette
  end
  if name == "solder" then
    local mod = require("themes.solder")
    return mod.resolved or mod.base_palette or mod.palette
  end
  if name == "loam" then
    local mod = require("themes.loam")
    return mod.resolved or mod.base_palette or mod.palette
  end
  -- Default identity when an external scheme is active.
  local mod = require("themes.kiln")
  return mod.resolved or mod.base_palette or mod.palette
end

return M
