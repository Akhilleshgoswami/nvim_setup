-- Umbra — soft blue-gray (matches Neovim Umbra palette).
-- Used only when colors/nvim-sync.lua is missing.

return {
  name = "umbra",
  builtin = "Catppuccin Mocha", -- WezTerm builtin fallback if needed
  colors = {
    foreground = "#E6EDF3",
    background = "#1A1E27",
    cursor_bg = "#E6EDF3",
    cursor_fg = "#1A1E27",
    cursor_border = "#E6EDF3",
    selection_bg = "#39445D",
    selection_fg = "#E6EDF3",
    split = "#3C475F",
    ansi = { "#1A1E27", "#F7768E", "#A3D977", "#F5C76A", "#82AAFF", "#C792EA", "#7FDBCA", "#E6EDF3" },
    brights = { "#8A93A8", "#F29EC2", "#B8E986", "#FAD07B", "#9BB8FF", "#D4A5F5", "#95E8D8", "#F0F3F8" },
  },
  ui = {
    tab_bg = "#202532",
    tab_active_bg = "#30384D",
    tab_active_fg = "#E6EDF3",
    tab_inactive_fg = "#8A93A8",
    tab_hover_bg = "#30384D",
    accent = "#82AAFF",
    status_fg = "#82AAFF",
  },
}
