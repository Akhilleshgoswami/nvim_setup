--- Solder — circuit board under a loupe (substrate · silkscreen · copper traces).
---
--- Syntax (5 accents):
---   functions → copper      keywords → via-teal
---   strings   → mask-green  types → resistor-gold
---   constants → resistor-brown   comments → fg_muted (no accent)
---   variables / punctuation → silkscreen (undecorated)
---
--- Usage: vim.cmd.colorscheme("solder")

local M = {}

M.base_palette = require("themes.solder.palette")
M.palette = M.base_palette
M.resolved = nil

function M.setup() end

local function paint(p)
  local c = {
    bg = p.bg.base,
    bg_dim = p.bg.dark,
    bg_float = p.bg.float,
    bg_alt = p.bg.panel,
    bg_hl = p.bg.cursorline,
    bg_select = p.bg.active,
    bg_search = p.bg.search,
    fg = p.fg.base,
    fg_dim = p.fg.dim,
    fg_muted = p.fg.muted,
    line_nr = p.fg.faint,
    copper = p.accent.copper,
    teal = p.accent.teal,
    green = p.accent.green,
    gold = p.accent.gold,
    brown = p.accent.brown,
    diode = p.diag.error,
    border = p.border,
    none = p.none,
  }

  local hl = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  local function trace_hl(fg, sp)
    return {
      fg = fg,
      bg = c.bg_alt,
      underline = sp ~= nil,
      sp = sp,
    }
  end

  hl("StatusLine", { fg = c.fg_muted, bg = c.bg_alt })
  hl("StatusLineNC", { fg = c.fg_muted, bg = c.bg_alt })
  -- Statusline segments: one hl group per component; gaps break the underline rail.
  hl("StSolderGap", { fg = c.bg_alt, bg = c.bg_alt })
  hl("StSolderMode", trace_hl(c.copper, c.copper))
  hl("StSolderModeInsert", trace_hl(c.teal, c.teal))
  hl("StSolderModeVisual", trace_hl(c.gold, c.gold))
  hl("StSolderModeReplace", trace_hl(c.diode, c.diode))
  hl("StSolderModeCommand", trace_hl(c.green, c.green))
  hl("StSolderModeTerminal", trace_hl(c.brown, c.brown))
  hl("StSolderGit", trace_hl(c.gold, c.gold))
  hl("StSolderFile", { fg = c.fg, bg = c.bg_alt })
  hl("StSolderLocation", { fg = c.fg_muted, bg = c.bg_alt })

  -- ===== Base editor UI =====
  hl("Normal", { fg = c.fg, bg = c.bg })
  hl("NormalFloat", { fg = c.fg, bg = c.bg_float })
  hl("NormalNC", { fg = c.fg, bg = c.bg })
  hl("FloatBorder", { fg = c.border, bg = c.bg_float })
  hl("FloatTitle", { fg = c.copper, bg = c.bg_float })
  hl("Cursor", { fg = c.bg, bg = c.fg })
  hl("CursorLine", { bg = c.bg_hl })
  hl("CursorLineNr", { fg = c.copper, bold = true })
  hl("LineNr", { fg = c.fg_muted })
  hl("SignColumn", { bg = c.bg })
  hl("ColorColumn", { bg = c.bg_hl })
  hl("Visual", { bg = c.bg_hl })
  hl("VisualNOS", { bg = c.bg_hl })
  hl("Search", { bg = c.gold, fg = c.bg })
  hl("IncSearch", { bg = c.copper, fg = c.bg })
  hl("CurSearch", { bg = c.copper, fg = c.bg })
  hl("Substitute", { bg = c.diode, fg = c.bg })
  hl("MatchParen", { fg = c.copper })
  hl("Pmenu", { fg = c.fg, bg = c.bg_float })
  hl("PmenuSel", { fg = c.bg, bg = c.copper })
  hl("PmenuSbar", { bg = c.bg_alt })
  hl("PmenuThumb", { bg = c.border })
  hl("WinSeparator", { fg = c.border, bg = c.none })
  hl("VertSplit", { fg = c.border, bg = c.none })
  hl("TabLine", { fg = c.fg_muted, bg = c.bg_alt })
  hl("TabLineSel", { fg = c.copper, bg = c.bg_hl })
  hl("TabLineFill", { bg = c.bg_alt })
  hl("Folded", { fg = c.fg_muted, bg = c.bg_alt })
  hl("FoldColumn", { fg = c.fg_muted, bg = c.bg })
  hl("NonText", { fg = c.border })
  hl("Whitespace", { fg = c.border })
  hl("Directory", { fg = c.gold })
  hl("Title", { fg = c.copper })
  hl("ErrorMsg", { fg = c.diode })
  hl("WarningMsg", { fg = c.gold })
  hl("ModeMsg", { fg = c.fg_muted })
  hl("Question", { fg = c.gold })
  hl("MoreMsg", { fg = c.green })
  hl("QuickFixLine", { bg = c.bg_hl })
  hl("WildMenu", { fg = c.bg, bg = c.copper })

  -- ===== Syntax =====
  hl("Comment", { fg = c.fg_muted, italic = true })
  hl("Constant", { fg = c.brown })
  hl("String", { fg = c.green })
  hl("Character", { fg = c.green })
  hl("Number", { fg = c.brown })
  hl("Boolean", { fg = c.brown })
  hl("Float", { fg = c.brown })
  hl("Identifier", { fg = c.fg })
  hl("Function", { fg = c.copper })
  hl("Statement", { fg = c.teal })
  hl("Conditional", { fg = c.teal })
  hl("Repeat", { fg = c.teal })
  hl("Label", { fg = c.teal })
  hl("Operator", { fg = c.fg })
  hl("Keyword", { fg = c.teal })
  hl("Exception", { fg = c.diode })
  hl("PreProc", { fg = c.teal })
  hl("Include", { fg = c.teal })
  hl("Define", { fg = c.teal })
  hl("Macro", { fg = c.teal })
  hl("Type", { fg = c.gold })
  hl("StorageClass", { fg = c.gold })
  hl("Structure", { fg = c.gold })
  hl("Typedef", { fg = c.gold })
  hl("Special", { fg = c.brown })
  hl("SpecialChar", { fg = c.brown })
  hl("Tag", { fg = c.teal })
  hl("Delimiter", { fg = c.fg })
  hl("Underlined", { fg = c.brown, underline = true })
  hl("Ignore", { fg = c.line_nr })
  hl("Todo", { fg = c.bg, bg = c.gold })
  hl("Error", { fg = c.diode })

  -- ===== Treesitter =====
  hl("@variable", { fg = c.fg })
  hl("@variable.builtin", { fg = c.brown, italic = true })
  hl("@variable.parameter", { fg = c.fg, italic = true })
  hl("@variable.member", { fg = c.fg })
  hl("@property", { fg = c.fg })
  hl("@field", { fg = c.fg })
  hl("@constant", { fg = c.brown })
  hl("@constant.builtin", { fg = c.brown })
  hl("@string", { fg = c.green })
  hl("@string.escape", { fg = c.gold })
  hl("@string.special", { fg = c.gold })
  hl("@character", { fg = c.green })
  hl("@number", { fg = c.brown })
  hl("@boolean", { fg = c.brown })
  hl("@function", { fg = c.copper })
  hl("@function.call", { fg = c.copper })
  hl("@function.builtin", { fg = c.copper, italic = true })
  hl("@function.macro", { fg = c.teal })
  hl("@function.method", { fg = c.copper })
  hl("@method", { fg = c.copper })
  hl("@method.call", { fg = c.copper })
  hl("@constructor", { fg = c.gold })
  hl("@keyword", { fg = c.teal })
  hl("@keyword.function", { fg = c.teal })
  hl("@keyword.return", { fg = c.teal })
  hl("@keyword.operator", { fg = c.teal })
  hl("@keyword.import", { fg = c.teal })
  hl("@keyword.modifier", { fg = c.teal })
  hl("@keyword.type", { fg = c.teal })
  hl("@conditional", { fg = c.teal })
  hl("@repeat", { fg = c.teal })
  hl("@type", { fg = c.gold })
  hl("@type.builtin", { fg = c.gold, italic = true })
  hl("@type.definition", { fg = c.gold })
  hl("@attribute", { fg = c.teal })
  hl("@namespace", { fg = c.gold })
  hl("@module", { fg = c.gold })
  hl("@operator", { fg = c.fg })
  hl("@punctuation.delimiter", { fg = c.fg })
  hl("@punctuation.bracket", { fg = c.fg })
  hl("@punctuation.special", { fg = c.fg })
  hl("@comment", { fg = c.fg_muted, italic = true })
  hl("@comment.todo", { fg = c.bg, bg = c.gold })
  hl("@tag", { fg = c.teal })
  hl("@tag.attribute", { fg = c.gold, italic = true })
  hl("@tag.delimiter", { fg = c.fg })
  hl("@markup.heading", { fg = c.copper })
  hl("@markup.strong", { fg = c.fg })
  hl("@markup.italic", { fg = c.fg, italic = true })
  hl("@markup.link", { fg = c.brown, underline = true })
  hl("@markup.raw", { fg = c.green })

  -- ===== LSP semantic tokens =====
  hl("@lsp.type.class", { link = "@type" })
  hl("@lsp.type.decorator", { fg = c.teal })
  hl("@lsp.type.enum", { fg = c.gold })
  hl("@lsp.type.enumMember", { link = "@constant" })
  hl("@lsp.type.function", { link = "@function" })
  hl("@lsp.type.interface", { fg = c.gold, italic = true })
  hl("@lsp.type.macro", { link = "@function.macro" })
  hl("@lsp.type.method", { link = "@function.method" })
  hl("@lsp.type.namespace", { link = "@namespace" })
  hl("@lsp.type.parameter", { link = "@variable.parameter" })
  hl("@lsp.type.property", { link = "@property" })
  hl("@lsp.type.struct", { link = "@type" })
  hl("@lsp.type.type", { link = "@type" })
  hl("@lsp.type.typeParameter", { fg = c.gold, italic = true })
  hl("@lsp.type.variable", { link = "@variable" })
  hl("@lsp.type.keyword", { link = "@keyword" })
  hl("@lsp.type.string", { link = "@string" })
  hl("@lsp.type.number", { link = "@number" })
  hl("@lsp.type.operator", { link = "@operator" })
  hl("@lsp.type.comment", { link = "@comment" })
  hl("@lsp.type.event", { fg = c.brown })
  hl("@lsp.type.modifier", { link = "@keyword.modifier" })
  hl("@lsp.type.regexp", { fg = c.gold })
  hl("@lsp.typemod.function.defaultLibrary", { link = "@function.builtin" })
  hl("@lsp.typemod.variable.defaultLibrary", { link = "@variable.builtin" })
  hl("@lsp.typemod.variable.readonly", { fg = c.brown })
  hl("@lsp.typemod.variable.constant", { fg = c.brown })
  hl("@lsp.typemod.method.defaultLibrary", { link = "@function.builtin" })
  hl("@lsp.typemod.class.defaultLibrary", { fg = c.gold, italic = true })
  hl("@lsp.mod.readonly", { italic = true })
  hl("@lsp.mod.deprecated", { strikethrough = true })
  hl("@lsp.mod.async", { italic = true })
  hl("@lsp.mod.static", { italic = true })

  -- ===== Diagnostics =====
  hl("DiagnosticError", { fg = c.diode })
  hl("DiagnosticWarn", { fg = c.gold })
  hl("DiagnosticInfo", { fg = c.teal })
  hl("DiagnosticHint", { fg = c.teal })
  hl("DiagnosticOk", { fg = c.green })
  hl("DiagnosticUnderlineError", { undercurl = true, sp = c.diode })
  hl("DiagnosticUnderlineWarn", { undercurl = true, sp = c.gold })
  hl("DiagnosticUnderlineInfo", { undercurl = true, sp = c.teal })
  hl("DiagnosticUnderlineHint", { undercurl = true, sp = c.teal })
  hl("DiagnosticVirtualTextError", { fg = c.diode, bg = c.none })
  hl("DiagnosticVirtualTextWarn", { fg = c.gold, bg = c.none })
  hl("DiagnosticVirtualTextInfo", { fg = c.teal, bg = c.none })
  hl("DiagnosticVirtualTextHint", { fg = c.teal, bg = c.none })
  hl("LspReferenceText", { bg = c.bg_select })
  hl("LspReferenceRead", { bg = c.bg_select })
  hl("LspReferenceWrite", { bg = c.bg_select, underline = true })
  hl("LspInlayHint", { fg = c.fg_muted, bg = c.bg_hl, italic = true })
  hl("LspSignatureActiveParameter", { fg = c.gold })

  -- ===== Git / gitsigns =====
  hl("GitSignsAdd", { fg = c.green })
  hl("GitSignsChange", { fg = c.gold })
  hl("GitSignsDelete", { fg = c.diode })
  hl("GitSignsChangedelete", { fg = c.gold })
  hl("GitSignsTopdelete", { fg = c.diode })
  hl("GitSignsUntracked", { fg = c.teal })
  hl("DiffAdd", { fg = c.green, bg = c.bg_hl })
  hl("DiffChange", { fg = c.gold, bg = c.bg_hl })
  hl("DiffDelete", { fg = c.diode, bg = c.bg_hl })
  hl("DiffText", { fg = c.copper, bg = c.bg_select })
  hl("Added", { fg = c.green })
  hl("Changed", { fg = c.gold })
  hl("Removed", { fg = c.diode })

  -- ===== Telescope (⊙ prefix via themes.glyphs) =====
  hl("TelescopeNormal", { fg = c.fg, bg = c.bg_float })
  hl("TelescopeBorder", { fg = c.border, bg = c.bg_float })
  hl("TelescopePromptNormal", { fg = c.fg, bg = c.bg_alt })
  hl("TelescopePromptBorder", { fg = c.border, bg = c.bg_alt })
  hl("TelescopePromptTitle", { fg = c.copper, bg = c.bg_alt })
  hl("TelescopePromptPrefix", { fg = c.copper, bg = c.bg_alt })
  hl("TelescopePreviewTitle", { fg = c.green, bg = c.bg_float })
  hl("TelescopeResultsTitle", { fg = c.gold, bg = c.bg_float })
  hl("TelescopeSelection", { bg = c.bg_select })
  hl("TelescopeSelectionCaret", { fg = c.copper, bg = c.bg_select })
  hl("TelescopeMatching", { fg = c.copper })

  -- ===== neo-tree =====
  hl("NeoTreeNormal", { fg = c.fg, bg = c.bg })
  hl("NeoTreeNormalNC", { fg = c.fg, bg = c.bg })
  hl("NeoTreeDirectoryIcon", { fg = c.gold })
  hl("NeoTreeDirectoryName", { fg = c.fg })
  hl("NeoTreeRootName", { fg = c.copper })
  hl("NeoTreeFileName", { fg = c.fg })
  hl("NeoTreeFileIcon", { fg = c.fg_muted })
  hl("NeoTreeFileNameOpened", { fg = c.fg })
  hl("NeoTreeIndentMarker", { fg = c.border })
  hl("NeoTreeGitAdded", { fg = c.green })
  hl("NeoTreeGitModified", { fg = c.gold })
  hl("NeoTreeGitDeleted", { fg = c.diode })
  hl("NeoTreeGitUntracked", { fg = c.teal })
  hl("NeoTreeGitConflict", { fg = c.diode })
  hl("NeoTreeFloatBorder", { fg = c.border, bg = c.bg_float })

  -- ===== blink.cmp =====
  hl("BlinkCmpMenu", { fg = c.fg, bg = c.bg_float })
  hl("BlinkCmpMenuBorder", { fg = c.border, bg = c.bg_float })
  hl("BlinkCmpMenuSelection", { fg = c.bg, bg = c.copper })
  hl("BlinkCmpLabel", { fg = c.fg })
  hl("BlinkCmpLabelMatch", { fg = c.copper })
  hl("BlinkCmpLabelDeprecated", { fg = c.fg_muted, strikethrough = true })
  hl("BlinkCmpLabelDetail", { fg = c.fg_muted })
  hl("BlinkCmpLabelDescription", { fg = c.fg_muted })
  hl("BlinkCmpKind", { fg = c.gold })
  hl("BlinkCmpSource", { fg = c.fg_muted })
  hl("BlinkCmpGhostText", { fg = c.fg_muted, italic = true })
  hl("BlinkCmpDoc", { fg = c.fg, bg = c.bg_float })
  hl("BlinkCmpDocBorder", { fg = c.border, bg = c.bg_float })
  hl("BlinkCmpSignatureHelp", { fg = c.fg, bg = c.bg_float })
  hl("BlinkCmpSignatureHelpBorder", { fg = c.border, bg = c.bg_float })
  hl("BlinkCmpSignatureHelpActiveParameter", { fg = c.gold })

  local kinds = {
    Text = c.fg_dim,
    Method = c.copper,
    Function = c.copper,
    Constructor = c.gold,
    Field = c.fg,
    Variable = c.fg,
    Class = c.gold,
    Interface = c.gold,
    Module = c.fg,
    Property = c.fg,
    Unit = c.gold,
    Value = c.brown,
    Enum = c.gold,
    Keyword = c.teal,
    Snippet = c.teal,
    Color = c.brown,
    File = c.fg,
    Reference = c.fg,
    Folder = c.gold,
    EnumMember = c.brown,
    Constant = c.brown,
    Struct = c.gold,
    Event = c.gold,
    Operator = c.fg_dim,
    TypeParameter = c.gold,
    Namespace = c.fg,
    Package = c.fg,
    String = c.green,
    Number = c.brown,
    Boolean = c.brown,
    Array = c.teal,
    Object = c.teal,
    Key = c.fg,
    Null = c.fg_muted,
  }
  for kind, color in pairs(kinds) do
    hl("BlinkCmpKind" .. kind, { fg = color })
    hl("CmpItemKind" .. kind, { fg = color })
    hl("DropBarKind" .. kind, { fg = color })
    hl("DropBarIconKind" .. kind, { fg = color })
    hl("NavicIcons" .. kind, { fg = color })
    hl("Aerial" .. kind .. "Icon", { fg = color })
  end

  -- ===== dropbar / aerial / trouble =====
  hl("DropBarIconUISeparator", { fg = c.fg_muted })
  hl("DropBarMenuHoverEntry", { bg = c.bg_select })
  hl("DropBarMenuCurrentContext", { fg = c.fg })
  hl("NavicText", { fg = c.fg_dim })
  hl("NavicSeparator", { fg = c.fg_muted })
  hl("AerialLine", { bg = c.bg_select })
  hl("TroubleNormal", { fg = c.fg, bg = c.bg_dim })
  hl("TroubleText", { fg = c.fg })
  hl("TroubleCount", { fg = c.brown, bg = c.bg_select })

  -- ===== indent-blankline =====
  hl("IblIndent", { fg = c.bg_hl })
  hl("IblScope", { fg = c.fg_muted })

  -- ===== which-key =====
  hl("WhichKey", { fg = c.copper })
  hl("WhichKeyGroup", { fg = c.gold })
  hl("WhichKeyDesc", { fg = c.fg })
  hl("WhichKeySeparator", { fg = c.fg_muted })
  hl("WhichKeyFloat", { bg = c.bg_float })
  hl("WhichKeyBorder", { fg = c.border, bg = c.bg_float })

  -- ===== noice / notify =====
  hl("NotifyBackground", { bg = c.bg_float })
  hl("NotifyERRORBorder", { fg = c.diode })
  hl("NotifyWARNBorder", { fg = c.gold })
  hl("NotifyINFOBorder", { fg = c.teal })
  hl("NotifyDEBUGBorder", { fg = c.fg_muted })
  hl("NotifyTRACEBorder", { fg = c.teal })
  hl("NotifyERRORTitle", { fg = c.diode })
  hl("NotifyWARNTitle", { fg = c.gold })
  hl("NotifyINFOTitle", { fg = c.teal })
  hl("NoiceCmdlinePopup", { fg = c.fg, bg = c.bg_float })
  hl("NoiceCmdlinePopupBorder", { fg = c.border, bg = c.bg_float })
  hl("NoiceCmdlinePopupTitle", { fg = c.copper })
  hl("NoiceCmdlineIcon", { fg = c.copper })

  -- ===== flash / illuminate =====
  hl("FlashBackdrop", { fg = c.fg_muted })
  hl("FlashMatch", { fg = c.bg, bg = c.copper })
  hl("FlashCurrent", { fg = c.bg, bg = c.gold })
  hl("FlashLabel", { fg = c.bg, bg = c.green })
  hl("IlluminatedWordText", { bg = c.bg_select })
  hl("IlluminatedWordRead", { bg = c.bg_select })
  hl("IlluminatedWordWrite", { bg = c.bg_select, underline = true })

  -- ===== alpha / misc =====
  hl("AlphaHeader", { fg = c.copper })
  hl("AlphaButtons", { fg = c.gold })
  hl("AlphaShortcut", { fg = c.green })
  hl("AlphaFooter", { fg = c.fg_muted })
  hl("MiniIndentscopeSymbol", { fg = c.fg_muted })
  hl("FidgetTitle", { fg = c.copper })
  hl("FidgetTask", { fg = c.fg_dim })
