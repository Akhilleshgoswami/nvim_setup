-- Umbra theme loader.
-- `require("themes.umbra").apply()` paints the whole editor. The palette is
-- exposed so statusline/bufferline/etc. can consume the exact same colors.

local M = {}

M.palette = require("themes.umbra.palette")

function M.apply()
  if vim.g.colors_name then
    vim.cmd("hi clear")
  end
  vim.o.termguicolors = true
  vim.o.background = "dark"
  vim.g.colors_name = "umbra"

  local p = M.palette
  local groups = require("themes.umbra.highlights")(p)
  local set_hl = vim.api.nvim_set_hl
  for group, spec in pairs(groups) do
    set_hl(0, group, spec)
  end

  -- Terminal ANSI palette (toggleterm, :terminal, lazygit)
  local t = p.terminal
  local ansi = {
    t.black, t.red, t.green, t.yellow, t.blue, t.magenta, t.cyan, t.white,
    t.bright_black, t.bright_red, t.bright_green, t.bright_yellow,
    t.bright_blue, t.bright_magenta, t.bright_cyan, t.bright_white,
  }
  for i, color in ipairs(ansi) do
    vim.g["terminal_color_" .. (i - 1)] = color
  end
end

-- lualine theme derived from the palette (kept here so colors never drift).
function M.lualine()
  local p = M.palette
  local a = p.accent
  local function seg(accent)
    return {
      a = { fg = p.bg.dark, bg = accent, gui = "bold" },
      b = { fg = p.fg.dim, bg = p.bg.overlay },
      c = { fg = p.fg.muted, bg = p.none },
    }
  end
  return {
    normal = seg(a.indigo),
    insert = seg(a.green),
    visual = seg(a.violet),
    replace = seg(a.rose),
    command = seg(a.sand),
    terminal = seg(a.teal),
    inactive = {
      a = { fg = p.fg.muted, bg = p.none },
      b = { fg = p.fg.muted, bg = p.none },
      c = { fg = p.fg.faint, bg = p.none },
    },
  }
end

return M
