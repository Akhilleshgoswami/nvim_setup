-- Shared small helpers used across modules.

local M = {}

function M.basename(path)
  if not path or path == "" then
    return ""
  end
  path = path:gsub("[/\\]+$", "")
  return path:match("([^/\\]+)$") or path
end

function M.trim(s)
  return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

--- Convert a file:// URI (or plain path) into a filesystem path.
function M.uri_to_path(uri)
  if not uri or uri == "" then
    return nil
  end
  if type(uri) == "userdata" or type(uri) == "table" then
    -- WezTerm Url object
    local ok, s = pcall(function()
      return tostring(uri.file_path or uri.path or uri)
    end)
    if ok and s and s ~= "" then
      return s
    end
  end
  local s = tostring(uri)
  if s:match("^file://") then
    s = s:gsub("^file://", "")
    -- Drop hostname on file://localhost/path
    s = s:gsub("^localhost", "")
    s = s:gsub("^[^/]+", "", 1)
    s = (s:gsub("%%(%x%x)", function(h)
      return string.char(tonumber(h, 16))
    end))
  end
  return s
end

function M.read_file(path)
  local f = io.open(path, "r")
  if not f then
    return nil
  end
  local data = f:read("*a")
  f:close()
  return data
end

--- Best-effort git branch for a working directory.
function M.git_branch(cwd)
  if not cwd or cwd == "" then
    return nil
  end
  local head = M.read_file(cwd .. "/.git/HEAD")
  if head then
    local branch = head:match("ref: refs/heads/([^\r\n]+)")
    if branch then
      return M.trim(branch)
    end
  end
  -- Worktrees / nested: fall back to git binary (cheap enough for status ticks).
  local ok, out = pcall(function()
    local cmd = string.format("git -C %q rev-parse --abbrev-ref HEAD 2>/dev/null", cwd)
    local f = io.popen(cmd)
    if not f then
      return nil
    end
    local line = f:read("*l")
    f:close()
    return line
  end)
  if ok and out and out ~= "" and out ~= "HEAD" then
    return M.trim(out)
  end
  return nil
end

function M.merge(dst, src)
  for k, v in pairs(src or {}) do
    dst[k] = v
  end
  return dst
end

return M
