-- Font stack, size, and shaping.

local prefs = require("core.config")

local M = {}

function M.apply(config, wezterm)
  local f = prefs.fonts
  config.font = wezterm.font_with_fallback(f.families)
  config.font_size = f.size
  config.line_height = f.line_height
  config.cell_width = f.cell_width
  config.harfbuzz_features = f.harfbuzz
  config.freetype_load_target = "Light"
  config.freetype_render_target = "HorizontalLcd"
  config.font_rules = {
    {
      intensity = "Bold",
      italic = false,
      font = config.font,
    },
  }
  config.warn_about_missing_glyphs = false
end

return M
