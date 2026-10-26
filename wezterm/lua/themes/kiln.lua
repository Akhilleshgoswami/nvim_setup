-- Kiln theme for WezTerm (matches Neovim Kiln palette).
return {
  name = "kiln",
  colors = {
    foreground = "#c9b8a4",
    background = "#1c1814",
    cursor_bg = "#c47a4a",
    cursor_fg = "#1c1814",
    cursor_border = "#c47a4a",
    selection_fg = "#c9b8a4",
    selection_bg = "#28231d",
    split = "#3a332c",
    ansi = {
      "#2a251f",
      "#b85c4a",
      "#7a9a78",
      "#b8965c",
      "#8a7a88",
      "#a87870",
      "#93ab8f",
      "#c9b8a4",
    },
    brights = {
      "#8a7c6c",
      "#c47a4a",
      "#8fae8b",
      "#cdae76",
      "#a394a0",
      "#bd918a",
      "#a8c0a4",
      "#e0d3c0",
    },
  },
  tab_bar = {
    background = "#1c1814",
    active_tab = {
      bg_color = "#28231d",
      fg_color = "#c9b8a4",
      intensity = "Bold",
    },
    inactive_tab = {
      bg_color = "#1c1814",
      fg_color = "#8a7c6c",
    },
    inactive_tab_hover = {
      bg_color = "#28231d",
      fg_color = "#b8965c",
    },
    new_tab = {
      bg_color = "#1c1814",
      fg_color = "#8a7c6c",
    },
    new_tab_hover = {
      bg_color = "#28231d",
      fg_color = "#c47a4a",
    },
  },
  ui = {
    tab_bg = "#1c1814",
    tab_active_bg = "#28231d",
    tab_active_fg = "#c9b8a4",
    tab_inactive_fg = "#8a7c6c",
    tab_hover_bg = "#28231d",
    accent = "#c47a4a",
    status_fg = "#c47a4a",
  },
}
