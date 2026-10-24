--- Loam — Telescope highlights, layout, and devicon category colors.

local M = {}

--- Flat palette for plugin wiring (`p.fg`, `p.ember`, …).
function M.flat(p)
  p = p or require("themes.loam").resolved or require("themes.loam").base_palette
  return {
    fg = p.fg.base,
    fg_muted = p.fg.muted,
    bg = p.bg.base,
    bg_alt = p.bg.panel,
    bg_highlight = p.bg.cursorline,
    border = p.border,
    ember = p.accent.ember,
    moss = p.accent.moss,
    straw = p.accent.straw,
    clay = p.accent.clay,
    plum = p.accent.plum,
  }
end

function M.apply_highlights(p)
  local c = M.flat(p)
  local hl = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hl("TelescopeNormal", { fg = c.fg, bg = c.bg })
  hl("TelescopeBorder", { fg = c.border, bg = c.bg })
  hl("TelescopeTitle", { fg = c.ember, bold = true })
  hl("TelescopePromptNormal", { fg = c.fg, bg = c.bg_alt })
  hl("TelescopePromptBorder", { fg = c.border, bg = c.bg_alt })
  hl("TelescopePromptTitle", { fg = c.ember, bg = c.bg_alt, bold = true })
  hl("TelescopePromptPrefix", { fg = c.ember, bg = c.bg_alt })
  hl("TelescopePreviewBorder", { fg = c.border, bg = c.bg })
  hl("TelescopePreviewTitle", { fg = c.moss, bg = c.bg, bold = true })
  hl("TelescopeResultsTitle", { fg = c.moss, bg = c.bg, bold = true })
  hl("TelescopeResultsNumber", { fg = c.fg_muted })
  hl("TelescopeSelection", { fg = c.fg, bg = c.bg_highlight, bold = true })
  hl("TelescopeSelectionCaret", { fg = c.ember, bg = c.bg_highlight, bold = true })
  hl("TelescopeMatching", { fg = c.straw, bold = true })
end

function M.opts()
  local finder = require("themes.glyphs").finder("loam")
  return {
    defaults = {
      prompt_prefix = finder.prompt_prefix,
      selection_caret = finder.selection_caret,
      entry_prefix = "  ",
      multi_icon = "✓ ",
      path_display = { "truncate" },
      layout_strategy = "flex",
      layout_config = {
        horizontal = { preview_width = 0.55, results_width = 0.45 },
        width = 0.9,
        height = 0.85,
      },
      borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      sorting_strategy = "ascending",
      scroll_strategy = "cycle",
      winblend = 0,
    },
    pickers = {
      find_files = { theme = "ivy", hidden = true },
    },
  }
end

function M.devicons_opts(p)
  local c = M.flat(p)
  return {
    color_icons = true,
    override = {
      ts = { color = c.ember, name = "TypeScript" },
      tsx = { color = c.ember, name = "TypeScriptReact" },
      js = { color = c.ember, name = "JavaScript" },
      jsx = { color = c.ember, name = "JavaScriptReact" },
      json = { color = c.straw, name = "Json" },
      yml = { color = c.moss, name = "Yaml" },
      yaml = { color = c.moss, name = "Yaml" },
      conf = { color = c.fg_muted, name = "Conf" },
      env = { color = c.clay, name = "Env" },
      example = { color = c.fg_muted, name = "Example" },
    },
    override_by_filename = {
      ["docker-compose.yml"] = { color = c.moss, name = "DockerCompose" },
      ["eslint.config.js"] = { color = c.plum, name = "Eslint" },
      ["tsconfig.json"] = { color = c.straw, name = "TSConfig" },
      [".env.example"] = { color = c.fg_muted, name = "EnvExample" },
    },
  }
end

function M.apply_devicons(p)
  pcall(function()
    require("nvim-web-devicons").setup(M.devicons_opts(p))
  end)
end

return M
