-- Process / cwd classification for smart tab titles.

local helpers = require("utils.helpers")
local icons = require("utils.icons")

local M = {}

local PROCESS_MAP = {
  { "nvim", icons.process.nvim, "Neovim" },
  { "vim", icons.process.vim, "Vim" },
  { "lazygit", icons.process.lazygit, "LazyGit" },
  { "gitui", icons.process.git, "GitUI" },
  { "node", icons.process.node, "Node" },
  { "npm", icons.process.npm, "npm" },
  { "pnpm", icons.process.pnpm, "pnpm" },
  { "yarn", icons.process.yarn, "yarn" },
  { "docker", icons.process.docker, "Docker" },
  { "python", icons.process.python, "Python" },
  { "cargo", icons.process.cargo, "Cargo" },
  { "rustc", icons.process.rust, "Rust" },
  { "go", icons.process.go, "Go" },
  { "lua", icons.process.lua, "Lua" },
  { "ssh", icons.process.ssh, "SSH" },
}

local SHELLS = { zsh = true, bash = true, fish = true, sh = true }

function M.pane_cwd(pane)
  if not pane then
    return nil
  end
  -- Live Pane object (status events)
  if type(pane.get_current_working_dir) == "function" then
    local ok, cwd = pcall(function()
      return pane:get_current_working_dir()
    end)
    if ok and cwd then
      return helpers.uri_to_path(cwd)
    end
  end
  -- PaneInformation (format-tab-title)
  if pane.current_working_dir then
    return helpers.uri_to_path(pane.current_working_dir)
  end
  return nil
end

function M.classify(pane)
  local process = (pane.foreground_process_name or ""):lower()
  local title = (pane.title or ""):lower()
  local base = helpers.basename(process):lower()

  local function match(name)
    return process:find(name, 1, true)
      or title:find(name, 1, true)
      or base == name
  end

  for _, row in ipairs(PROCESS_MAP) do
    if match(row[1]) then
      return row[2], row[3], "process"
    end
  end

  if SHELLS[base] or match("zsh") or match("bash") or match("fish") then
    local cwd = M.pane_cwd(pane)
    local folder = helpers.basename(cwd or "")
    if folder ~= "" then
      local branch = helpers.git_branch(cwd)
      if branch then
        return icons.ui.branch, branch, "git"
      end
      return icons.ui.folder, folder, "cwd"
    end
    local icon = icons.process[base] or icons.process.zsh
    return icon, base:gsub("^%l", string.upper), "shell"
  end

  -- Fallback: use the process basename if we have one.
  if base ~= "" then
    return icons.process.default, base, "process"
  end
  return icons.process.default, "Terminal", "default"
end

return M
