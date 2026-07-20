-- Compat shim. UI geometry now lives in umbra.tokens / umbra.window.
local t = require("umbra.tokens")
local window = require("umbra.window")

local M = {}
M.border = t.border
M.border_chars = t.border_chars
M.float_opts = window.float

return M
