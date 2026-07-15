-- Shared UI design tokens. Every float uses the same border + title style,
-- which is what makes the config feel like one coherent product.

local M = {}

M.border = "rounded"

-- A padded rounded border with breathing room on the sides.
M.border_padded = {
  { "╭", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╮", "FloatBorder" },
  { "│", "FloatBorder" },
  { "╯", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╰", "FloatBorder" },
  { "│", "FloatBorder" },
}

-- Standard floating-window options for handmade popups.
function M.float_opts(opts)
  return vim.tbl_deep_extend("force", {
    border = M.border,
    relative = "editor",
    style = "minimal",
  }, opts or {})
end

return M
