-- Solder theme for WezTerm (matches Neovim Solder palette).
return {
  name = "solder",
  colors = {
    foreground = "#b8ad9c",
    background = "#1a1815",
    cursor_bg = "#ab6f42",
    cursor_fg = "#1a1815",
    cursor_border = "#ab6f42",
    selection_fg = "#b8ad9c",
    selection_bg = "#282419",
    split = "#3a352b",
    ansi = {
      "#1a1815",
      "#a83e34",
      "#6c8060",
      "#ac8a2c",
      "#46796f",
      "#93624f",
      "#46796f",
      "#b8ad9c",
    },
    brights = {
      "#655f52",
      "#a83e34",
      "#7a9169",
      "#bc9a38",
      "#528a7f",
      "#a0705c",
      "#528a7f",
      "#cfc4b3",
    },
  },
  tab_bar = {
    background = "#1a1815",
    active_tab = {
      bg_color = "#282419",
      fg_color = "#b8ad9c",
      intensity = "Bold",
    },
    inactive_tab = {
      bg_color = "#1a1815",
      fg_color = "#655f52",
    },
    inactive_tab_hover = {
      bg_color = "#282419",
      fg_color = "#ac8a2c",
    },
    new_tab = {
      bg_color = "#1a1815",
      fg_color = "#655f52",
    },
    new_tab_hover = {
      bg_color = "#282419",
      fg_color = "#ab6f42",
    },
  },
  ui = {
    tab_bg = "#1a1815",
    tab_active_bg = "#282419",
    tab_active_fg = "#b8ad9c",
    tab_inactive_fg = "#655f52",
    tab_hover_bg = "#282419",
    accent = "#ab6f42",
    status_fg = "#ab6f42",
  },
}
