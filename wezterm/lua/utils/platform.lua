-- Host / OS detection helpers.

local M = {}

function M.is_macos(wezterm)
  return wezterm.target_triple:find("apple") ~= nil or wezterm.target_triple:find("darwin") ~= nil
end

function M.is_linux(wezterm)
  return wezterm.target_triple:find("linux") ~= nil
end

function M.hostname()
  local ok, name = pcall(function()
    local f = io.popen("hostname -s 2>/dev/null || hostname 2>/dev/null")
    if not f then
      return nil
    end
    local out = f:read("*l")
    f:close()
    return out
  end)
  return (ok and name and name ~= "") and name or "localhost"
end

return M