end

function M.apply()
  vim.cmd("hi clear")
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end
  vim.o.termguicolors = true
  vim.o.background = "dark"
  vim.g.colors_name = "solder"

  M.resolved = vim.deepcopy(M.base_palette)
  M.palette = M.resolved
  paint(M.resolved)

  require("themes.umbra.terminal").apply(M.resolved, true)

  pcall(function()
    package.loaded["umbra.color"] = nil
    require("umbra.color")
  end)

  pcall(function()
    require("themes.glyphs").apply("solder")
  end)
end

--- Lualine base theme — flat panel, muted fallback; segments use StSolder* groups.
function M.lualine()
  local p = M.resolved or M.palette
  local panel = p.bg.panel
  local muted = { bg = panel, fg = p.fg.muted }

  return {
    normal = { a = muted, b = muted, c = muted },
    insert = { a = muted, b = muted, c = muted },
    visual = { a = muted, b = muted, c = muted },
    replace = { a = muted, b = muted, c = muted },
    command = { a = muted, b = muted, c = muted },
    terminal = { a = muted, b = muted, c = muted },
    inactive = { a = muted, b = muted, c = muted },
  }
end

local MODE_HL = {
  n = "StSolderMode",
  no = "StSolderMode",
  i = "StSolderModeInsert",
  ic = "StSolderModeInsert",
  v = "StSolderModeVisual",
  V = "StSolderModeVisual",
  ["\22"] = "StSolderModeVisual",
  c = "StSolderModeCommand",
  cv = "StSolderModeCommand",
  ce = "StSolderModeCommand",
  R = "StSolderModeReplace",
  Rv = "StSolderModeReplace",
  r = "StSolderModeReplace",
  rm = "StSolderModeReplace",
  t = "StSolderModeTerminal",
}

