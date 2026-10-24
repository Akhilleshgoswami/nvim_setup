--- Mason helpers: reliable uninstall + skip list so ensure_installed won't re-add.

local M = {}

local SKIP_FILE = vim.fn.stdpath("state") .. "/umbra-mason-skip.txt"

local function read_skip()
  local skip = {}
  if vim.fn.filereadable(SKIP_FILE) ~= 1 then
    return skip
  end
  for line in io.lines(SKIP_FILE) do
    local name = line:match("^%s*(%S+)")
    if name and name ~= "" then
      skip[name] = true
    end
  end
  return skip
end

local function write_skip(skip)
  vim.fn.mkdir(vim.fn.fnamemodify(SKIP_FILE, ":h"), "p")
  local lines = vim.tbl_keys(skip)
  table.sort(lines)
  vim.fn.writefile(lines, SKIP_FILE)
end

function M.skip_set()
  return read_skip()
end

function M.skip_add(name)
  local skip = read_skip()
  skip[name] = true
  write_skip(skip)
end

function M.skip_remove(name)
  local skip = read_skip()
  skip[name] = nil
  write_skip(skip)
end

function M.filter_ensure_installed(list)
  local skip = read_skip()
  return vim.tbl_filter(function(name)
    if type(name) == "table" then
      name = name[1]
    end
    return name and not skip[name]
  end, list)
end

local function mason_package_name(name)
  local ok, mappings = pcall(require, "mason-lspconfig.mappings")
  if ok then
    local map = mappings.get_mason_map().lspconfig_to_package
    if map[name] then
      return map[name]
    end
  end
  return name
end

local function stop_lsp(name)
  pcall(vim.lsp.enable, name, false)
  for _, client in ipairs(vim.lsp.get_clients()) do
    if client.name == name then
      pcall(vim.lsp.buf_detach_client, client.bufnr, client.id)
    end
  end
end

function M.uninstall(name, opts)
  opts = opts or {}
  name = mason_package_name(name)

  if not package.loaded["mason-registry"] then
    require("lazy").load({ plugins = { "mason.nvim" } })
  end

  local registry = require("mason-registry")
  registry.refresh(function()
    local pkg = registry.get_package(name)
    if not pkg:is_installed() then
      vim.notify(("Mason: %q is not installed"):format(name), vim.log.levels.WARN)
      return
    end

    stop_lsp(name)

    pkg:uninstall({}, function(success, result)
      if success then
        if opts.persist ~= false then
          M.skip_add(name)
        end
        vim.notify(
          ("Uninstalled %s (won't auto-reinstall — use :MasonReinstall %s to restore)"):format(name, name),
          vim.log.levels.INFO,
          { title = "Mason" }
        )
      else
        local msg = type(result) == "string" and result or vim.inspect(result)
        vim.notify(("Failed to uninstall %s: %s"):format(name, msg), vim.log.levels.ERROR, { title = "Mason" })
      end
    end)
  end)
end

function M.reinstall(name)
  name = mason_package_name(name)
  M.skip_remove(name)

  if not package.loaded["mason-registry"] then
    require("lazy").load({ plugins = { "mason.nvim" } })
  end

  local registry = require("mason-registry")
  registry.refresh(function()
    registry.get_package(name):install()
    vim.notify(("Reinstalling %s…"):format(name), vim.log.levels.INFO, { title = "Mason" })
  end)
end

function M.uninstall_picker()
  if not package.loaded["mason-registry"] then
    require("lazy").load({ plugins = { "mason.nvim" } })
  end

  require("mason-registry").refresh(function()
    local installed = require("mason-registry").get_installed_package_names()
    table.sort(installed)

    if #installed == 0 then
      vim.notify("No Mason packages installed", vim.log.levels.INFO)
      return
    end

    vim.ui.select(installed, { prompt = "Mason: uninstall package" }, function(choice)
      if choice then
        M.uninstall(choice)
      end
    end)
  end)
end

function M.setup_commands()
  vim.api.nvim_create_user_command("MasonUninstallSkip", function(opts)
    if opts.args == "" then
      M.uninstall_picker()
      return
    end
    for name in opts.args:gmatch("%S+") do
      M.uninstall(name)
    end
  end, {
    nargs = "*",
    complete = function()
      return pcall(require, "mason-registry") and require("mason-registry").get_installed_package_names() or {}
    end,
    desc = "Uninstall Mason package(s) and skip auto-reinstall",
  })

  vim.api.nvim_create_user_command("MasonReinstall", function(opts)
    if opts.args == "" then
      vim.notify("Usage: MasonReinstall <package>", vim.log.levels.WARN)
      return
    end
    M.reinstall(opts.args)
  end, {
    nargs = 1,
    desc = "Remove package from skip list and install again",
  })
end

return M
