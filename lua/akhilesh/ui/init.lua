---@class AkhileshUI
---Theme-adaptive design system layered on top of NvChad/base46.
local M = {}

M.border = "rounded"
M.winblend = 0
M.backdrop = 60
M.pumblend = 8

--- Powerline separators (NvChad vscode_colored style)
M.sep = {
  left = "",
  right = "",
  bar_left = "",
  bar_right = "",
}

-- Fallback palette only; real values come from active highlight groups.
M.palette = {
  bg = "#1e1e2e",
  bg_dark = "#181825",
  bg_float = "#1e1e2e",
  bg_muted = "#313244",
  bg_hover = "#45475a",
  bg_popup = "#1e1e2e",
  fg = "#cdd6f4",
  fg_muted = "#a6adc8",
  fg_dark = "#7f849c",
  border = "#585b70",
  border_active = "#89b4fa",
  blue = "#89b4fa",
  cyan = "#89dceb",
  green = "#a6e3a1",
  yellow = "#f9e2af",
  orange = "#fab387",
  red = "#f38ba8",
  purple = "#cba6f7",
  pink = "#f5c2e7",
  teal = "#94e2d5",
}

function M.hl(name, attr)
  local ok, h = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
  if not ok or not h[attr] then
    return nil
  end
  return string.format("#%06x", h[attr])
end

function M.colors()
  local p = M.palette
  return {
    bg = M.hl("Normal", "bg") or p.bg,
    bg_dark = M.hl("StatusLine", "bg") or M.hl("NormalNC", "bg") or p.bg_dark,
    bg_float = M.hl("NormalFloat", "bg") or p.bg_float,
    bg_muted = M.hl("CursorLine", "bg") or M.hl("Visual", "bg") or p.bg_muted,
    bg_hover = M.hl("Visual", "bg") or p.bg_hover,
    bg_popup = M.hl("Pmenu", "bg") or p.bg_popup,
    fg = M.hl("Normal", "fg") or p.fg,
    fg_muted = M.hl("Comment", "fg") or p.fg_muted,
    fg_dark = M.hl("LineNr", "fg") or p.fg_dark,
    border = M.hl("FloatBorder", "fg") or p.border,
    border_active = M.hl("WinSeparator", "fg") or M.hl("FloatBorder", "fg") or p.border_active,
    blue = M.hl("Function", "fg") or p.blue,
    cyan = M.hl("Keyword", "fg") or p.cyan,
    green = M.hl("String", "fg") or p.green,
    yellow = M.hl("Type", "fg") or p.yellow,
    orange = M.hl("Number", "fg") or p.orange,
    red = M.hl("DiagnosticError", "fg") or p.red,
    purple = M.hl("Statement", "fg") or p.purple,
    pink = p.pink,
    teal = p.teal,
  }
end

function M.float_opts(overrides)
  return vim.tbl_deep_extend("force", {
    border = M.border,
    style = "minimal",
    winblend = M.winblend,
    winhighlight = table.concat({
      "Normal:NormalFloat",
      "FloatBorder:FloatBorder",
      "FloatTitle:FloatTitle",
    }, ","),
  }, overrides or {})
end

function M.lualine_theme()
  local c = M.colors()
  return {
    normal = {
      a = { fg = c.bg_dark, bg = c.blue, gui = "bold" },
      b = { fg = c.fg, bg = c.bg_muted },
      c = { fg = c.fg_muted, bg = c.bg_dark },
    },
    insert = { a = { fg = c.bg_dark, bg = c.green, gui = "bold" } },
    visual = { a = { fg = c.bg_dark, bg = c.purple, gui = "bold" } },
    replace = { a = { fg = c.bg_dark, bg = c.red, gui = "bold" } },
    command = { a = { fg = c.bg_dark, bg = c.yellow, gui = "bold" } },
    terminal = { a = { fg = c.bg_dark, bg = c.cyan, gui = "bold" } },
    inactive = {
      a = { fg = c.fg_muted, bg = c.bg_dark },
      b = { fg = c.fg_muted, bg = c.bg_dark },
      c = { fg = c.fg_muted, bg = c.bg_dark },
    },
  }
end

