-- Right status: theme · workspace · cwd/process · battery · host · clock.

local sync = require("sync.nvim-sync")
local icons = require("utils.icons")
local helpers = require("utils.helpers")
local platform = require("utils.platform")
local title = require("events.smart-title")

local M = {}

local function battery_segment(wezterm, ui)
  local ok, batteries = pcall(wezterm.battery_info)
  if not ok or not batteries or #batteries == 0 then
    return {}
  end
  local b = batteries[1]
  local pct = math.floor((b.state_of_charge or 0) * 100)
  local glyph = (b.state == "Charging" or b.state == "Full") and icons.ui.battery_charging or icons.ui.battery
  return {
    { Foreground = { Color = ui.tab_inactive_fg or "#6c7086" } },
    { Text = icons.ui.separator },
    { Foreground = { Color = ui.status_fg or ui.accent } },
    { Text = " " .. glyph .. " " .. pct .. "% " },
  }
end

local function cwd_segment(pane, ui)
  local cwd = title.pane_cwd(pane)
  local folder = helpers.basename(cwd or "")
  if folder == "" then
    local _, label = title.classify(pane)
    folder = label
  end
  return {
    { Foreground = { Color = ui.tab_inactive_fg or "#6c7086" } },
    { Text = icons.ui.separator },
    { Foreground = { Color = ui.status_fg or ui.accent } },
    { Text = " " .. icons.ui.folder .. " " .. folder .. " " },
  }
end

local function concat(dst, src)
  for _, item in ipairs(src) do
    dst[#dst + 1] = item
  end
end

function M.setup(wezterm)
  wezterm.on("update-right-status", function(window, pane)
    local ui = sync.ui_colors(wezterm)
    local name = sync.current_theme(wezterm)
    local workspace = window:active_workspace()
    local date = wezterm.strftime("%a %H:%M")
    local host = platform.hostname()

    local cells = {
      { Foreground = { Color = ui.status_fg or ui.accent } },
      { Text = "  " .. name .. "  " },
    }

    if workspace and workspace ~= "" and workspace ~= "default" then
      concat(cells, {
        { Foreground = { Color = ui.tab_inactive_fg or "#6c7086" } },
        { Text = icons.ui.separator },
        { Foreground = { Color = ui.status_fg or ui.accent } },
        { Text = " " .. icons.ui.workspace .. " " .. workspace .. " " },
      })
    end

    concat(cells, cwd_segment(pane, ui))
    concat(cells, battery_segment(wezterm, ui))

    concat(cells, {
      { Foreground = { Color = ui.tab_inactive_fg or "#6c7086" } },
      { Text = icons.ui.separator },
      { Foreground = { Color = ui.status_fg or ui.accent } },
      { Text = " " .. icons.ui.host .. " " .. host .. " " },
      { Foreground = { Color = ui.tab_inactive_fg or "#6c7086" } },
      { Text = icons.ui.separator },
      { Foreground = { Color = ui.status_fg or ui.accent } },
      { Text = " " .. icons.ui.clock .. " " .. date .. "  " },
    })

    window:set_right_status(wezterm.format(cells))
  end)
end

return M
