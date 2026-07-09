---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "onedark",
}

M.nvdash = {
  load_on_startup = true,
}

M.ui = {
  tabufline = {
    enabled = true,
    lazyload = false,
  },
  statusline = {
    enabled = true,
    theme = "default",
  },
  cmp = {
    style = "default",
  },
}

return M