function M.statusline_mode_hl()
  return MODE_HL[vim.fn.mode()] or "StSolderMode"
end

local function gap()
  return { function()
    return "  "
  end, color = "StSolderGap" }
end

--- Per-segment lualine layout: gapped trace underlines, role-colored text.
function M.lualine_sections(icons)
  return {
    lualine_a = {
      {
        "mode",
        fmt = function(s)
          return s:sub(1, 3):upper()
        end,
        color = M.statusline_mode_hl,
        padding = { left = 1, right = 1 },
      },
      gap(),
    },
    lualine_b = {
      {
        "branch",
        icon = icons.git.branch,
        color = "StSolderGit",
        padding = { left = 1, right = 1 },
      },
      {
        "diff",
        symbols = {
          added = icons.git.added .. " ",
          modified = icons.git.modified .. " ",
          removed = icons.git.removed .. " ",
        },
        color = "StSolderGit",
        padding = { left = 0, right = 1 },
      },
      gap(),
    },
    lualine_c = {
      {
        "filename",
        path = 1,
        symbols = {
          modified = "  " .. icons.ui.modified,
          readonly = "  " .. icons.ui.lock,
          unnamed = "[No Name]",
        },
        color = "StSolderFile",
        padding = { left = 1, right = 1 },
      },
      {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        symbols = {
          error = icons.diagnostics.Error .. " ",
          warn = icons.diagnostics.Warn .. " ",
          info = icons.diagnostics.Info .. " ",
          hint = icons.diagnostics.Hint .. " ",
        },
        color = "StSolderFile",
        padding = { left = 0, right = 1 },
      },
    },
    lualine_x = {
      { "filetype", color = "StSolderLocation", padding = { left = 0, right = 1 } },
    },
    lualine_y = {
      { "location", color = "StSolderLocation", padding = { left = 1, right = 1 } },
    },
    lualine_z = {
      { "progress", color = "StSolderLocation", padding = { left = 1, right = 1 } },
    },
  }
end

function M.lualine_inactive_sections()
  return {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { "filename", path = 1, color = "StSolderLocation" } },
    lualine_x = { { "location", color = "StSolderLocation" } },
    lualine_y = {},
    lualine_z = {},
  }
end

return M
