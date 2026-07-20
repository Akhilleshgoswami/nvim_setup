--- Terminal ANSI palette application.

local M = {}

---@param palette table Resolved palette with `.terminal` table
---@param enabled? boolean
function M.apply(palette, enabled)
  if enabled == false then
    return
  end
  local t = palette.terminal
  local ansi = {
    t.black, t.red, t.green, t.yellow, t.blue, t.magenta, t.cyan, t.white,
    t.bright_black, t.bright_red, t.bright_green, t.bright_yellow,
    t.bright_blue, t.bright_magenta, t.bright_cyan, t.bright_white,
  }
  for i, color in ipairs(ansi) do
    vim.g["terminal_color_" .. (i - 1)] = color
  end
end

return M
