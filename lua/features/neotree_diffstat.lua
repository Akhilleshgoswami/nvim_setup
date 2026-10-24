--- VS Code-style +N / -M diff counts in neo-tree (filesystem + git status).

local M = {}

M.cache = {}

local function normalize_path(path)
  return (path or ""):gsub("\\", "/")
end

function M.relpath(abs_path)
  abs_path = vim.fn.fnamemodify(abs_path, ":p")
  local git_dir = vim.fn.finddir(".git", upward)
  if git_dir ~= "" then
    local root = vim.fn.fnamemodify(git_dir, ":h")
    if vim.startswith(abs_path, root) then
      return normalize_path(abs_path:sub(#root + 2))
    end
  end
  return normalize_path(vim.fn.fnamemodify(abs_path, ":."))
end

function M.refresh()
  if vim.fn.executable("git") ~= 1 then
    M.cache = {}
    return
  end

  local cache = {}

  local function absorb(cmd)
    local ok, lines = pcall(vim.fn.systemlist, cmd)
    if not ok or vim.v.shell_error ~= 0 then
      return
    end
    for _, line in ipairs(lines) do
      local added, removed, path = line:match("^(%S+)%s+(%S+)%s+(.+)$")
      if path then
        path = normalize_path(path)
        local entry = cache[path] or { added = 0, removed = 0 }
        entry.added = entry.added + (added == "-" and 0 or tonumber(added) or 0)
        entry.removed = entry.removed + (removed == "-" and 0 or tonumber(removed) or 0)
        cache[path] = entry
      end
    end
  end

  -- Staged + unstaged, like VS Code Source Control totals.
  absorb("git diff --numstat")
  absorb("git diff --numstat --cached")

  M.cache = cache
end

function M.component(_config, node, _state)
  if node.type ~= "file" then
    return {}
  end

  local stat = M.cache[M.relpath(node.path)]
  if not stat or (stat.added == 0 and stat.removed == 0) then
    return {}
  end

  local parts = {}
  if stat.added > 0 then
    parts[#parts + 1] = { text = "+" .. stat.added, highlight = "NeoTreeDiffAdded" }
  end
  if stat.removed > 0 then
    if #parts > 0 then
      parts[#parts + 1] = { text = " " }
    end
    parts[#parts + 1] = { text = "-" .. stat.removed, highlight = "NeoTreeDiffRemoved" }
  end
  return parts
end

local function inject_diffstat(renderer)
  renderer = vim.deepcopy(renderer)
  for _, item in ipairs(renderer) do
    if item[1] == "container" and type(item.content) == "table" then
      for i, comp in ipairs(item.content) do
        if comp[1] == "git_status" or comp[1] == "diffstat" then
          if comp[1] ~= "diffstat" then
            table.insert(item.content, i, {
              "diffstat",
              zindex = 15,
              align = "right",
              required_width = 72,
            })
          end
          return renderer
        end
      end
      item.content[#item.content + 1] = {
        "diffstat",
        zindex = 15,
        align = "right",
        required_width = 72,
      }
    end
  end
  return renderer
end

function M.configure(opts)
  local defaults = require("neo-tree.defaults")

  opts.filesystem = opts.filesystem or {}
  opts.filesystem.components = vim.tbl_extend("force", opts.filesystem.components or {}, {
    diffstat = M.component,
  })
  opts.filesystem.renderers = opts.filesystem.renderers or {}
  if not opts.filesystem.renderers.file then
    opts.filesystem.renderers.file = inject_diffstat(defaults.renderers.file)
  end

  opts.git_status = opts.git_status or {}
  opts.git_status.components = vim.tbl_extend("force", opts.git_status.components or {}, {
    diffstat = M.component,
  })
  opts.git_status.renderers = opts.git_status.renderers or {}
  if not opts.git_status.renderers.file then
    opts.git_status.renderers.file = inject_diffstat(defaults.renderers.file)
  end

  opts.event_handlers = opts.event_handlers or {}
  opts.event_handlers[#opts.event_handlers + 1] = {
    event = "before_render",
    handler = function()
      M.refresh()
    end,
  }

  return opts
end

function M.setup_autocmd()
  local group = vim.api.nvim_create_augroup("umbra_neotree_diffstat", { clear = true })
  vim.api.nvim_create_autocmd({ "BufWritePost", "FocusGained", "ShellCmdPost", "DirChanged" }, {
    group = group,
    callback = function()
      M.refresh()
      vim.schedule(function()
        pcall(require("neo-tree.sources.filesystem").refresh)
        pcall(require("neo-tree.sources.git_status").refresh)
      end)
    end,
  })
  M.refresh()
end

return M
