-- Small, dependency-free helpers used across the config.

local M = {}

M.icons = require("utils.icons")
M.ui = require("utils.ui")

-- ── Window maximize toggle (no plugin needed) ────────────────────
local maximize_state = { active = false, restore = nil }

function M.toggle_maximize()
  if maximize_state.active and maximize_state.restore then
    vim.cmd(maximize_state.restore)
    maximize_state.active = false
    maximize_state.restore = nil
  else
    if vim.fn.winnr("$") == 1 then
      return
    end
    maximize_state.restore = vim.fn.winrestcmd()
    vim.cmd("wincmd _")
    vim.cmd("wincmd |")
    maximize_state.active = true
  end
end

-- ── Buffer removal that preserves the window layout ──────────────
function M.bufremove(buf)
  buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf

  if vim.bo[buf].modified then
    local choice = vim.fn.confirm(
      ("Save changes to %q?"):format(vim.fn.bufname(buf)),
      "&Yes\n&No\n&Cancel"
    )
    if choice == 0 or choice == 3 then
      return
    end
    if choice == 1 then
      vim.cmd.write()
    end
  end

  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    vim.api.nvim_win_call(win, function()
      if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= buf then
        return
      end
      local alt = vim.fn.bufnr("#")
      if alt ~= buf and vim.fn.buflisted(alt) == 1 then
        vim.api.nvim_win_set_buf(win, alt)
        return
      end
      local ok = pcall(vim.cmd, "bprevious")
      if ok and buf ~= vim.api.nvim_win_get_buf(win) then
        return
      end
      vim.api.nvim_win_set_buf(win, vim.api.nvim_create_buf(true, false))
    end)
  end

  if vim.api.nvim_buf_is_valid(buf) then
    pcall(vim.cmd, "bdelete! " .. buf)
  end
end

function M.delete_other_buffers()
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and vim.bo[buf].buflisted and not vim.bo[buf].modified then
      M.bufremove(buf)
    end
  end
end

-- ── Config reload ────────────────────────────────────────────────
function M.reload()
  for name, _ in pairs(package.loaded) do
    if name:match("^core")
      or name:match("^themes")
      or name:match("^utils")
      or name:match("^umbra")
      or name:match("^features")
      or name:match("^lsp") then
      package.loaded[name] = nil
    end
  end
  require("core.options")
  require("core.autocmds")
  require("core.keymaps")
  require("features.theme").load_saved()
  require("features.intelligence").setup()
  vim.notify("Umbra config reloaded", vim.log.levels.INFO, { title = "Umbra" })
end

-- Convenience: LSP-aware root directory of the current buffer.
function M.root()
  local buf = vim.api.nvim_get_current_buf()
  local markers = { ".git", "package.json", "go.mod", "Cargo.toml", "pyproject.toml" }
  local path = vim.api.nvim_buf_get_name(buf)
  path = path ~= "" and vim.fs.dirname(path) or vim.uv.cwd()
  local found = vim.fs.find(markers, { path = path, upward = true })[1]
  return found and vim.fs.dirname(found) or (vim.uv.cwd() or path)
end

return M
