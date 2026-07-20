--- Resolve the active built-in theme palette (umbra).

local M = {}

---@return table palette
function M.palette()
  local mod = require("themes.umbra")
  return mod.resolved or mod.base_palette or mod.palette
end

return M
