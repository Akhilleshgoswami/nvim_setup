--- Kiln — warm kiln night (clay · ash glaze · ember).
---
--- Syntax (5 accents):
---   functions → ember     keywords → ash violet
---   strings   → glaze sage  types → kiln gold
---   constants → clay rose   comments → fg_muted (no accent)
---   variables / punctuation → parchment (undecorated / dimmed)
---
--- Usage: vim.cmd.colorscheme("kiln")

local M = {}

M.base_palette = require("themes.kiln.palette")
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
    sage = p.accent.sage,
    gold = p.accent.gold,
    rose = p.accent.rose,
    violet = p.accent.violet,
    brick = p.diag.error,
    border = p.border,
    none = p.none,
  }

  local hl = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  -- ===== Base editor UI =====
  -- Soft-fired kiln: solid ash panels, no cool chrome, no laser-cut fills.
  hl("Normal", { fg = c.fg, bg = c.bg })
  hl("NormalFloat", { fg = c.fg, bg = c.bg_float })
  hl("NormalNC", { fg = c.fg, bg = c.bg })
  hl("FloatBorder", { fg = c.border, bg = c.bg_float })
  hl("FloatTitle", { fg = c.ember, bg = c.bg_float, bold = true })
  hl("Cursor", { fg = c.bg, bg = c.fg })
  hl("CursorLine", { bg = c.bg_hl })
  hl("CursorLineNr", { fg = c.ember, bold = true })
  hl("LineNr", { fg = c.fg_muted })
  hl("SignColumn", { bg = c.bg })
  hl("ColorColumn", { bg = c.bg_hl })
  hl("Visual", { bg = c.bg_hl })
  hl("VisualNOS", { bg = c.bg_hl })
  hl("Search", { bg = c.gold, fg = c.bg })
  hl("IncSearch", { bg = c.ember, fg = c.bg })
  hl("CurSearch", { bg = c.ember, fg = c.bg })
  hl("Substitute", { bg = c.brick, fg = c.bg })
  hl("MatchParen", { fg = c.ember, bold = true })
  hl("Pmenu", { fg = c.fg, bg = c.bg_float })
  hl("PmenuSel", { fg = c.bg, bg = c.ember })
  hl("PmenuSbar", { bg = c.bg_alt })
  hl("PmenuThumb", { bg = c.border })
  hl("WinSeparator", { fg = c.border, bg = c.none })
  hl("VertSplit", { fg = c.border, bg = c.none })
  hl("StatusLine", { fg = c.fg, bg = c.bg_alt })
  hl("StatusLineNC", { fg = c.fg_muted, bg = c.bg_alt })
  hl("StKilnMode", { fg = c.ember, bg = c.bg_alt, bold = true })
  hl("StKilnGit", { fg = c.gold, bg = c.bg_alt })
  hl("StKilnFile", { fg = c.fg, bg = c.bg_alt })
  hl("StKilnFileMod", { fg = c.rose, bg = c.bg_alt })
  hl("StKilnDiagError", { fg = c.brick, bg = c.bg_alt })
  hl("StKilnDiagWarn", { fg = c.gold, bg = c.bg_alt })
  hl("StKilnLocation", { fg = c.fg_muted, bg = c.bg_alt })
  hl("TabLine", { fg = c.fg_muted, bg = c.bg_alt })
  hl("TabLineSel", { fg = c.ember, bg = c.bg_hl, bold = true })
  hl("TabLineFill", { bg = c.bg_alt })
  hl("Folded", { fg = c.fg_muted, bg = c.bg_alt })
  hl("FoldColumn", { fg = c.fg_muted, bg = c.bg })
  hl("NonText", { fg = c.border })
  hl("Whitespace", { fg = c.border })
  hl("Directory", { fg = c.gold })
  hl("Title", { fg = c.ember, bold = true })
  hl("ErrorMsg", { fg = c.brick })
  hl("WarningMsg", { fg = c.gold })
  hl("ModeMsg", { fg = c.fg_muted })
  hl("Question", { fg = c.gold })
  hl("MoreMsg", { fg = c.sage })
  hl("QuickFixLine", { bg = c.bg_hl })
  hl("WildMenu", { fg = c.bg, bg = c.ember })

  -- ===== Syntax =====
  hl("Comment", { fg = c.fg_muted, italic = true })
  hl("Constant", { fg = c.rose })
  hl("String", { fg = c.sage })
  hl("Character", { fg = c.sage })
  hl("Number", { fg = c.rose })
  hl("Boolean", { fg = c.rose, bold = true })
  hl("Float", { fg = c.rose })
  hl("Identifier", { fg = c.fg })
  hl("Function", { fg = c.ember })
  hl("Statement", { fg = c.violet })
  hl("Conditional", { fg = c.violet })
  hl("Repeat", { fg = c.violet })
  hl("Label", { fg = c.violet })
  hl("Operator", { fg = c.fg })
  hl("Keyword", { fg = c.violet })
  hl("Exception", { fg = c.brick })
  hl("PreProc", { fg = c.violet })
  hl("Include", { fg = c.violet })
  hl("Define", { fg = c.violet })
  hl("Macro", { fg = c.violet })
  hl("Type", { fg = c.gold })
  hl("StorageClass", { fg = c.gold })
  hl("Structure", { fg = c.gold })
  hl("Typedef", { fg = c.gold })
  hl("Special", { fg = c.rose })
  hl("SpecialChar", { fg = c.rose })
  hl("Tag", { fg = c.violet })
  hl("Delimiter", { fg = c.fg })
  hl("Underlined", { fg = c.rose, underline = true })
  hl("Ignore", { fg = c.line_nr })
  hl("Todo", { fg = c.bg, bg = c.gold, bold = true })
  hl("Error", { fg = c.brick })

  -- ===== Treesitter =====
  hl("@variable", { fg = c.fg })
  hl("@variable.builtin", { fg = c.rose, italic = true })
  hl("@variable.parameter", { fg = c.fg, italic = true })
  hl("@variable.member", { fg = c.fg })
  hl("@property", { fg = c.fg })
  hl("@field", { fg = c.fg })
  hl("@constant", { fg = c.rose })
  hl("@constant.builtin", { fg = c.rose, bold = true })
  hl("@string", { fg = c.sage })
  hl("@string.escape", { fg = c.gold })
  hl("@string.special", { fg = c.gold })
  hl("@character", { fg = c.sage })
  hl("@number", { fg = c.rose })
  hl("@boolean", { fg = c.rose, bold = true })
  hl("@function", { fg = c.ember })
  hl("@function.call", { fg = c.ember })
  hl("@function.builtin", { fg = c.ember, italic = true })
  hl("@function.macro", { fg = c.violet })
  hl("@function.method", { fg = c.ember })
  hl("@method", { fg = c.ember })
  hl("@method.call", { fg = c.ember })
  hl("@constructor", { fg = c.gold })
  hl("@keyword", { fg = c.violet })
  hl("@keyword.function", { fg = c.violet })
  hl("@keyword.return", { fg = c.violet, italic = true })
  hl("@keyword.operator", { fg = c.violet })
  hl("@keyword.import", { fg = c.violet })
  hl("@keyword.modifier", { fg = c.violet })
  hl("@keyword.type", { fg = c.violet })
  hl("@conditional", { fg = c.violet })
  hl("@repeat", { fg = c.violet })
  hl("@type", { fg = c.gold })
  hl("@type.builtin", { fg = c.gold, italic = true })
  hl("@type.definition", { fg = c.gold })
  hl("@attribute", { fg = c.violet })
  hl("@namespace", { fg = c.gold })
  hl("@module", { fg = c.gold })
  hl("@operator", { fg = c.fg })
  hl("@punctuation.delimiter", { fg = c.fg })
  hl("@punctuation.bracket", { fg = c.fg })
  hl("@punctuation.special", { fg = c.fg })
  hl("@comment", { fg = c.fg_muted, italic = true })
  hl("@comment.todo", { fg = c.bg, bg = c.gold, bold = true })
  hl("@tag", { fg = c.violet })
  hl("@tag.attribute", { fg = c.gold, italic = true })
  hl("@tag.delimiter", { fg = c.fg })
  hl("@markup.heading", { fg = c.ember, bold = true })
  hl("@markup.strong", { fg = c.fg, bold = true })
  hl("@markup.italic", { fg = c.fg, italic = true })
  hl("@markup.link", { fg = c.rose, underline = true })
  hl("@markup.raw", { fg = c.sage })

  -- ===== LSP semantic tokens =====
  hl("@lsp.type.class", { link = "@type" })
  hl("@lsp.type.decorator", { fg = c.violet })
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
  hl("@lsp.type.event", { fg = c.rose })
  hl("@lsp.type.modifier", { link = "@keyword.modifier" })
  hl("@lsp.type.regexp", { fg = c.gold })
  hl("@lsp.typemod.function.defaultLibrary", { link = "@function.builtin" })
  hl("@lsp.typemod.variable.defaultLibrary", { link = "@variable.builtin" })
  hl("@lsp.typemod.variable.readonly", { fg = c.rose })
  hl("@lsp.typemod.variable.constant", { fg = c.rose })
  hl("@lsp.typemod.method.defaultLibrary", { link = "@function.builtin" })
  hl("@lsp.typemod.class.defaultLibrary", { fg = c.gold, italic = true })
  hl("@lsp.mod.readonly", { italic = true })
  hl("@lsp.mod.deprecated", { strikethrough = true })
  hl("@lsp.mod.async", { italic = true })
  hl("@lsp.mod.static", { italic = true })

  -- ===== Diagnostics =====
  hl("DiagnosticError", { fg = c.brick })
  hl("DiagnosticWarn", { fg = c.gold })
  hl("DiagnosticInfo", { fg = c.violet })
  hl("DiagnosticHint", { fg = c.violet })
  hl("DiagnosticOk", { fg = c.sage })
  hl("DiagnosticUnderlineError", { undercurl = true, sp = c.brick })
  hl("DiagnosticUnderlineWarn", { undercurl = true, sp = c.gold })
  hl("DiagnosticUnderlineInfo", { undercurl = true, sp = c.violet })
  hl("DiagnosticUnderlineHint", { undercurl = true, sp = c.violet })
  hl("DiagnosticVirtualTextError", { fg = c.brick, bg = c.none })
  hl("DiagnosticVirtualTextWarn", { fg = c.gold, bg = c.none })
  hl("DiagnosticVirtualTextInfo", { fg = c.violet, bg = c.none })
  hl("DiagnosticVirtualTextHint", { fg = c.violet, bg = c.none })
  hl("LspReferenceText", { bg = c.bg_select })
  hl("LspReferenceRead", { bg = c.bg_select })
  hl("LspReferenceWrite", { bg = c.bg_select, underline = true })
  hl("LspInlayHint", { fg = c.fg_muted, bg = c.bg_hl, italic = true })
  hl("LspSignatureActiveParameter", { fg = c.gold, bold = true })

  -- ===== Git / gitsigns =====
  hl("GitSignsAdd", { fg = c.sage })
  hl("GitSignsChange", { fg = c.gold })
  hl("GitSignsDelete", { fg = c.brick })
  hl("GitSignsChangedelete", { fg = c.gold })
  hl("GitSignsTopdelete", { fg = c.brick })
  hl("GitSignsUntracked", { fg = c.ember })
  hl("DiffAdd", { fg = c.sage, bg = c.bg_hl })
  hl("DiffChange", { fg = c.gold, bg = c.bg_hl })
  hl("DiffDelete", { fg = c.brick, bg = c.bg_hl })
  hl("DiffText", { fg = c.ember, bg = c.bg_select })
  hl("Added", { fg = c.sage })
  hl("Changed", { fg = c.gold })
  hl("Removed", { fg = c.brick })

  -- ===== Telescope (◇ prefix painted via PromptPrefix) =====
  hl("TelescopeNormal", { fg = c.fg, bg = c.bg_float })
  hl("TelescopeBorder", { fg = c.border, bg = c.bg_float })
  hl("TelescopePromptNormal", { fg = c.fg, bg = c.bg_alt })
  hl("TelescopePromptBorder", { fg = c.border, bg = c.bg_alt })
  hl("TelescopePromptTitle", { fg = c.ember, bg = c.bg_alt, bold = true })
  hl("TelescopePromptPrefix", { fg = c.ember, bg = c.bg_alt })
  hl("TelescopePreviewTitle", { fg = c.sage, bg = c.bg_float, bold = true })
  hl("TelescopeResultsTitle", { fg = c.gold, bg = c.bg_float, bold = true })
  hl("TelescopeSelection", { bg = c.bg_select, bold = true })
  hl("TelescopeSelectionCaret", { fg = c.ember, bg = c.bg_select })
  hl("TelescopeMatching", { fg = c.ember, bold = true })

  -- ===== neo-tree =====
  hl("NeoTreeNormal", { fg = c.fg, bg = c.bg })
  hl("NeoTreeNormalNC", { fg = c.fg, bg = c.bg })
  hl("NeoTreeDirectoryIcon", { fg = c.gold })
  hl("NeoTreeDirectoryName", { fg = c.fg })
  hl("NeoTreeRootName", { fg = c.ember, bold = true })
  hl("NeoTreeFileName", { fg = c.fg })
  hl("NeoTreeFileIcon", { fg = c.fg_muted })
  hl("NeoTreeFileNameOpened", { fg = c.fg, bold = true })
  hl("NeoTreeIndentMarker", { fg = c.border })
  hl("NeoTreeGitAdded", { fg = c.sage })
  hl("NeoTreeGitModified", { fg = c.gold })
  hl("NeoTreeGitDeleted", { fg = c.brick })
  hl("NeoTreeGitUntracked", { fg = c.violet })
  hl("NeoTreeGitConflict", { fg = c.brick, bold = true })
  hl("NeoTreeFloatBorder", { fg = c.border, bg = c.bg_float })

  -- ===== blink.cmp =====
  hl("BlinkCmpMenu", { fg = c.fg, bg = c.bg_float })
  hl("BlinkCmpMenuBorder", { fg = c.border, bg = c.bg_float })
  hl("BlinkCmpMenuSelection", { fg = c.bg, bg = c.ember })
  hl("BlinkCmpLabel", { fg = c.fg })
  hl("BlinkCmpLabelMatch", { fg = c.ember, bold = true })
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
  hl("BlinkCmpSignatureHelpActiveParameter", { fg = c.gold, bold = true })

  local kinds = {
    Text = c.fg_dim,
    Method = c.ember,
    Function = c.ember,
    Constructor = c.gold,
    Field = c.fg,
    Variable = c.fg,
    Class = c.gold,
    Interface = c.gold,
    Module = c.fg,
    Property = c.fg,
    Unit = c.gold,
    Value = c.rose,
    Enum = c.gold,
    Keyword = c.violet,
    Snippet = c.violet,
    Color = c.rose,
    File = c.fg,
    Reference = c.fg,
    Folder = c.gold,
    EnumMember = c.rose,
    Constant = c.rose,
    Struct = c.gold,
    Event = c.gold,
    Operator = c.fg_dim,
    TypeParameter = c.gold,
    Namespace = c.fg,
    Package = c.fg,
    String = c.sage,
    Number = c.rose,
    Boolean = c.rose,
    Array = c.violet,
    Object = c.violet,
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
  hl("DropBarMenuCurrentContext", { bold = true })
  hl("NavicText", { fg = c.fg_dim })
  hl("NavicSeparator", { fg = c.fg_muted })
  hl("AerialLine", { bg = c.bg_select })
  hl("TroubleNormal", { fg = c.fg, bg = c.bg_dim })
  hl("TroubleText", { fg = c.fg })
  hl("TroubleCount", { fg = c.rose, bg = c.bg_select })

  -- ===== indent-blankline =====
  hl("IblIndent", { fg = c.bg_hl })
  hl("IblScope", { fg = c.fg_muted })

  -- ===== which-key =====
  hl("WhichKey", { fg = c.ember, bold = true })
  hl("WhichKeyGroup", { fg = c.gold })
  hl("WhichKeyDesc", { fg = c.fg })
  hl("WhichKeySeparator", { fg = c.fg_muted })
  hl("WhichKeyFloat", { bg = c.bg_float })
  hl("WhichKeyBorder", { fg = c.border, bg = c.bg_float })

  -- ===== noice / notify =====
  hl("NotifyBackground", { bg = c.bg_float })
  hl("NotifyERRORBorder", { fg = c.brick })
  hl("NotifyWARNBorder", { fg = c.gold })
  hl("NotifyINFOBorder", { fg = c.violet })
  hl("NotifyDEBUGBorder", { fg = c.fg_muted })
  hl("NotifyTRACEBorder", { fg = c.violet })
  hl("NotifyERRORTitle", { fg = c.brick })
  hl("NotifyWARNTitle", { fg = c.gold })
  hl("NotifyINFOTitle", { fg = c.violet })
  hl("NoiceCmdlinePopup", { fg = c.fg, bg = c.bg_float })
  hl("NoiceCmdlinePopupBorder", { fg = c.border, bg = c.bg_float })
  hl("NoiceCmdlinePopupTitle", { fg = c.ember, bold = true })
  hl("NoiceCmdlineIcon", { fg = c.ember })

  -- ===== flash / illuminate =====
  hl("FlashBackdrop", { fg = c.fg_muted })
  hl("FlashMatch", { fg = c.bg, bg = c.ember })
  hl("FlashCurrent", { fg = c.bg, bg = c.gold })
  hl("FlashLabel", { fg = c.bg, bg = c.sage, bold = true })
  hl("IlluminatedWordText", { bg = c.bg_select })
  hl("IlluminatedWordRead", { bg = c.bg_select })
  hl("IlluminatedWordWrite", { bg = c.bg_select, underline = true })

  -- ===== alpha / misc =====
  hl("AlphaHeader", { fg = c.ember, bold = true })
  hl("AlphaButtons", { fg = c.gold })
  hl("AlphaShortcut", { fg = c.sage })
  hl("AlphaFooter", { fg = c.fg_muted })
  hl("MiniIndentscopeSymbol", { fg = c.fg_muted })
  hl("FidgetTitle", { fg = c.ember, bold = true })
  hl("FidgetTask", { fg = c.fg_dim })
end

function M.apply()
  vim.cmd("hi clear")
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end
  vim.o.termguicolors = true
  vim.o.background = "dark"
  vim.g.colors_name = "kiln"

  M.resolved = vim.deepcopy(M.base_palette)
  M.palette = M.resolved
  paint(M.resolved)

  require("themes.umbra.terminal").apply(M.resolved, true)

  pcall(function()
    package.loaded["umbra.color"] = nil
    require("umbra.color")
  end)

  pcall(function()
    require("themes.glyphs").apply("kiln")
  end)
end

--- Lualine — flat kiln edge: bg_alt panel, color on text only, no powerline fills.
function M.lualine()
  local p = M.resolved or M.palette
  local panel = p.bg.panel
  local c = {
    fg = p.fg.base,
    dim = p.fg.dim,
    muted = p.fg.muted,
    ember = p.accent.ember,
    sage = p.accent.sage,
    gold = p.accent.gold,
    rose = p.accent.rose,
    violet = p.accent.violet,
    brick = p.diag.error,
  }

  local function mode(accent)
    return {
      a = { bg = panel, fg = accent, gui = "bold" },
      b = { bg = panel, fg = c.fg },
      c = { bg = panel, fg = c.dim },
    }
  end

  return {
    normal = mode(c.ember),
    insert = mode(c.sage),
    visual = mode(c.violet),
    replace = mode(c.brick),
    command = mode(c.gold),
    terminal = mode(c.rose),
    inactive = {
      a = { bg = panel, fg = c.muted, gui = "bold" },
      b = { bg = panel, fg = c.muted },
      c = { bg = panel, fg = c.muted },
    },
  }
end

return M