function M.apply_highlights()
  local c = M.colors()
  local set = vim.api.nvim_set_hl

  -- Keep base editor groups controlled by NvChad/base46.
  -- Only style plugin/semantic groups in a theme-adaptive way.

  -- LSP / diagnostics fine tuning
  set(0, "LspInlayHint", { fg = c.fg_muted, bg = "NONE", italic = true })
  set(0, "LspCodeLens", { fg = c.fg_muted, bg = "NONE", italic = true })
  set(0, "DiagnosticVirtualTextError", { fg = c.red, bg = "NONE", italic = true })
  set(0, "DiagnosticVirtualTextWarn", { fg = c.yellow, bg = "NONE", italic = true })
  set(0, "DiagnosticVirtualTextInfo", { fg = c.cyan, bg = "NONE", italic = true })
  set(0, "DiagnosticVirtualTextHint", { fg = c.teal, bg = "NONE", italic = true })
  set(0, "DiagnosticSignError", { fg = c.red, bg = "NONE" })
  set(0, "DiagnosticSignWarn", { fg = c.yellow, bg = "NONE" })
  set(0, "DiagnosticSignInfo", { fg = c.cyan, bg = "NONE" })
  set(0, "DiagnosticSignHint", { fg = c.teal, bg = "NONE" })

  -- Blink completion
  set(0, "BlinkCmpMenu", { fg = c.fg, bg = c.bg_popup })
  set(0, "BlinkCmpMenuBorder", { fg = c.border_active, bg = c.bg_popup })
  set(0, "BlinkCmpDoc", { fg = c.fg, bg = c.bg_float })
  set(0, "BlinkCmpDocBorder", { fg = c.border_active, bg = c.bg_float })
  set(0, "BlinkCmpMenuSelection", { fg = c.blue, bg = c.bg_hover, bold = true })
  set(0, "BlinkCmpLabelMatch", { fg = c.yellow, bold = true })
  set(0, "BlinkCmpGhostText", { fg = c.fg_muted, italic = true })
  set(0, "BlinkCmpKindFunction", { fg = c.blue })
  set(0, "BlinkCmpKindMethod", { fg = c.blue })
  set(0, "BlinkCmpKindClass", { fg = c.yellow })
  set(0, "BlinkCmpKindVariable", { fg = c.cyan })
  set(0, "BlinkCmpKindKeyword", { fg = c.purple })
  set(0, "BlinkCmpSource", { fg = c.fg_muted })

  -- Notifications / noice-like popups
  set(0, "NotifyINFOBody", { bg = c.bg_float, fg = c.fg })
  set(0, "NotifyWARNBody", { bg = c.bg_float, fg = c.fg })
  set(0, "NotifyERRORBody", { bg = c.bg_float, fg = c.fg })
  set(0, "NotifyINFOBorder", { fg = c.blue })
  set(0, "NotifyWARNBorder", { fg = c.yellow })
  set(0, "NotifyERRORBorder", { fg = c.red })
  set(0, "NotifyBackground", { bg = c.bg_float })

  -- Which-key
  set(0, "WhichKey", { fg = c.cyan, bold = true })
  set(0, "WhichKeyGroup", { fg = c.purple, bold = true })
  set(0, "WhichKeyDesc", { fg = c.fg })
  set(0, "WhichKeySeparator", { fg = c.fg_muted })
  set(0, "WhichKeyFloat", { bg = c.bg_float })
  set(0, "WhichKeyBorder", { fg = c.border_active, bg = c.bg_float })

  -- Mason / Lazy
  set(0, "MasonNormal", { bg = c.bg_float, fg = c.fg })
  set(0, "MasonHeader", { bg = c.bg_muted, fg = c.blue, bold = true })
  set(0, "MasonHighlight", { fg = c.cyan })

  -- Dashboard
  set(0, "SnacksDashboardIcon", { fg = c.blue })
  set(0, "SnacksDashboardKey", { fg = c.cyan, bold = true })
  set(0, "SnacksDashboardDesc", { fg = c.fg_muted })
  set(0, "SnacksDashboardHeader", { fg = c.blue, bold = true })
  set(0, "SnacksDashboardFooter", { fg = c.fg_muted })
end

function M.setup()
  M.apply_highlights()
  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
      vim.schedule(M.apply_highlights)
    end,
  })
end

return M
