-- Project task runner: run the project, tests, npm scripts and Docker
-- commands in an in-editor terminal (toggleterm), always from the project root.
-- Package manager and language are auto-detected from lockfiles / manifests.

local M = {}

local function root()
  local ok, r = pcall(function()
    return require("utils").root()
  end)
  return (ok and r) or (vim.uv or vim.loop).cwd()
end

local function has(file)
  return (vim.uv or vim.loop).fs_stat(root() .. "/" .. file) ~= nil
end

local function pkg_manager()
  if has("bun.lockb") then return "bun" end
  if has("pnpm-lock.yaml") then return "pnpm" end
  if has("yarn.lock") then return "yarn" end
  return "npm"
end

-- Run a shell command in a fresh horizontal terminal rooted at the project.
local function run(cmd, name)
  local Terminal = require("toggleterm.terminal").Terminal
  Terminal:new({
    cmd = cmd,
    dir = root(),
    direction = "horizontal",
    close_on_exit = false,
    display_name = name or "task",
    on_open = function(term)
      pcall(vim.keymap.set, "n", "q", "<cmd>close<cr>", { buffer = term.bufnr, silent = true })
    end,
  }):toggle(16)
  vim.notify(cmd, vim.log.levels.INFO, { title = "Run" })
end

local function none()
  vim.notify("No known task for this project", vim.log.levels.WARN, { title = "Run" })
end

function M.run_project()
  if has("package.json") then
    local pm = pkg_manager()
    run(("%s run dev 2>/dev/null || %s start"):format(pm, pm), "dev")
  elseif has("Cargo.toml") then
    run("cargo run", "cargo run")
  elseif has("go.mod") then
    run("go run .", "go run")
  elseif has("Makefile") then
    run("make", "make")
  elseif has("pyproject.toml") or has("requirements.txt") then
    run("python3 main.py", "python")
  else
    none()
  end
end

function M.run_tests()
  if has("package.json") then
    run(pkg_manager() .. " test", "test")
  elseif has("Cargo.toml") then
    run("cargo test", "cargo test")
  elseif has("go.mod") then
    run("go test ./...", "go test")
  elseif has("pyproject.toml") or has("requirements.txt") then
    run("pytest", "pytest")
  else
    none()
  end
end

function M.npm_scripts()
  local path = root() .. "/package.json"
  local f = io.open(path, "r")
  if not f then
    vim.notify("No package.json in project root", vim.log.levels.WARN, { title = "Run" })
    return
  end
  local content = f:read("*a")
  f:close()
  local ok, pkg = pcall(vim.json.decode, content)
  if not ok or type(pkg) ~= "table" or type(pkg.scripts) ~= "table" then
    vim.notify("No scripts found in package.json", vim.log.levels.WARN, { title = "Run" })
    return
  end
  local names = {}
  for name in pairs(pkg.scripts) do
    names[#names + 1] = name
  end
  table.sort(names)
  local pm = pkg_manager()
  vim.ui.select(names, {
    prompt = "npm script",
    format_item = function(n)
      return ("%-16s %s"):format(n, pkg.scripts[n])
    end,
  }, function(choice)
    if choice then
      run(pm .. " run " .. choice, choice)
    end
  end)
end

function M.docker()
  local cmds = {
    { "compose up", "docker compose up" },
    { "compose up -d", "docker compose up -d" },
    { "compose down", "docker compose down" },
    { "compose build", "docker compose build" },
    { "compose logs -f", "docker compose logs -f" },
    { "ps", "docker ps" },
    { "images", "docker images" },
    { "system prune", "docker system prune -f" },
  }
  vim.ui.select(cmds, {
    prompt = "Docker",
    format_item = function(item)
      return item[1]
    end,
  }, function(choice)
    if choice then
      run(choice[2], "docker")
    end
  end)
end

return M
