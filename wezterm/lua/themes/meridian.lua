-- Meridian theme for WezTerm (matches Neovim Meridian palette).
return {
  name = "meridian",
  colors = {
    foreground = "#aebbcf",
    background = "#1b1e23",
    cursor_bg = "#7c9fd6",
    cursor_fg = "#1b1e23",
    cursor_border = "#7c9fd6",
    selection_fg = "#aebbcf",
    selection_bg = "#2b3038",
    split = "#343a45",
    ansi = {
      "#1b1e23",
      "#d67d7d",
      "#82c39a",
      "#d6b878",
      "#7c9fd6",
      "#a880c2",
      "#6cb8ae",
      "#aebbcf",
    },
    brights = {
      "#68738f",
      "#e09090",
      "#95d0ab",
      "#e0c88a",
      "#90b0e0",
      "#b894d0",
      "#82c8be",
      "#c4d0e0",
    },
  },
  tab_bar = {
    background = "#1b1e23",
    active_tab = {
      bg_color = "#2b3038",
      fg_color = "#aebbcf",
      intensity = "Bold",
    },
    inactive_tab = {
      bg_color = "#1b1e23",
      fg_color = "#68738f",
    },
    inactive_tab_hover = {
      bg_color = "#2b3038",
      fg_color = "#7c9fd6",
    },
    new_tab = {
      bg_color = "#1b1e23",
      fg_color = "#68738f",
    },
    new_tab_hover = {
      bg_color = "#2b3038",
      fg_color = "#7c9fd6",
    },
  },
  ui = {
    tab_bg = "#1b1e23",
    tab_active_bg = "#2b3038",
    tab_active_fg = "#aebbcf",
    tab_inactive_fg = "#68738f",
    tab_hover_bg = "#2b3038",
    accent = "#7c9fd6",
    status_fg = "#7c9fd6",
  },
}
