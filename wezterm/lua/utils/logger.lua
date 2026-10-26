-- Tiny logger. Enabled only when WEZTERM_DEBUG=1.

local M = {}

function M.info(msg)
  if os.getenv("WEZTERM_DEBUG") == "1" then
    io.stderr:write("[wezterm] " .. tostring(msg) .. "\n")
  end
end

function M.warn(msg)
  io.stderr:write("[wezterm] warn: " .. tostring(msg) .. "\n")
end

return M
