-- Shared preload + re-attach for Treesitter and LSP.
-- Telescope, the dashboard, and session restore can all open a buffer before
-- lazy plugins finish setup — this closes that race.

local M = {}

local PRELOAD = { "nvim-treesitter", "nvim-lspconfig", "project.nvim" }

local SKIP_FT = {
  alpha = true,
  telescope = true,
  lazy = true,
  mason = true,
  notify = true,
  noice = true,
  ["neo-tree"] = true,
  oil = true,
  help = true,
  qf = true,
}

-- Servers we never auto-start (legacy dupes or optional extras).
local SKIP_LSP = { ts_ls = true, glint = true }

local configured_servers ---@type table<string, table>?

local function lsp_ready()
  return vim.g.umbra_lsp_ready == true
end

local function get_configured_servers()
  if not configured_servers and lsp_ready() then
    configured_servers = require("lsp.servers")
  end
  return configured_servers or {}
end

function M.preload()
  require("lazy").load({ plugins = PRELOAD })
end

local function skip_buf(buf)
  if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_buf_is_loaded(buf) then
    return true
  end
  if vim.bo[buf].buftype ~= "" and vim.bo[buf].buftype ~= "help" then
    return true
  end
  local ft = vim.bo[buf].filetype
  if ft == "" or SKIP_FT[ft] then
    return true
  end
  -- Telescope preview/prompt buffers: treesitter + conceal_line crashes while
  -- the preview reparses on every keystroke in find_files.
  if ft == "TelescopePrompt" or ft == "TelescopeResults" then
    return true
  end
  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    if vim.api.nvim_win_is_valid(win) then
      local winhl = vim.wo[win].winhl or ""
      if winhl:find("TelescopePreview") or winhl:find("TelescopePrompt") then
        return true
      end
    end
  end
  return false
end

function M.ensure_treesitter(buf)
  if vim.g.umbra_treesitter_ready ~= true then
    M.preload()
    vim.defer_fn(function()
      M.ensure_treesitter(buf)
    end, 50)
    return
  end
  if not package.loaded["nvim-treesitter"] then
    return
  end
  local configs = require("nvim-treesitter.configs")
  local parsers = require("nvim-treesitter.parsers")

  local bufs = buf and { buf } or vim.api.nvim_list_bufs()
  for _, b in ipairs(bufs) do
    if skip_buf(b) or vim.b[b].umbra_bigfile then
      goto continue
    end
    local lang = parsers.get_buf_lang(b)
    if lang and configs.is_enabled("highlight", lang, b) then
      -- Don't re-attach an active highlighter — re-parsing mid-update causes
      -- "attempt to call method 'range' (a nil value)" in conceal_line.
      if not vim.treesitter.highlighter.active[b] then
        pcall(configs.reattach_module, "highlight", b, lang)
      end
    end
    ::continue::
  end
end

local function servers_for_ft(ft)
  if not lsp_ready() then
    return {}
  end
  local map = require("mason-lspconfig.mappings").get_filetype_map()
  local candidates = map[ft] or {}
  local configured = get_configured_servers()
  local out = {}
  for _, name in ipairs(candidates) do
    -- Only Umbra-configured servers that mason-lspconfig already enabled.
    -- Never touch glint/denols/biome/etc. from the global filetype map.
    if configured[name] ~= nil and not SKIP_LSP[name] and vim.lsp.is_enabled(name) then
      out[#out + 1] = name
    end
  end
  return out
end

local function has_client(buf, name)
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf, name = name })) do
    if not client.is_stopped() then
      return true
    end
  end
  return false
end

local function start_server(buf, name)
  if has_client(buf, name) then
    return
  end
  -- Never vim.lsp.enable() here — that would spawn unconfigured servers
  -- like glint. Only start servers Umbra already registered + enabled.
  if not vim.lsp.is_enabled(name) then
    return
  end
  local config = vim.lsp.config[name]
  if not config then
    return
  end
  local cfg = vim.deepcopy(config)
  if type(cfg.root_dir) == "function" then
    cfg.root_dir(buf, function(root_dir)
      cfg.root_dir = root_dir
      vim.schedule(function()
        pcall(vim.lsp.start, cfg, { bufnr = buf })
      end)
    end)
  else
    pcall(vim.lsp.start, cfg, { bufnr = buf })
  end
end

function M.ensure_lsp(buf)
  if not lsp_ready() then
    M.preload()
    vim.defer_fn(function()
      M.ensure_lsp(buf)
    end, 100)
    return
  end

  local bufs = buf and { buf } or vim.api.nvim_list_bufs()
  for _, b in ipairs(bufs) do
    if skip_buf(b) then
      goto continue
    end
    local ft = vim.bo[b].filetype
    local expected = servers_for_ft(ft)
    if #expected == 0 then
      goto continue
    end

    local missing = vim.tbl_filter(function(name)
      return not has_client(b, name)
    end, expected)

    if #missing == 0 then
      goto continue
    end

    -- Neovim's built-in hook for already-open buffers.
    pcall(vim.cmd.doautoall, "nvim.lsp.enable FileType")

    for _, name in ipairs(missing) do
      if not has_client(b, name) then
        start_server(b, name)
      end
    end
    ::continue::
  end
end

function M.ensure_buffers(buf)
  M.ensure_treesitter(buf)
  M.ensure_lsp(buf)
end

function M.setup()
  local group = vim.api.nvim_create_augroup("umbra_intelligence", { clear = true })

  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "TelescopeFindPre",
    callback = function()
      M.preload()
      -- Tear down TS on preview buffers so conceal_line never runs there.
      vim.schedule(function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          for _, win in ipairs(vim.fn.win_findbuf(buf)) do
            if vim.api.nvim_win_is_valid(win) then
              local winhl = vim.wo[win].winhl or ""
              if winhl:find("TelescopePreview") then
                pcall(vim.treesitter.stop, buf)
              end
            end
          end
        end
      end)
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "TelescopePreviewerLoaded",
    callback = function()
      vim.schedule(function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          for _, win in ipairs(vim.fn.win_findbuf(buf)) do
            if vim.api.nvim_win_is_valid(win) and (vim.wo[win].winhl or ""):find("TelescopePreview") then
              pcall(vim.treesitter.stop, buf)
            end
          end
        end
      end)
    end,
  })

  vim.api.nvim_create_autocmd("SessionLoadPost", {
    group = group,
    callback = function()
      vim.schedule(function()
        M.preload()
        vim.defer_fn(function()
          M.ensure_buffers()
        end, 200)
      end)
    end,
  })

  vim.api.nvim_create_autocmd({ "FileType", "BufReadPost" }, {
    group = group,
    callback = function(args)
      if skip_buf(args.buf) then
        return
      end
      vim.schedule(function()
        M.ensure_buffers(args.buf)
      end)
    end,
  })

  -- LSP-only fallback when focusing a buffer that missed attach.
  vim.api.nvim_create_autocmd("BufWinEnter", {
    group = group,
    callback = function(args)
      if skip_buf(args.buf) then
        return
      end
      if #vim.lsp.get_clients({ bufnr = args.buf }) > 0 then
        return
      end
      vim.schedule(function()
        M.ensure_lsp(args.buf)
      end)
    end,
  })
end

return M
