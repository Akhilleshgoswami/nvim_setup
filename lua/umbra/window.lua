-- One float factory. Every handmade popup opens through here, so they all
-- share the same border, title alignment, opacity, z-index and close behaviour.

local t = require("umbra.tokens")

local M = {}

-- Merge caller options over the Umbra float defaults.
function M.float(opts)
  return vim.tbl_deep_extend("force", {
    relative = "editor",
    style = "minimal",
    border = t.border,
    zindex = t.zindex.float,
    title_pos = t.title.pos,
  }, opts or {})
end

-- Wrap a title with the standard padding, e.g. " Health ".
function M.title(str)
  return t.title.prefix .. str .. t.title.suffix
end

-- Open `buf` in a standard float and wire the standard close keys.
function M.open(buf, opts)
  local win = vim.api.nvim_open_win(buf, true, M.float(opts))
  vim.wo[win].winblend = t.opacity.float
  for _, key in ipairs({ "q", "<esc>" }) do
    pcall(vim.keymap.set, "n", key, "<cmd>close<cr>", { buffer = buf, silent = true })
  end
  return win
end

return M
