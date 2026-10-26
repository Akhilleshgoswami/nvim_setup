-- Color utilities for theme composition.

local M = {}

--- Build WezTerm tab_bar colors from a sync/theme UI palette.
function M.tab_bar(ui, c)
  return {
    background = ui.tab_bg or c.background,
    active_tab = {
      bg_color = ui.tab_active_bg or c.background,
      fg_color = ui.tab_active_fg or c.foreground,
      intensity = "Bold",
    },
    inactive_tab = {
      bg_color = ui.tab_bg or c.background,
      fg_color = ui.tab_inactive_fg or c.foreground,
    },
    inactive_tab_hover = {
      bg_color = ui.tab_hover_bg or ui.tab_active_bg or c.background,
      fg_color = ui.tab_active_fg or c.foreground,
    },
    new_tab = {
      bg_color = ui.tab_bg or c.background,
      fg_color = ui.accent or c.foreground,
    },
    new_tab_hover = {
      bg_color = ui.tab_hover_bg or ui.tab_active_bg or c.background,
      fg_color = ui.accent or c.foreground,
    },
  }
end

--- Map a sync/theme color table into config.colors.
function M.to_wezterm_colors(c, ui, tab_bar_override)
  return {
    foreground = c.foreground,
    background = c.background,
    cursor_bg = c.cursor_bg,
    cursor_fg = c.cursor_fg,
    cursor_border = c.cursor_border,
    selection_bg = c.selection_bg,
    selection_fg = c.selection_fg,
    split = c.split,
    ansi = c.ansi,
    brights = c.brights,
    tab_bar = tab_bar_override or M.tab_bar(ui or {}, c),
  }
end

--- Build config.colors from a themes/*.lua module.
function M.from_theme(theme)
  local c = theme.colors
  return M.to_wezterm_colors(c, theme.ui, theme.tab_bar)
end

return M
