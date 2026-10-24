--- Meridian — engineered for 8-hour sessions (original spec, restored).
---
--- WCAG vs #1b1e23:
---   Body #aebbcf ~8.60:1 | Comments #7a86a3 ~4.59:1 | LineNr #68738f ~3.53:1
---   Accents between ~5.2 and ~8.7:1
---
--- Usage: vim.cmd.colorscheme("meridian")

local M = {}

M.base_palette = require("themes.meridian.palette")
M.palette = M.base_palette
M.resolved = nil

function M.setup() end

local function paint(p)
  local c = {
    bg = p.bg.base,
    bg_dim = p.bg.dark,
    bg_float = p.bg.float,
    bg_alt = p.bg.cursorline,
    bg_select = p.bg.active,
    bg_search = p.bg.search,
    fg = p.fg.base,
    fg_dim = p.fg.dim,
    fg_faint = p.fg.muted,
    line_nr = p.fg.faint,
    blue = p.accent.blue,
    mint = p.accent.emerald,
    teal = p.accent.teal,
    peach = p.accent.peach,
    red = p.accent.red,
    yellow = p.accent.yellow,
    sky = p.accent.sky,
    mauve = p.accent.mauve,
    pink = p.accent.pink,
    border = p.border,
    none = p.none,
  }

  local hl = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  -- ===== Base editor UI (transparent — Ghostty shows through) =====
  hl("Normal", { fg = c.fg, bg = c.none })
  hl("NormalFloat", { fg = c.fg, bg = c.none })
  hl("NormalNC", { fg = c.fg_dim, bg = c.none })
  hl("FloatBorder", { fg = c.border, bg = c.none })
  hl("FloatTitle", { fg = c.blue, bg = c.none, bold = true })
  hl("Cursor", { fg = c.bg, bg = c.fg })
  hl("CursorLine", { bg = c.bg_alt })
  hl("CursorLineNr", { fg = c.blue, bold = true })
  hl("LineNr", { fg = c.line_nr })
  hl("SignColumn", { fg = c.line_nr, bg = c.none })
  hl("ColorColumn", { bg = c.bg_alt })
  hl("Visual", { bg = c.bg_select })
  hl("VisualNOS", { bg = c.bg_select })
  hl("Search", { bg = c.bg_search, fg = c.fg })
  hl("IncSearch", { bg = c.blue, fg = c.bg })
  hl("CurSearch", { bg = c.blue, fg = c.bg })
  hl("Substitute", { bg = c.red, fg = c.bg })
  hl("MatchParen", { fg = c.yellow, bold = true, underline = true })
  hl("Pmenu", { fg = c.fg, bg = c.bg_float })
  hl("PmenuSel", { fg = c.bg, bg = c.blue, bold = true })
  hl("PmenuSbar", { bg = c.bg_alt })
  hl("PmenuThumb", { bg = c.fg_faint })
  hl("WinSeparator", { fg = c.border, bg = c.none })
  hl("VertSplit", { fg = c.border, bg = c.none })
  hl("StatusLine", { fg = c.fg, bg = c.none })
  hl("StatusLineNC", { fg = c.fg_faint, bg = c.none })
  hl("TabLine", { fg = c.fg_dim, bg = c.none })
  hl("TabLineSel", { fg = c.bg, bg = c.blue, bold = true })
  hl("TabLineFill", { bg = c.none })
  hl("Folded", { fg = c.fg_dim, bg = c.bg_alt, italic = true })
  hl("FoldColumn", { fg = c.line_nr, bg = c.none })
  hl("NonText", { fg = c.fg_faint })
  hl("Whitespace", { fg = c.fg_faint })
  hl("Directory", { fg = c.teal, bold = true })
  hl("Title", { fg = c.blue, bold = true })
  hl("ErrorMsg", { fg = c.red, bold = true })
  hl("WarningMsg", { fg = c.yellow, bold = true })
  hl("ModeMsg", { fg = c.fg_dim })
  hl("Question", { fg = c.mint })
  hl("MoreMsg", { fg = c.mint })
  hl("QuickFixLine", { bg = c.bg_select })
  hl("WildMenu", { fg = c.bg, bg = c.blue, bold = true })

  -- ===== Syntax (original Meridian roles) =====
  hl("Comment", { fg = c.fg_faint, italic = true })
  hl("Constant", { fg = c.peach })
  hl("String", { fg = c.mint })
  hl("Character", { fg = c.mint })
  hl("Number", { fg = c.peach })
  hl("Boolean", { fg = c.peach, bold = true })
  hl("Float", { fg = c.peach })
  hl("Identifier", { fg = c.fg })
  hl("Function", { fg = c.blue, bold = true })
  hl("Statement", { fg = c.blue })
  hl("Conditional", { fg = c.blue })
  hl("Repeat", { fg = c.blue })
  hl("Label", { fg = c.blue })
  hl("Operator", { fg = c.fg_dim })
  hl("Keyword", { fg = c.blue, italic = true })
  hl("Exception", { fg = c.red })
  hl("PreProc", { fg = c.mauve })
  hl("Include", { fg = c.mauve })
  hl("Define", { fg = c.mauve })
  hl("Macro", { fg = c.mauve })
  hl("Type", { fg = c.teal })
  hl("StorageClass", { fg = c.teal })
  hl("Structure", { fg = c.teal })
  hl("Typedef", { fg = c.teal })
  hl("Special", { fg = c.mauve })
  hl("SpecialChar", { fg = c.mauve })
  hl("Tag", { fg = c.blue })
  hl("Delimiter", { fg = c.fg_dim })
  hl("Underlined", { fg = c.pink, underline = true })
  hl("Ignore", { fg = c.fg_faint })
  hl("Todo", { fg = c.bg, bg = c.yellow, bold = true })
  hl("Error", { fg = c.red })

  -- ===== Treesitter =====
  hl("@variable", { fg = c.fg })
  hl("@variable.builtin", { fg = c.peach, italic = true })
  hl("@variable.parameter", { fg = c.fg_dim })
  hl("@variable.member", { fg = c.sky })
  hl("@property", { fg = c.sky })
  hl("@field", { fg = c.sky })
  hl("@constant", { fg = c.peach })
  hl("@constant.builtin", { fg = c.peach, bold = true })
  hl("@string", { fg = c.mint })
  hl("@string.escape", { fg = c.mauve })
  hl("@string.special", { fg = c.mauve })
  hl("@number", { fg = c.peach })
  hl("@boolean", { fg = c.peach, bold = true })
  hl("@function", { fg = c.blue, bold = true })
  hl("@function.builtin", { fg = c.blue })
  hl("@function.macro", { fg = c.mauve })
  hl("@function.method", { fg = c.blue })
  hl("@method", { fg = c.blue })
  hl("@constructor", { fg = c.teal })
  hl("@keyword", { fg = c.blue, italic = true })
  hl("@keyword.function", { fg = c.blue, italic = true })
  hl("@keyword.return", { fg = c.blue, italic = true })
  hl("@keyword.operator", { fg = c.blue })
  hl("@keyword.import", { fg = c.mauve, italic = true })
  hl("@keyword.modifier", { fg = c.blue, italic = true })
  hl("@keyword.type", { fg = c.blue, italic = true })
  hl("@conditional", { fg = c.blue })
  hl("@repeat", { fg = c.blue })
  hl("@type", { fg = c.teal })
  hl("@type.builtin", { fg = c.teal, italic = true })
  hl("@type.definition", { fg = c.teal })
  hl("@attribute", { fg = c.mauve })
  hl("@namespace", { fg = c.sky })
  hl("@module", { fg = c.sky })
  hl("@operator", { fg = c.fg_dim })
  hl("@punctuation.delimiter", { fg = c.fg_dim })
  hl("@punctuation.bracket", { fg = c.fg_dim })
  hl("@punctuation.special", { fg = c.mauve })
  hl("@comment", { fg = c.fg_faint, italic = true })
  hl("@comment.todo", { fg = c.bg, bg = c.yellow, bold = true })
  hl("@tag", { fg = c.blue })
  hl("@tag.attribute", { fg = c.sky, italic = true })
  hl("@tag.delimiter", { fg = c.fg_dim })
  hl("@markup.heading", { fg = c.blue, bold = true })
  hl("@markup.strong", { fg = c.fg, bold = true })
  hl("@markup.italic", { fg = c.fg, italic = true })
  hl("@markup.link", { fg = c.pink, underline = true })
  hl("@markup.raw", { fg = c.mint })

  -- ===== LSP semantic tokens =====
  hl("@lsp.type.class", { link = "@type" })
  hl("@lsp.type.decorator", { fg = c.mauve })
  hl("@lsp.type.enum", { fg = c.teal })
  hl("@lsp.type.enumMember", { link = "@constant" })
  hl("@lsp.type.function", { link = "@function" })
  hl("@lsp.type.interface", { fg = c.teal, italic = true })
  hl("@lsp.type.macro", { link = "@function.macro" })
  hl("@lsp.type.method", { link = "@function.method" })
  hl("@lsp.type.namespace", { link = "@module" })
  hl("@lsp.type.parameter", { link = "@variable.parameter" })
  hl("@lsp.type.property", { link = "@property" })
  hl("@lsp.type.struct", { link = "@type" })
  hl("@lsp.type.type", { link = "@type" })
  hl("@lsp.type.typeParameter", { fg = c.teal, italic = true })
  hl("@lsp.type.variable", { link = "@variable" })
  hl("@lsp.type.keyword", { link = "@keyword" })
  hl("@lsp.type.string", { link = "@string" })
  hl("@lsp.type.number", { link = "@number" })
  hl("@lsp.type.operator", { link = "@operator" })
  hl("@lsp.type.comment", { link = "@comment" })
  hl("@lsp.type.event", { fg = c.peach })
  hl("@lsp.type.modifier", { link = "@keyword.modifier" })
  hl("@lsp.type.regexp", { fg = c.mauve })
  hl("@lsp.typemod.function.defaultLibrary", { link = "@function.builtin" })
  hl("@lsp.typemod.variable.defaultLibrary", { link = "@variable.builtin" })
  hl("@lsp.typemod.variable.readonly", { fg = c.peach })
  hl("@lsp.typemod.variable.constant", { fg = c.peach })
  hl("@lsp.typemod.method.defaultLibrary", { link = "@function.builtin" })
  hl("@lsp.typemod.class.defaultLibrary", { fg = c.teal, italic = true })
  hl("@lsp.mod.deprecated", { strikethrough = true })
  hl("@lsp.mod.async", { italic = true })
  hl("@lsp.mod.static", { italic = true })

  -- ===== LSP diagnostics =====
  hl("DiagnosticError", { fg = c.red })
  hl("DiagnosticWarn", { fg = c.yellow })
  hl("DiagnosticInfo", { fg = c.sky })
  hl("DiagnosticHint", { fg = c.teal })
  hl("DiagnosticOk", { fg = c.mint })
  hl("DiagnosticUnderlineError", { undercurl = true, sp = c.red })
  hl("DiagnosticUnderlineWarn", { undercurl = true, sp = c.yellow })
  hl("DiagnosticUnderlineInfo", { undercurl = true, sp = c.sky })
  hl("DiagnosticUnderlineHint", { undercurl = true, sp = c.teal })
  hl("DiagnosticVirtualTextError", { fg = c.red, bg = c.bg_alt })
  hl("DiagnosticVirtualTextWarn", { fg = c.yellow, bg = c.bg_alt })
  hl("DiagnosticVirtualTextInfo", { fg = c.sky, bg = c.bg_alt })
  hl("DiagnosticVirtualTextHint", { fg = c.teal, bg = c.bg_alt })
  hl("LspReferenceText", { bg = c.bg_select })
  hl("LspReferenceRead", { bg = c.bg_select })
  hl("LspReferenceWrite", { bg = c.bg_select, underline = true })
  hl("LspInlayHint", { fg = c.fg_faint, bg = c.bg_alt, italic = true })
  hl("LspSignatureActiveParameter", { fg = c.yellow, bold = true })

  -- ===== Git / gitsigns =====
  hl("GitSignsAdd", { fg = c.mint })
  hl("GitSignsChange", { fg = c.yellow })
  hl("GitSignsDelete", { fg = c.red })
  hl("GitSignsChangedelete", { fg = c.yellow })
  hl("GitSignsTopdelete", { fg = c.red })
  hl("GitSignsUntracked", { fg = c.blue })
  hl("DiffAdd", { fg = c.mint, bg = c.bg_alt })
  hl("DiffChange", { fg = c.yellow, bg = c.bg_alt })
  hl("DiffDelete", { fg = c.red, bg = c.bg_alt })
  hl("DiffText", { fg = c.blue, bg = c.bg_select })
  hl("Added", { fg = c.mint })
  hl("Changed", { fg = c.yellow })
  hl("Removed", { fg = c.red })

  -- ===== Telescope =====
  hl("TelescopeNormal", { fg = c.fg, bg = c.bg_float })
  hl("TelescopeBorder", { fg = c.border, bg = c.bg_float })
  hl("TelescopePromptNormal", { fg = c.fg, bg = c.bg_alt })
  hl("TelescopePromptBorder", { fg = c.border, bg = c.bg_alt })
  hl("TelescopePromptTitle", { fg = c.bg, bg = c.blue, bold = true })
  hl("TelescopePromptPrefix", { fg = c.blue, bg = c.bg_alt })
  hl("TelescopePreviewTitle", { fg = c.bg, bg = c.mint, bold = true })
  hl("TelescopeResultsTitle", { fg = c.bg, bg = c.teal, bold = true })
  hl("TelescopeSelection", { bg = c.bg_select, bold = true })
  hl("TelescopeSelectionCaret", { fg = c.blue, bg = c.bg_select })
  hl("TelescopeMatching", { fg = c.blue, bold = true })

  -- ===== neo-tree =====
  hl("NeoTreeNormal", { fg = c.fg_dim, bg = c.none })
  hl("NeoTreeNormalNC", { fg = c.fg_dim, bg = c.none })
  hl("NeoTreeDirectoryIcon", { fg = c.teal })
  hl("NeoTreeDirectoryName", { fg = c.teal })
  hl("NeoTreeRootName", { fg = c.blue, bold = true })
  hl("NeoTreeFileName", { fg = c.fg_dim })
  hl("NeoTreeFileNameOpened", { fg = c.fg, bold = true })
  hl("NeoTreeIndentMarker", { fg = c.fg_faint })
  hl("NeoTreeGitAdded", { fg = c.mint })
  hl("NeoTreeGitModified", { fg = c.yellow })
  hl("NeoTreeGitDeleted", { fg = c.red })
  hl("NeoTreeGitUntracked", { fg = c.blue })
  hl("NeoTreeFloatBorder", { fg = c.border, bg = c.bg_float })

  -- ===== blink.cmp =====
  hl("BlinkCmpMenu", { fg = c.fg, bg = c.bg_float })
  hl("BlinkCmpMenuBorder", { fg = c.border, bg = c.bg_float })
  hl("BlinkCmpMenuSelection", { fg = c.bg, bg = c.blue, bold = true })
  hl("BlinkCmpLabel", { fg = c.fg })
  hl("BlinkCmpLabelMatch", { fg = c.blue, bold = true })
  hl("BlinkCmpLabelDeprecated", { fg = c.fg_faint, strikethrough = true })
  hl("BlinkCmpLabelDetail", { fg = c.fg_faint })
  hl("BlinkCmpLabelDescription", { fg = c.fg_faint })
  hl("BlinkCmpKind", { fg = c.teal })
  hl("BlinkCmpSource", { fg = c.fg_faint })
  hl("BlinkCmpGhostText", { fg = c.fg_faint, italic = true })
  hl("BlinkCmpDoc", { fg = c.fg, bg = c.bg_float })
  hl("BlinkCmpDocBorder", { fg = c.border, bg = c.bg_float })
  hl("BlinkCmpSignatureHelp", { fg = c.fg, bg = c.bg_float })
  hl("BlinkCmpSignatureHelpBorder", { fg = c.border, bg = c.bg_float })
  hl("BlinkCmpSignatureHelpActiveParameter", { fg = c.yellow, bold = true })

  local kinds = {
    Text = c.fg_dim, Method = c.blue, Function = c.blue, Constructor = c.teal,
    Field = c.sky, Variable = c.fg, Class = c.teal, Interface = c.teal,
    Module = c.sky, Property = c.sky, Unit = c.teal, Value = c.peach,
    Enum = c.teal, Keyword = c.blue, Snippet = c.mauve, Color = c.pink,
    File = c.sky, Reference = c.sky, Folder = c.teal, EnumMember = c.peach,
    Constant = c.peach, Struct = c.teal, Event = c.yellow, Operator = c.fg_dim,
    TypeParameter = c.teal, Namespace = c.sky, Package = c.sky, String = c.mint,
    Number = c.peach, Boolean = c.peach, Array = c.mauve, Object = c.mauve,
    Key = c.sky, Null = c.fg_faint,
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
  hl("DropBarIconUISeparator", { fg = c.fg_faint })
  hl("DropBarMenuHoverEntry", { bg = c.bg_select })
  hl("DropBarMenuCurrentContext", { bold = true })
  hl("NavicText", { fg = c.fg_dim })
  hl("NavicSeparator", { fg = c.fg_faint })
  hl("AerialLine", { bg = c.bg_select })
  hl("TroubleNormal", { fg = c.fg, bg = c.bg_dim })
  hl("TroubleText", { fg = c.fg })
  hl("TroubleCount", { fg = c.peach, bg = c.bg_select })

  -- ===== indent-blankline =====
  hl("IblIndent", { fg = c.bg_alt })
  hl("IblScope", { fg = c.fg_faint })

  -- ===== which-key =====
  hl("WhichKey", { fg = c.blue, bold = true })
  hl("WhichKeyGroup", { fg = c.teal })
  hl("WhichKeyDesc", { fg = c.fg })
  hl("WhichKeySeparator", { fg = c.fg_faint })
  hl("WhichKeyFloat", { bg = c.bg_float })
  hl("WhichKeyBorder", { fg = c.border, bg = c.bg_float })

  -- ===== noice / notify =====
  hl("NotifyBackground", { bg = c.bg_float })
  hl("NotifyERRORBorder", { fg = c.red })
  hl("NotifyWARNBorder", { fg = c.yellow })
  hl("NotifyINFOBorder", { fg = c.sky })
  hl("NotifyDEBUGBorder", { fg = c.fg_faint })
  hl("NotifyTRACEBorder", { fg = c.mauve })
  hl("NotifyERRORTitle", { fg = c.red })
  hl("NotifyWARNTitle", { fg = c.yellow })
  hl("NotifyINFOTitle", { fg = c.sky })
  hl("NoiceCmdlinePopup", { fg = c.fg, bg = c.bg_float })
  hl("NoiceCmdlinePopupBorder", { fg = c.border, bg = c.bg_float })
  hl("NoiceCmdlinePopupTitle", { fg = c.blue, bold = true })
  hl("NoiceCmdlineIcon", { fg = c.blue })

  -- ===== flash / illuminate =====
  hl("FlashBackdrop", { fg = c.fg_faint })
  hl("FlashMatch", { fg = c.bg, bg = c.blue })
  hl("FlashCurrent", { fg = c.bg, bg = c.peach })
  hl("FlashLabel", { fg = c.bg, bg = c.mint, bold = true })
  hl("IlluminatedWordText", { bg = c.bg_select })
  hl("IlluminatedWordRead", { bg = c.bg_select })
  hl("IlluminatedWordWrite", { bg = c.bg_select, underline = true })

  -- ===== alpha / misc =====
  hl("AlphaHeader", { fg = c.blue, bold = true })
  hl("AlphaButtons", { fg = c.teal })
  hl("AlphaShortcut", { fg = c.yellow })
  hl("AlphaFooter", { fg = c.fg_faint })
  hl("MiniIndentscopeSymbol", { fg = c.fg_faint })
  hl("FidgetTitle", { fg = c.blue, bold = true })
  hl("FidgetTask", { fg = c.fg_dim })
end

function M.apply()
  vim.cmd("hi clear")
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end
  vim.o.termguicolors = true
  vim.o.background = "dark"
  vim.g.colors_name = "meridian"

  M.resolved = vim.deepcopy(M.base_palette)
  M.palette = M.resolved
  paint(M.resolved)

  require("themes.umbra.terminal").apply(M.resolved, true)

  pcall(function()
    package.loaded["umbra.color"] = nil
    require("umbra.color")
  end)
end

--- Lualine — Meridian chrome: punchy mode caps, quiet midstream.
function M.lualine()
  local p = M.resolved or M.palette
  local none = p.none
  local c = {
    bg = p.bg.base,
    float = p.bg.float,
    sel = p.bg.active,
    fg = p.fg.base,
    dim = p.fg.dim,
    muted = p.fg.muted,
    blue = p.accent.blue,
    mint = p.accent.emerald,
    teal = p.accent.teal,
    yellow = p.accent.yellow,
    red = p.accent.red,
    mauve = p.accent.mauve,
  }

  local function mode(accent)
    return {
      a = { bg = accent, fg = c.bg, gui = "bold" },
      b = { bg = c.sel, fg = c.fg },
      c = { bg = none, fg = c.dim },
    }
  end

  return {
    normal = mode(c.blue),
    insert = mode(c.mint),
    visual = mode(c.mauve),
    replace = mode(c.red),
    command = mode(c.yellow),
    terminal = mode(c.teal),
    inactive = {
      a = { bg = c.float, fg = c.muted, gui = "bold" },
      b = { bg = none, fg = c.muted },
      c = { bg = none, fg = c.muted },
    },
  }
end

return M
