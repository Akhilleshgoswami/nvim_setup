-- Loam — potting bench / root cellar (WezTerm canonical palette).
-- Slightly brighter than the dimmed Neovim loam editor theme (~7:1 in-buffer).
-- Neovim sync triggers reload; colors come from this module when theme = "loam".

return {
  name = "loam",
  colors = {
    foreground = "#d4c8ab",
    background = "#242019",
    cursor_bg = "#c07a3e",
    cursor_fg = "#242019",
    cursor_border = "#c07a3e",
    selection_fg = "#d4c8ab",
    selection_bg = "#332c21",
    split = "#3d3830",
    ansi = {
      "#2c271e", -- black
      "#a8453a", -- red / brick
      "#7a9457", -- green / moss
      "#c9a227", -- yellow / straw
      "#8a6a7a", -- blue slot → plum (no true blue in Loam)
      "#8a6a7a", -- magenta → plum
      "#7a9457", -- cyan → moss
      "#d4c8ab", -- white
    },
    brights = {
      "#8a7d64", -- bright black → fg_muted
      "#c07a3e", -- bright red → ember (louder than base error)
      "#9ab073", -- bright green
      "#dab73f", -- bright yellow
      "#a5859e", -- bright blue → lightened plum
      "#a5859e", -- bright magenta
      "#9ab073", -- bright cyan
      "#e8ddc5", -- bright white
    },
  },
  tab_bar = {
    background = "#242019",
    active_tab = {
      bg_color = "#2c271e",
      fg_color = "#d4c8ab",
      intensity = "Bold",
    },
    inactive_tab = {
      bg_color = "#242019",
      fg_color = "#8a7d64",
    },
    inactive_tab_hover = {
      bg_color = "#2c271e",
      fg_color = "#c9a227",
    },
    new_tab = {
      bg_color = "#242019",
      fg_color = "#8a7d64",
    },
    new_tab_hover = {
      bg_color = "#2c271e",
      fg_color = "#c07a3e",
    },
  },
  ui = {
    tab_bg = "#242019",
    tab_active_bg = "#2c271e",
    tab_active_fg = "#d4c8ab",
    tab_inactive_fg = "#8a7d64",
    tab_hover_bg = "#2c271e",
    accent = "#c07a3e",
    status_fg = "#c07a3e",
  },
}
