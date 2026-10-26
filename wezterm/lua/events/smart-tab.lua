-- Custom tab titles — process / cwd / git aware, themed via nvim-sync.

local sync = require("sync.nvim-sync")
local title = require("events.smart-title")

local M = {}

function M.setup(wezterm)
  wezterm.on("format-tab-title", function(tab, _tabs, _panes, _config, hover, max_width)
    local ui = sync.ui_colors(wezterm)
    local icon, label = title.classify(tab.active_pane)

    local bg, fg
    if tab.is_active then
      bg = ui.tab_active_bg
      fg = ui.tab_active_fg
    elseif hover then
      bg = ui.tab_hover_bg or ui.tab_active_bg
      fg = ui.tab_active_fg
    else
      bg = ui.tab_bg
      fg = ui.tab_inactive_fg
    end

    -- Soft "pill" feel with padding; truncate to tab_max_width.
    local text = "  " .. icon .. "  " .. label .. "  "
    if max_width and #text > max_width then
      text = wezterm.truncate_right(text, max_width - 1) .. "…"
    end

    return {
      { Background = { Color = bg } },
      { Foreground = { Color = fg } },
      { Attribute = { Intensity = tab.is_active and "Bold" or "Normal" } },
      { Text = text },
    }
  end)
end

return M
