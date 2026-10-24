--- Loam — potting bench / root cellar (balanced v3).
---
--- Syntax (5 accents):
---   functions → ember    keywords → moss
---   strings   → straw    types → clay
---   constants → plum     comments → fg_muted (no accent)
---   variables / punctuation → fg (undecorated)
---
--- Usage: vim.cmd.colorscheme("loam")

local M = {}

M.base_palette = require("themes.loam.palette")
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
    ember = p.accent.ember,
    moss = p.accent.moss,
    straw = p.accent.straw,
    clay = p.accent.clay,
    plum = p.accent.plum,
    error = p.diag.error,
    border = p.border,
    none = p.none,
  }

  local hl = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hl("StatusLine", { fg = c.fg, bg = c.bg_alt })
  hl("StatusLineNC", { fg = c.fg_muted, bg = c.bg_alt })
  hl("WinBar", { fg = c.fg_muted, bg = c.bg_alt })

  -- ===== Base editor UI =====
  hl("Normal", { fg = c.fg, bg = c.bg })
  hl("NormalFloat", { fg = c.fg, bg = c.bg_float })
  hl("NormalNC", { fg = c.fg, bg = c.bg })
  hl("FloatBorder", { fg = c.border, bg = c.bg_float })
  hl("FloatTitle", { fg = c.ember, bg = c.bg_float })
  hl("Cursor", { fg = c.bg, bg = c.fg })
  hl("CursorLine", { bg = c.bg_hl })
  hl("CursorLineNr", { fg = c.ember, bold = true })
  hl("LineNr", { fg = c.fg_muted })
  hl("SignColumn", { bg = c.bg })
  hl("ColorColumn", { bg = c.bg_hl })
  hl("Visual", { bg = c.bg_hl })
  hl("VisualNOS", { bg = c.bg_hl })
  hl("Search", { bg = c.straw, fg = c.bg })
  hl("IncSearch", { bg = c.ember, fg = c.bg })
  hl("CurSearch", { bg = c.ember, fg = c.bg })
  hl("Substitute", { bg = c.error, fg = c.bg })
  hl("MatchParen", { fg = c.ember })
  hl("Pmenu", { fg = c.fg, bg = c.bg_float })
  hl("PmenuSel", { fg = c.bg, bg = c.ember })
  hl("PmenuSbar", { bg = c.bg_alt })
  hl("PmenuThumb", { bg = c.border })
  hl("WinSeparator", { fg = c.border, bg = c.none })
  hl("VertSplit", { fg = c.border, bg = c.none })
  hl("TabLine", { fg = c.fg_muted, bg = c.bg_alt })
  hl("TabLineSel", { fg = c.ember, bg = c.bg_hl })
  hl("TabLineFill", { bg = c.bg_alt })
  hl("Folded", { fg = c.fg_muted, bg = c.bg_alt })
  hl("FoldColumn", { fg = c.fg_muted, bg = c.bg })
  hl("NonText", { fg = c.border })
  hl("Whitespace", { fg = c.border })
  hl("Directory", { fg = c.clay })
  hl("Title", { fg = c.ember })
  hl("ErrorMsg", { fg = c.error })
  hl("WarningMsg", { fg = c.straw })
  hl("ModeMsg", { fg = c.fg_muted })
  hl("Question", { fg = c.straw })
  hl("MoreMsg", { fg = c.moss })
  hl("QuickFixLine", { bg = c.bg_hl })
  hl("WildMenu", { fg = c.bg, bg = c.ember })

  -- ===== Syntax =====
  hl("Comment", { fg = c.fg_muted, italic = true })
  hl("Constant", { fg = c.plum })
  hl("String", { fg = c.straw })
  hl("Character", { fg = c.straw })
  hl("Number", { fg = c.plum })
  hl("Boolean", { fg = c.plum })
  hl("Float", { fg = c.plum })
  hl("Identifier", { fg = c.fg })
  hl("Function", { fg = c.ember })
  hl("Statement", { fg = c.moss })
  hl("Conditional", { fg = c.moss })
  hl("Repeat", { fg = c.moss })
  hl("Label", { fg = c.moss })
  hl("Operator", { fg = c.fg })
  hl("Keyword", { fg = c.moss })
  hl("Exception", { fg = c.error })
  hl("PreProc", { fg = c.moss })
  hl("Include", { fg = c.moss })
  hl("Define", { fg = c.moss })
  hl("Macro", { fg = c.moss })
  hl("Type", { fg = c.clay })
  hl("StorageClass", { fg = c.clay })
  hl("Structure", { fg = c.clay })
  hl("Typedef", { fg = c.clay })
  hl("Special", { fg = c.plum })
  hl("SpecialChar", { fg = c.plum })
  hl("Tag", { fg = c.moss })
  hl("Delimiter", { fg = c.fg })
  hl("Underlined", { fg = c.plum, underline = true })
  hl("Ignore", { fg = c.line_nr })
  hl("Todo", { fg = c.bg, bg = c.straw })
  hl("Error", { fg = c.error })

  -- ===== Treesitter =====
  hl("@variable", { fg = c.fg })
  hl("@variable.builtin", { fg = c.plum, italic = true })
  hl("@variable.parameter", { fg = c.fg, italic = true })
  hl("@variable.member", { fg = c.fg })
  hl("@property", { fg = c.fg })
  hl("@field", { fg = c.fg })
  hl("@constant", { fg = c.plum })
  hl("@constant.builtin", { fg = c.plum })
  hl("@string", { fg = c.straw })
  hl("@string.escape", { fg = c.straw })
  hl("@string.regex", { link = "@string" })
  hl("@string.documentation", { link = "@string" })
  hl("@string.special", { link = "@string" })
  hl("@string.special.symbol", { link = "@string" })
  hl("@string.special.path", { link = "@string" })
  hl("@string.special.url", { link = "@string" })
  hl("@string.special.vim", { link = "@string" })
  hl("@character", { fg = c.straw })
  hl("@number", { fg = c.plum })
  hl("@boolean", { fg = c.plum })
  hl("@function", { fg = c.ember })
  hl("@function.call", { fg = c.ember })
  hl("@function.builtin", { fg = c.ember, italic = true })
  hl("@function.macro", { fg = c.moss })
  hl("@function.method", { fg = c.ember })
  hl("@method", { fg = c.ember })
  hl("@method.call", { fg = c.ember })
  hl("@constructor", { fg = c.clay })
  hl("@keyword", { fg = c.moss })
  hl("@keyword.function", { fg = c.moss })
  hl("@keyword.return", { fg = c.moss })
  hl("@keyword.operator", { fg = c.moss })
  hl("@keyword.import", { fg = c.moss })
  hl("@keyword.modifier", { fg = c.moss })
  hl("@keyword.type", { fg = c.moss })
  hl("@conditional", { fg = c.moss })
  hl("@repeat", { fg = c.moss })
  hl("@type", { fg = c.clay })
  hl("@type.builtin", { fg = c.clay, italic = true })
  hl("@type.definition", { fg = c.clay })
  hl("@attribute", { fg = c.moss })
  hl("@namespace", { fg = c.clay })
  hl("@module", { fg = c.clay })
  hl("@operator", { fg = c.fg })
  hl("@punctuation.delimiter", { fg = c.fg })
  hl("@punctuation.bracket", { fg = c.fg })
  hl("@punctuation.special", { fg = c.fg })
  hl("@comment", { fg = c.fg_muted, italic = true })
  hl("@comment.todo", { fg = c.bg, bg = c.straw })
  hl("@tag", { fg = c.moss })
  hl("@tag.attribute", { fg = c.clay, italic = true })
  hl("@tag.delimiter", { fg = c.fg })
  hl("@markup.heading", { fg = c.ember })
  hl("@markup.strong", { fg = c.fg })
  hl("@markup.italic", { fg = c.fg, italic = true })
  hl("@markup.link", { fg = c.plum, underline = true })
  hl("@markup.raw", { fg = c.straw })

  -- ===== LSP semantic tokens =====
  hl("@lsp.type.class", { link = "@type" })
  hl("@lsp.type.decorator", { fg = c.moss })
  hl("@lsp.type.enum", { fg = c.clay })
  hl("@lsp.type.enumMember", { link = "@constant" })
  hl("@lsp.type.function", { link = "@function" })
  hl("@lsp.type.interface", { fg = c.clay, italic = true })
  hl("@lsp.type.macro", { link = "@function.macro" })
  hl("@lsp.type.method", { link = "@function.method" })
  hl("@lsp.type.namespace", { link = "@namespace" })
  hl("@lsp.type.parameter", { link = "@variable.parameter" })
  hl("@lsp.type.property", { link = "@property" })
  hl("@lsp.type.struct", { link = "@type" })
  hl("@lsp.type.type", { link = "@type" })
  hl("@lsp.type.typeParameter", { fg = c.clay, italic = true })
  hl("@lsp.type.variable", { link = "@variable" })
  hl("@lsp.type.keyword", { link = "@keyword" })
  hl("@lsp.type.string", { link = "@string" })
  hl("@lsp.type.number", { link = "@number" })
  hl("@lsp.type.enumMember", { link = "@constant" })
  hl("@lsp.typemod.variable.constant", { fg = c.plum })
  hl("@lsp.typemod.enumMember.defaultLibrary", { fg = c.plum })
  hl("@lsp.type.operator", { link = "@operator" })
  hl("@lsp.type.comment", { link = "@comment" })
  hl("@lsp.type.event", { fg = c.plum })
  hl("@lsp.type.modifier", { link = "@keyword.modifier" })
  hl("@lsp.type.regexp", { fg = c.clay })
  hl("@lsp.typemod.function.defaultLibrary", { link = "@function.builtin" })
  hl("@lsp.typemod.variable.defaultLibrary", { link = "@variable.builtin" })
  hl("@lsp.typemod.variable.readonly", { fg = c.plum })
  hl("@lsp.typemod.variable.constant", { fg = c.plum })
  hl("@lsp.typemod.method.defaultLibrary", { link = "@function.builtin" })
  hl("@lsp.typemod.class.defaultLibrary", { fg = c.clay, italic = true })
  hl("@lsp.mod.readonly", { italic = true })
  hl("@lsp.mod.deprecated", { strikethrough = true })
  hl("@lsp.mod.async", { italic = true })
  hl("@lsp.mod.static", { italic = true })

  -- ===== Diagnostics =====
  hl("DiagnosticError", { fg = c.error })
  hl("DiagnosticWarn", { fg = c.straw })
  hl("DiagnosticInfo", { fg = c.plum })
  hl("DiagnosticHint", { fg = c.plum })
  hl("DiagnosticOk", { fg = c.moss })
  hl("DiagnosticUnderlineError", { undercurl = true, sp = c.error })
  hl("DiagnosticUnderlineWarn", { undercurl = true, sp = c.straw })
  hl("DiagnosticUnderlineInfo", { undercurl = true, sp = c.plum })
  hl("DiagnosticUnderlineHint", { undercurl = true, sp = c.plum })
  hl("DiagnosticVirtualTextError", { fg = c.error, bg = c.none })
  hl("DiagnosticVirtualTextWarn", { fg = c.straw, bg = c.none })
  hl("DiagnosticVirtualTextInfo", { fg = c.plum, bg = c.none })
  hl("DiagnosticVirtualTextHint", { fg = c.plum, bg = c.none })
  hl("LspReferenceText", { bg = c.bg_select })
  hl("LspReferenceRead", { bg = c.bg_select })
  hl("LspReferenceWrite", { bg = c.bg_select, underline = true })
  hl("LspInlayHint", { fg = c.fg_muted, bg = c.bg_hl, italic = true })
  hl("LspSignatureActiveParameter", { fg = c.straw })

  -- ===== Git / gitsigns =====
  hl("GitSignsAdd", { fg = c.moss })
  hl("GitSignsChange", { fg = c.straw })
  hl("GitSignsDelete", { fg = c.error })
  hl("GitSignsChangedelete", { fg = c.straw })
  hl("GitSignsTopdelete", { fg = c.error })
  hl("GitSignsUntracked", { fg = c.plum })
  hl("DiffAdd", { fg = c.moss, bg = c.bg_hl })
  hl("DiffChange", { fg = c.straw, bg = c.bg_hl })
  hl("DiffDelete", { fg = c.error, bg = c.bg_hl })
  hl("DiffText", { fg = c.ember, bg = c.bg_select })
  hl("Added", { fg = c.moss })
  hl("Changed", { fg = c.straw })
  hl("Removed", { fg = c.error })

  -- ===== Telescope (see themes/loam/telescope.lua) =====

  -- ===== neo-tree =====
  hl("NeoTreeNormal", { fg = c.fg, bg = c.bg })
  hl("NeoTreeNormalNC", { fg = c.fg, bg = c.bg })
  hl("NeoTreeDirectoryIcon", { fg = c.clay })
  hl("NeoTreeDirectoryName", { fg = c.fg })
  hl("NeoTreeRootName", { fg = c.ember })
  hl("NeoTreeFileName", { fg = c.fg })
  hl("NeoTreeFileIcon", { fg = c.fg_muted })
  hl("NeoTreeFileNameOpened", { fg = c.fg })
  hl("NeoTreeIndentMarker", { fg = c.border })
  hl("NeoTreeGitAdded", { fg = c.moss })
  hl("NeoTreeGitModified", { fg = c.straw })
  hl("NeoTreeGitDeleted", { fg = c.error })
  hl("NeoTreeGitUntracked", { fg = c.plum })
  hl("NeoTreeGitConflict", { fg = c.error })
  hl("NeoTreeFloatBorder", { fg = c.border, bg = c.bg_float })
  hl("NeoTreeDiffAdded", { fg = c.moss })
  hl("NeoTreeDiffRemoved", { fg = c.error })

  -- ===== blink.cmp =====
  hl("BlinkCmpMenu", { fg = c.fg, bg = c.bg_float })
  hl("BlinkCmpMenuBorder", { fg = c.border, bg = c.bg_float })
  hl("BlinkCmpMenuSelection", { fg = c.bg, bg = c.ember })
  hl("BlinkCmpLabel", { fg = c.fg })
  hl("BlinkCmpLabelMatch", { fg = c.ember })
  hl("BlinkCmpLabelDeprecated", { fg = c.fg_muted, strikethrough = true })
  hl("BlinkCmpLabelDetail", { fg = c.fg_muted })
  hl("BlinkCmpLabelDescription", { fg = c.fg_muted })
  hl("BlinkCmpKind", { fg = c.clay })
  hl("BlinkCmpSource", { fg = c.fg_muted })
  hl("BlinkCmpGhostText", { fg = c.fg_muted, italic = true })
  hl("BlinkCmpDoc", { fg = c.fg, bg = c.bg_float })
  hl("BlinkCmpDocBorder", { fg = c.border, bg = c.bg_float })
  hl("BlinkCmpSignatureHelp", { fg = c.fg, bg = c.bg_float })
  hl("BlinkCmpSignatureHelpBorder", { fg = c.border, bg = c.bg_float })
  hl("BlinkCmpSignatureHelpActiveParameter", { fg = c.ember })

  local kinds = {
    Text = c.fg_dim,
    Method = c.ember,
    Function = c.ember,
    Constructor = c.clay,
    Field = c.fg,
    Variable = c.fg,
    Class = c.clay,
    Interface = c.clay,
    Module = c.fg,
    Property = c.fg,
    Unit = c.clay,
    Value = c.plum,
    Enum = c.clay,
    Keyword = c.moss,
    Snippet = c.moss,
    Color = c.plum,
    File = c.fg,
    Reference = c.fg,
    Folder = c.clay,
    EnumMember = c.plum,
    Constant = c.plum,
    Struct = c.clay,
    Event = c.clay,
    Operator = c.fg_dim,
    TypeParameter = c.clay,
    Namespace = c.fg,
    Package = c.fg,
    String = c.straw,
    Number = c.plum,
    Boolean = c.plum,
    Array = c.moss,
    Object = c.moss,
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
  hl("TroubleCount", { fg = c.plum, bg = c.bg_select })

  -- ===== indent-blankline =====
  hl("IblIndent", { fg = c.bg_hl })
  hl("IblScope", { fg = c.fg_muted })

  -- ===== which-key =====
  hl("WhichKey", { fg = c.ember })
  hl("WhichKeyGroup", { fg = c.clay })
  hl("WhichKeyDesc", { fg = c.fg })
  hl("WhichKeySeparator", { fg = c.fg_muted })
  hl("WhichKeyFloat", { bg = c.bg_float })
  hl("WhichKeyBorder", { fg = c.border, bg = c.bg_float })

  -- ===== noice / notify =====
  hl("NotifyBackground", { bg = c.bg_float })
  hl("NotifyERRORBorder", { fg = c.error })
  hl("NotifyWARNBorder", { fg = c.straw })
  hl("NotifyINFOBorder", { fg = c.plum })
  hl("NotifyDEBUGBorder", { fg = c.fg_muted })
  hl("NotifyTRACEBorder", { fg = c.plum })
  hl("NotifyERRORTitle", { fg = c.error })
  hl("NotifyWARNTitle", { fg = c.straw })
  hl("NotifyINFOTitle", { fg = c.plum })
  hl("NoiceCmdlinePopup", { fg = c.fg, bg = c.bg_float })
  hl("NoiceCmdlinePopupBorder", { fg = c.border, bg = c.bg_float })
  hl("NoiceCmdlinePopupTitle", { fg = c.ember })
  hl("NoiceCmdlineIcon", { fg = c.ember })

  -- ===== flash / illuminate =====
  hl("FlashBackdrop", { fg = c.fg_muted })
  hl("FlashMatch", { fg = c.bg, bg = c.ember })
  hl("FlashCurrent", { fg = c.bg, bg = c.straw })
  hl("FlashLabel", { fg = c.bg, bg = c.moss })
  hl("IlluminatedWordText", { bg = c.bg_select })
  hl("IlluminatedWordRead", { bg = c.bg_select })
  hl("IlluminatedWordWrite", { bg = c.bg_select, underline = true })

  -- ===== alpha / misc =====
  hl("AlphaHeader", { fg = c.ember })
  hl("AlphaButtons", { fg = c.clay })
  hl("AlphaShortcut", { fg = c.moss })
  hl("AlphaFooter", { fg = c.fg_muted })
  hl("MiniIndentscopeSymbol", { fg = c.fg_muted })
  hl("FidgetTitle", { fg = c.ember })
  hl("FidgetTask", { fg = c.fg_dim })
end

function M.apply()
  vim.cmd("hi clear")
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end
  vim.o.termguicolors = true
  vim.o.background = "dark"
  vim.g.colors_name = "loam"

  M.resolved = vim.deepcopy(M.base_palette)
  M.palette = M.resolved
  paint(M.resolved)

  require("themes.umbra.terminal").apply(M.resolved, true)

  pcall(function()
    package.loaded["umbra.color"] = nil
    require("umbra.color")
  end)

  pcall(function()
    require("themes.glyphs").apply("loam")
  end)

  pcall(function()
    local tel = require("themes.loam.telescope")
    tel.apply_highlights(M.resolved)
    tel.apply_devicons(M.resolved)
  end)

  pcall(function()
    require("themes.loam.diffview").apply_highlights(M.resolved)
  end)
end

--- Lualine — flat bench edge: bg_alt panel, role color on text only.
function M.lualine()
  local p = M.resolved or M.palette
  local panel = p.bg.panel
  local c = {
    fg = p.fg.base,
    muted = p.fg.muted,
    ember = p.accent.ember,
    moss = p.accent.moss,
    straw = p.accent.straw,
    clay = p.accent.clay,
    plum = p.accent.plum,
    error = p.diag.error,
  }

  local function mode(accent)
    return {
      a = { bg = panel, fg = accent },
      b = { bg = panel, fg = c.straw },
      c = { bg = panel, fg = c.fg },
    }
  end

  return {
    normal = mode(c.ember),
    insert = mode(c.moss),
    visual = mode(c.clay),
    replace = mode(c.error),
    command = mode(c.straw),
    terminal = mode(c.plum),
    inactive = {
      a = { bg = panel, fg = c.muted },
      b = { bg = panel, fg = c.muted },
      c = { bg = panel, fg = c.muted },
    },
  }
end

return M
