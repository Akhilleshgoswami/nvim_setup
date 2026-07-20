--- Orchestrates all Umbra highlight modules into one flat group table.

local util = require("themes.umbra.util")

---@param palette table Base palette
---@param cfg UmbraConfig
---@return table<string, vim.api.keyset.highlight>
return function(palette, cfg)
  local p = util.resolve_palette(palette, cfg)
  local sem = util.semantic(p)

  local groups = util.merge(
    require("themes.umbra.groups")(p, sem, cfg),
    require("themes.umbra.treesitter")(p, sem, cfg),
    require("themes.umbra.lsp")(p, sem, cfg)
  )

  if cfg.plugins ~= false then
    groups = util.merge(groups, require("themes.umbra.plugins")(p, sem, cfg))
  end

  if cfg.overrides and next(cfg.overrides) then
    groups = util.merge(groups, cfg.overrides)
  end

  return groups, p, sem
end
