-- Umbra highlight groups. Returns a { group = spec } table built from the palette.
-- Kept flat and explicit so the visual identity is auditable in one place.

return function(p)
  local bg, fg, acc, git, diag = p.bg, p.fg, p.accent, p.git, p.diag
  local none = p.none

  local hl = {
    -- ── Editor chrome ──────────────────────────────────────────────
    Normal = { fg = fg.base, bg = bg.base },
    NormalNC = { fg = fg.base, bg = bg.base },
    NormalFloat = { fg = fg.base, bg = bg.float },
    FloatBorder = { fg = p.border, bg = bg.float },
    FloatTitle = { fg = acc.indigo, bg = bg.float, bold = true },
    FloatFooter = { fg = fg.muted, bg = bg.float },
    ColorColumn = { bg = bg.cursorline },
    Cursor = { fg = bg.base, bg = fg.base },
    lCursor = { fg = bg.base, bg = fg.base },
    CursorIM = { fg = bg.base, bg = fg.base },
    TermCursor = { fg = bg.base, bg = acc.indigo },
    CursorColumn = { bg = bg.cursorline },
    CursorLine = { bg = bg.cursorline },
    CursorLineNr = { fg = acc.sand, bold = true },
    LineNr = { fg = fg.faint },
    LineNrAbove = { fg = fg.faint },
    LineNrBelow = { fg = fg.faint },
    SignColumn = { fg = fg.muted, bg = none },
    FoldColumn = { fg = fg.faint, bg = none },
    Folded = { fg = fg.dim, bg = bg.cursorline },
    WinSeparator = { fg = p.border, bg = none },
    VertSplit = { fg = p.border, bg = none },
    EndOfBuffer = { fg = bg.base },
    NonText = { fg = fg.faint },
    Whitespace = { fg = fg.faint },
    SpecialKey = { fg = fg.faint },
    Conceal = { fg = fg.muted },
    Directory = { fg = acc.blue },
    Title = { fg = acc.indigo, bold = true },
    MatchParen = { fg = acc.sand, bg = bg.match, bold = true },
    Visual = { bg = bg.selection },
    VisualNOS = { bg = bg.selection },
    Search = { fg = fg.base, bg = bg.search },
    IncSearch = { fg = bg.dark, bg = acc.sand, bold = true },
    CurSearch = { fg = bg.dark, bg = acc.sand, bold = true },
    Substitute = { fg = bg.dark, bg = acc.rose },
    QuickFixLine = { bg = bg.active, bold = true },
    WildMenu = { fg = bg.dark, bg = acc.indigo },
    Winbar = { fg = fg.dim, bg = none },
    WinbarNC = { fg = fg.muted, bg = none },

    -- Messages
    ErrorMsg = { fg = diag.error },
    WarningMsg = { fg = diag.warn },
    ModeMsg = { fg = fg.dim },
    MoreMsg = { fg = acc.teal },
    Question = { fg = acc.blue },
    MsgArea = { fg = fg.dim },
    MsgSeparator = { fg = p.border },

    -- Popup menu (native)
    Pmenu = { fg = fg.dim, bg = bg.float },
    PmenuSel = { fg = fg.base, bg = bg.active, bold = true },
    PmenuKind = { fg = acc.blue, bg = bg.float },
    PmenuKindSel = { fg = acc.blue, bg = bg.active },
    PmenuExtra = { fg = fg.muted, bg = bg.float },
    PmenuExtraSel = { fg = fg.dim, bg = bg.active },
    PmenuSbar = { bg = bg.float },
    PmenuThumb = { bg = p.border_bright },

    -- Statusline / tabline base
    StatusLine = { fg = fg.dim, bg = bg.dark },
    StatusLineNC = { fg = fg.muted, bg = bg.dark },
    TabLine = { fg = fg.muted, bg = bg.dark },
    TabLineFill = { bg = bg.base },
    TabLineSel = { fg = fg.base, bg = bg.base },

    -- ── Syntax (legacy) ────────────────────────────────────────────
    Comment = { fg = fg.comment, italic = true },
    Constant = { fg = acc.peach },
    String = { fg = acc.green },
    Character = { fg = acc.green },
    Number = { fg = acc.peach },
    Float = { fg = acc.peach },
    Boolean = { fg = acc.peach },
    Identifier = { fg = fg.base },
    Function = { fg = acc.blue },
    Statement = { fg = acc.violet },
    Conditional = { fg = acc.violet },
    Repeat = { fg = acc.violet },
    Label = { fg = acc.violet },
    Operator = { fg = fg.dim },
    Keyword = { fg = acc.violet },
    Exception = { fg = acc.violet },
    PreProc = { fg = acc.mauve },
    Include = { fg = acc.mauve },
    Define = { fg = acc.mauve },
    Macro = { fg = acc.mauve },
    PreCondit = { fg = acc.mauve },
    Type = { fg = acc.sand },
    StorageClass = { fg = acc.sand },
    Structure = { fg = acc.sand },
    Typedef = { fg = acc.sand },
    Special = { fg = acc.teal },
    SpecialChar = { fg = acc.teal },
    Tag = { fg = acc.rose },
    Delimiter = { fg = fg.dim },
    SpecialComment = { fg = acc.teal, italic = true },
    Debug = { fg = acc.rose },
    Underlined = { fg = acc.blue, underline = true },
    Ignore = { fg = fg.muted },
    Error = { fg = diag.error },
    Todo = { fg = bg.dark, bg = acc.sand, bold = true },

    -- ── Treesitter ─────────────────────────────────────────────────
    ["@variable"] = { fg = fg.base },
    ["@variable.builtin"] = { fg = acc.rose, italic = true },
    ["@variable.parameter"] = { fg = fg.base, italic = true },
    ["@variable.member"] = { fg = acc.sky },
    ["@constant"] = { fg = acc.peach },
    ["@constant.builtin"] = { fg = acc.peach },
    ["@constant.macro"] = { fg = acc.mauve },
    ["@module"] = { fg = acc.sand },
    ["@module.builtin"] = { fg = acc.sand },
    ["@label"] = { fg = acc.teal },
    ["@string"] = { fg = acc.green },
    ["@string.documentation"] = { fg = fg.comment },
    ["@string.regexp"] = { fg = acc.teal },
    ["@string.escape"] = { fg = acc.teal, bold = true },
    ["@string.special"] = { fg = acc.teal },
    ["@string.special.url"] = { fg = acc.blue, underline = true },
    ["@character"] = { fg = acc.green },
    ["@character.special"] = { fg = acc.teal },
    ["@boolean"] = { fg = acc.peach },
    ["@number"] = { fg = acc.peach },
    ["@number.float"] = { fg = acc.peach },
    ["@function"] = { fg = acc.blue },
    ["@function.builtin"] = { fg = acc.blue, italic = true },
    ["@function.call"] = { fg = acc.blue },
    ["@function.macro"] = { fg = acc.mauve },
    ["@function.method"] = { fg = acc.blue },
    ["@function.method.call"] = { fg = acc.blue },
    ["@constructor"] = { fg = acc.sand },
    ["@operator"] = { fg = fg.dim },
    ["@keyword"] = { fg = acc.violet },
    ["@keyword.function"] = { fg = acc.violet },
    ["@keyword.operator"] = { fg = acc.violet },
    ["@keyword.import"] = { fg = acc.mauve },
    ["@keyword.type"] = { fg = acc.violet },
    ["@keyword.modifier"] = { fg = acc.violet },
    ["@keyword.repeat"] = { fg = acc.violet },
    ["@keyword.return"] = { fg = acc.violet, italic = true },
    ["@keyword.debug"] = { fg = acc.rose },
    ["@keyword.exception"] = { fg = acc.violet },
    ["@keyword.conditional"] = { fg = acc.violet },
    ["@keyword.directive"] = { fg = acc.mauve },
    ["@keyword.coroutine"] = { fg = acc.violet },
    ["@punctuation.delimiter"] = { fg = fg.dim },
    ["@punctuation.bracket"] = { fg = fg.muted },
    ["@punctuation.special"] = { fg = acc.teal },
    ["@comment"] = { fg = fg.comment, italic = true },
    ["@comment.documentation"] = { fg = fg.comment, italic = true },
    ["@comment.error"] = { fg = bg.dark, bg = diag.error, bold = true },
    ["@comment.warning"] = { fg = bg.dark, bg = diag.warn, bold = true },
    ["@comment.todo"] = { fg = bg.dark, bg = acc.sand, bold = true },
    ["@comment.note"] = { fg = bg.dark, bg = acc.teal, bold = true },
    ["@type"] = { fg = acc.sand },
    ["@type.builtin"] = { fg = acc.sand, italic = true },
    ["@type.definition"] = { fg = acc.sand },
    ["@type.qualifier"] = { fg = acc.violet },
    ["@attribute"] = { fg = acc.mauve },
    ["@attribute.builtin"] = { fg = acc.mauve },
    ["@property"] = { fg = acc.sky },
    ["@field"] = { fg = acc.sky },
    ["@namespace"] = { fg = acc.sand },
    ["@decorator"] = { fg = acc.mauve },

    -- Markup (markdown, help)
    ["@markup.heading"] = { fg = acc.indigo, bold = true },
    ["@markup.heading.1.markdown"] = { fg = acc.rose, bold = true },
    ["@markup.heading.2.markdown"] = { fg = acc.peach, bold = true },
    ["@markup.heading.3.markdown"] = { fg = acc.sand, bold = true },
    ["@markup.heading.4.markdown"] = { fg = acc.green, bold = true },
    ["@markup.heading.5.markdown"] = { fg = acc.blue, bold = true },
    ["@markup.heading.6.markdown"] = { fg = acc.violet, bold = true },
    ["@markup.strong"] = { fg = acc.sand, bold = true },
    ["@markup.italic"] = { fg = fg.base, italic = true },
    ["@markup.strikethrough"] = { fg = fg.muted, strikethrough = true },
    ["@markup.underline"] = { underline = true },
    ["@markup.heading.marker"] = { fg = fg.muted },
    ["@markup.quote"] = { fg = fg.dim, italic = true },
    ["@markup.math"] = { fg = acc.teal },
    ["@markup.link"] = { fg = acc.blue },
    ["@markup.link.label"] = { fg = acc.teal },
    ["@markup.link.url"] = { fg = acc.blue, underline = true },
    ["@markup.raw"] = { fg = acc.green },
    ["@markup.raw.block"] = { fg = fg.dim },
    ["@markup.list"] = { fg = acc.mauve },
    ["@markup.list.checked"] = { fg = acc.green },
    ["@markup.list.unchecked"] = { fg = fg.muted },

    -- Tags (JSX / HTML)
    ["@tag"] = { fg = acc.rose },
    ["@tag.builtin"] = { fg = acc.rose },
    ["@tag.attribute"] = { fg = acc.sand },
    ["@tag.delimiter"] = { fg = fg.muted },

    -- diff via treesitter
    ["@diff.plus"] = { fg = git.add },
    ["@diff.minus"] = { fg = git.delete },
    ["@diff.delta"] = { fg = git.change },

    -- ── LSP ────────────────────────────────────────────────────────
    ["@lsp.type.class"] = { link = "@type" },
    ["@lsp.type.decorator"] = { link = "@attribute" },
    ["@lsp.type.enum"] = { link = "@type" },
    ["@lsp.type.enumMember"] = { link = "@constant" },
    ["@lsp.type.interface"] = { link = "@type" },
    ["@lsp.type.namespace"] = { link = "@module" },
    ["@lsp.type.parameter"] = { link = "@variable.parameter" },
    ["@lsp.type.property"] = { link = "@property" },
    ["@lsp.type.type"] = { link = "@type" },
    ["@lsp.type.variable"] = { link = "@variable" },
    ["@lsp.typemod.function.defaultLibrary"] = { link = "@function.builtin" },
    ["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" },
    LspInlayHint = { fg = fg.faint, bg = none, italic = true },
    LspReferenceText = { bg = bg.match },
    LspReferenceRead = { bg = bg.match },
    LspReferenceWrite = { bg = bg.match, underline = true },
    LspSignatureActiveParameter = { fg = acc.sand, bold = true },
    LspCodeLens = { fg = fg.muted, italic = true },

    -- ── Diagnostics ────────────────────────────────────────────────
    DiagnosticError = { fg = diag.error },
    DiagnosticWarn = { fg = diag.warn },
    DiagnosticInfo = { fg = diag.info },
    DiagnosticHint = { fg = diag.hint },
    DiagnosticOk = { fg = diag.ok },
    DiagnosticVirtualTextError = { fg = diag.error, bg = none },
    DiagnosticVirtualTextWarn = { fg = diag.warn, bg = none },
    DiagnosticVirtualTextInfo = { fg = diag.info, bg = none },
    DiagnosticVirtualTextHint = { fg = diag.hint, bg = none },
    DiagnosticUnderlineError = { undercurl = true, sp = diag.error },
    DiagnosticUnderlineWarn = { undercurl = true, sp = diag.warn },
    DiagnosticUnderlineInfo = { undercurl = true, sp = diag.info },
    DiagnosticUnderlineHint = { undercurl = true, sp = diag.hint },
    DiagnosticUnnecessary = { fg = fg.muted, undercurl = true, sp = fg.muted },
    DiagnosticDeprecated = { fg = fg.muted, strikethrough = true },

    -- ── Diff / git ─────────────────────────────────────────────────
    DiffAdd = { bg = "#16241C" },
    DiffChange = { bg = "#1E2430" },
    DiffDelete = { bg = "#2A1A20" },
    DiffText = { bg = "#2A3450" },
    diffAdded = { fg = git.add },
    diffRemoved = { fg = git.delete },
    diffChanged = { fg = git.change },
    diffFile = { fg = acc.blue },
    diffLine = { fg = fg.muted },
    Added = { fg = git.add },
    Removed = { fg = git.delete },
    Changed = { fg = git.change },

    GitSignsAdd = { fg = git.add },
    GitSignsChange = { fg = git.change },
    GitSignsDelete = { fg = git.delete },
    GitSignsAddNr = { fg = git.add },
    GitSignsChangeNr = { fg = git.change },
    GitSignsDeleteNr = { fg = git.delete },
    GitSignsAddInline = { bg = "#1E3327" },
    GitSignsDeleteInline = { bg = "#3A2029" },
    GitSignsChangeInline = { bg = "#243044" },
    GitSignsCurrentLineBlame = { fg = fg.faint, italic = true },
    GitSignsAddPreview = { fg = git.add },
    GitSignsDeletePreview = { fg = git.delete },
  }

  -- ── Telescope ──────────────────────────────────────────────────
  hl.TelescopeNormal = { fg = fg.dim, bg = bg.float }
  hl.TelescopeBorder = { fg = p.border, bg = bg.float }
  hl.TelescopeTitle = { fg = fg.muted }
  hl.TelescopePromptNormal = { fg = fg.base, bg = bg.overlay }
  hl.TelescopePromptBorder = { fg = bg.overlay, bg = bg.overlay }
  hl.TelescopePromptTitle = { fg = bg.dark, bg = acc.indigo, bold = true }
  hl.TelescopePromptPrefix = { fg = acc.indigo, bg = bg.overlay }
  hl.TelescopePromptCounter = { fg = fg.muted, bg = bg.overlay }
  hl.TelescopeResultsNormal = { fg = fg.dim, bg = bg.float }
  hl.TelescopeResultsBorder = { fg = bg.float, bg = bg.float }
  hl.TelescopeResultsTitle = { fg = bg.float, bg = bg.float }
  hl.TelescopePreviewNormal = { fg = fg.dim, bg = bg.float }
  hl.TelescopePreviewBorder = { fg = bg.float, bg = bg.float }
  hl.TelescopePreviewTitle = { fg = bg.dark, bg = acc.green, bold = true }
  hl.TelescopeSelection = { fg = fg.base, bg = bg.active, bold = true }
  hl.TelescopeSelectionCaret = { fg = acc.indigo, bg = bg.active }
  hl.TelescopeMultiSelection = { fg = acc.sand }
  hl.TelescopeMatching = { fg = acc.sand, bold = true }

  -- ── blink.cmp ──────────────────────────────────────────────────
  hl.BlinkCmpMenu = { fg = fg.dim, bg = bg.float }
  hl.BlinkCmpMenuBorder = { fg = p.border, bg = bg.float }
  hl.BlinkCmpMenuSelection = { fg = fg.base, bg = bg.active, bold = true }
  hl.BlinkCmpScrollBarThumb = { bg = p.border_bright }
  hl.BlinkCmpScrollBarGutter = { bg = bg.float }
  hl.BlinkCmpLabel = { fg = fg.dim }
  hl.BlinkCmpLabelDeprecated = { fg = fg.muted, strikethrough = true }
  hl.BlinkCmpLabelMatch = { fg = acc.sand, bold = true }
  hl.BlinkCmpLabelDetail = { fg = fg.muted }
  hl.BlinkCmpLabelDescription = { fg = fg.muted }
  hl.BlinkCmpKind = { fg = acc.blue }
  hl.BlinkCmpSource = { fg = fg.faint }
  hl.BlinkCmpGhostText = { fg = fg.faint, italic = true }
  hl.BlinkCmpDoc = { fg = fg.dim, bg = bg.float }
  hl.BlinkCmpDocBorder = { fg = p.border, bg = bg.float }
  hl.BlinkCmpDocSeparator = { fg = p.border, bg = bg.float }
  hl.BlinkCmpSignatureHelp = { fg = fg.dim, bg = bg.float }
  hl.BlinkCmpSignatureHelpBorder = { fg = p.border, bg = bg.float }
  hl.BlinkCmpSignatureHelpActiveParameter = { fg = acc.sand, bold = true }

  -- Completion kind icons (shared by blink, aerial, dropbar, navic)
  local kinds = {
    Text = fg.dim, Method = acc.blue, Function = acc.blue, Constructor = acc.sand,
    Field = acc.sky, Variable = fg.base, Class = acc.sand, Interface = acc.sand,
    Module = acc.mauve, Property = acc.sky, Unit = acc.teal, Value = acc.peach,
    Enum = acc.sand, Keyword = acc.violet, Snippet = acc.teal, Color = acc.pink,
    File = fg.dim, Reference = acc.teal, Folder = acc.blue, EnumMember = acc.peach,
    Constant = acc.peach, Struct = acc.sand, Event = acc.sand, Operator = fg.dim,
    TypeParameter = acc.sand, Copilot = acc.teal, Namespace = acc.sand,
    Package = acc.mauve, String = acc.green, Number = acc.peach, Boolean = acc.peach,
    Array = acc.sand, Object = acc.sand, Key = acc.violet, Null = fg.muted,
  }
  for kind, color in pairs(kinds) do
    hl["BlinkCmpKind" .. kind] = { fg = color }
    hl["CmpItemKind" .. kind] = { fg = color }
    hl["Aerial" .. kind .. "Icon"] = { fg = color }
    hl["DropBarKind" .. kind] = { fg = color }
    hl["DropBarIconKind" .. kind] = { fg = color }
    hl["NavicIcons" .. kind] = { fg = color }
  end

  -- ── nvim-notify ────────────────────────────────────────────────
  hl.NotifyBackground = { bg = bg.float }
  local notify_levels = {
    ERROR = diag.error, WARN = diag.warn, INFO = acc.blue, DEBUG = fg.muted, TRACE = acc.violet,
  }
  for level, color in pairs(notify_levels) do
    hl["Notify" .. level .. "Border"] = { fg = p.border, bg = bg.float }
    hl["Notify" .. level .. "Icon"] = { fg = color }
    hl["Notify" .. level .. "Title"] = { fg = color, bold = true }
    hl["Notify" .. level .. "Body"] = { fg = fg.dim, bg = bg.float }
  end

  -- ── noice ──────────────────────────────────────────────────────
  hl.NoiceCmdlinePopup = { fg = fg.base, bg = bg.float }
  hl.NoiceCmdlinePopupBorder = { fg = p.border, bg = bg.float }
  hl.NoiceCmdlinePopupTitle = { fg = acc.indigo, bold = true }
  hl.NoiceCmdlineIcon = { fg = acc.indigo }
  hl.NoiceCmdlineIconSearch = { fg = acc.sand }
  hl.NoiceConfirm = { fg = fg.base, bg = bg.float }
  hl.NoiceConfirmBorder = { fg = p.border, bg = bg.float }
  hl.NoiceMini = { fg = fg.dim, bg = bg.float }
  hl.NoicePopupmenu = { fg = fg.dim, bg = bg.float }
  hl.NoicePopupmenuBorder = { fg = p.border, bg = bg.float }
  hl.NoicePopupmenuSelected = { fg = fg.base, bg = bg.active, bold = true }
  hl.NoiceVirtualText = { fg = fg.muted }

  -- ── which-key ──────────────────────────────────────────────────
  hl.WhichKey = { fg = acc.indigo }
  hl.WhichKeyGroup = { fg = acc.sand }
  hl.WhichKeyDesc = { fg = fg.dim }
  hl.WhichKeySeparator = { fg = fg.faint }
  hl.WhichKeyValue = { fg = fg.muted }
  hl.WhichKeyFloat = { bg = bg.float }
  hl.WhichKeyBorder = { fg = p.border, bg = bg.float }
  hl.WhichKeyTitle = { fg = acc.indigo, bg = bg.float, bold = true }

  -- ── neo-tree ───────────────────────────────────────────────────
  hl.NeoTreeNormal = { fg = fg.dim, bg = bg.panel }
  hl.NeoTreeNormalNC = { fg = fg.dim, bg = bg.panel }
  hl.NeoTreeEndOfBuffer = { fg = bg.panel, bg = bg.panel }
  hl.NeoTreeWinSeparator = { fg = bg.base, bg = bg.base }
  hl.NeoTreeVertSplit = { fg = bg.base, bg = bg.base }
  hl.NeoTreeRootName = { fg = acc.indigo, bold = true }
  hl.NeoTreeDirectoryName = { fg = fg.dim }
  hl.NeoTreeDirectoryIcon = { fg = acc.blue }
  hl.NeoTreeFileName = { fg = fg.dim }
  hl.NeoTreeFileNameOpened = { fg = fg.base }
  hl.NeoTreeDotfile = { fg = fg.muted }
  hl.NeoTreeHiddenByName = { fg = fg.muted }
  hl.NeoTreeIndentMarker = { fg = fg.faint }
  hl.NeoTreeExpander = { fg = fg.muted }
  hl.NeoTreeCursorLine = { bg = bg.active }
  hl.NeoTreeGitAdded = { fg = git.add }
  hl.NeoTreeGitModified = { fg = git.change }
  hl.NeoTreeGitDeleted = { fg = git.delete }
  hl.NeoTreeGitConflict = { fg = git.conflict }
  hl.NeoTreeGitUntracked = { fg = git.untracked }
  hl.NeoTreeGitIgnored = { fg = git.ignored }
  hl.NeoTreeGitUnstaged = { fg = git.change }
  hl.NeoTreeGitStaged = { fg = git.add }
  hl.NeoTreeTitleBar = { fg = bg.dark, bg = acc.indigo, bold = true }
  hl.NeoTreeFloatBorder = { fg = p.border, bg = bg.float }
  hl.NeoTreeFloatTitle = { fg = acc.indigo, bg = bg.float, bold = true }
  hl.NeoTreeTabActive = { fg = fg.base, bg = bg.panel, bold = true }
  hl.NeoTreeTabInactive = { fg = fg.muted, bg = bg.dark }
  hl.NeoTreeTabSeparatorActive = { fg = bg.panel, bg = bg.panel }
  hl.NeoTreeTabSeparatorInactive = { fg = bg.dark, bg = bg.dark }
  hl.NeoTreeModified = { fg = acc.sand }

  -- ── oil ────────────────────────────────────────────────────────
  hl.OilDir = { fg = acc.blue }
  hl.OilDirIcon = { fg = acc.blue }
  hl.OilLink = { fg = acc.teal }
  hl.OilFile = { fg = fg.dim }
  hl.OilCreate = { fg = git.add }
  hl.OilDelete = { fg = git.delete }
  hl.OilMove = { fg = acc.sand }
  hl.OilCopy = { fg = acc.teal }
  hl.OilChange = { fg = git.change }

  -- ── flash ──────────────────────────────────────────────────────
  hl.FlashBackdrop = { fg = fg.muted }
  hl.FlashMatch = { fg = fg.base, bg = bg.match }
  hl.FlashCurrent = { fg = bg.dark, bg = acc.sand, bold = true }
  hl.FlashLabel = { fg = bg.dark, bg = acc.rose, bold = true }
  hl.FlashPrompt = { fg = fg.base, bg = bg.float }
  hl.FlashPromptIcon = { fg = acc.rose }

  -- ── indent-blankline ───────────────────────────────────────────
  hl.IblIndent = { fg = "#1B1E25" }
  hl.IblWhitespace = { fg = "#1B1E25" }
  hl.IblScope = { fg = p.border_bright }

  -- ── trouble ────────────────────────────────────────────────────
  hl.TroubleNormal = { fg = fg.dim, bg = bg.panel }
  hl.TroubleNormalNC = { fg = fg.dim, bg = bg.panel }
  hl.TroubleText = { fg = fg.dim }
  hl.TroubleCount = { fg = acc.mauve, bg = bg.active }
  hl.TroubleFoldIcon = { fg = fg.muted }
  hl.TroubleIndent = { fg = fg.faint }
  hl.TroublePos = { fg = fg.muted }
  hl.TroubleSource = { fg = fg.muted }

  -- ── aerial ─────────────────────────────────────────────────────
  hl.AerialLine = { bg = bg.active }
  hl.AerialGuide = { fg = fg.faint }
  hl.AerialNormal = { fg = fg.dim, bg = bg.panel }

  -- ── dropbar ────────────────────────────────────────────────────
  hl.DropBarIconUISeparator = { fg = fg.faint }
  hl.DropBarIconUIPickPivot = { fg = acc.rose }
  hl.DropBarMenuNormalFloat = { fg = fg.dim, bg = bg.float }
  hl.DropBarMenuFloatBorder = { fg = p.border, bg = bg.float }
  hl.DropBarMenuCurrentContext = { bg = bg.active }
  hl.DropBarMenuHoverEntry = { bg = bg.active }
  hl.DropBarCurrentContext = { bg = none }
  hl.WinBarModified = { fg = acc.sand }

  -- ── fidget ─────────────────────────────────────────────────────
  hl.FidgetTitle = { fg = acc.indigo, bold = true }
  hl.FidgetTask = { fg = fg.muted }

  -- ── harpoon ────────────────────────────────────────────────────
  hl.HarpoonWindow = { fg = fg.dim, bg = bg.float }
  hl.HarpoonBorder = { fg = p.border, bg = bg.float }
  hl.HarpoonTitle = { fg = acc.indigo, bg = bg.float, bold = true }

  -- ── mason / lazy floats inherit NormalFloat + FloatBorder ──────
  hl.MasonHeader = { fg = bg.dark, bg = acc.indigo, bold = true }
  hl.MasonHighlight = { fg = acc.teal }
  hl.MasonHighlightBlockBold = { fg = bg.dark, bg = acc.teal, bold = true }
  hl.MasonMuted = { fg = fg.muted }
  hl.MasonMutedBlock = { fg = fg.muted, bg = bg.active }

  hl.LazyNormal = { fg = fg.dim, bg = bg.float }
  hl.LazyButton = { fg = fg.dim, bg = bg.overlay }
  hl.LazyButtonActive = { fg = bg.dark, bg = acc.indigo, bold = true }
  hl.LazyH1 = { fg = bg.dark, bg = acc.indigo, bold = true }
  hl.LazyProgressDone = { fg = acc.green }
  hl.LazyProgressTodo = { fg = fg.faint }

  -- ── render-markdown ────────────────────────────────────────────
  hl.RenderMarkdownCode = { bg = bg.float }
  hl.RenderMarkdownCodeInline = { fg = acc.green, bg = bg.float }
  hl.RenderMarkdownBullet = { fg = acc.mauve }
  hl.RenderMarkdownDash = { fg = fg.faint }
  hl.RenderMarkdownQuote = { fg = fg.muted }
  hl.RenderMarkdownH1Bg = { fg = acc.rose, bg = "#241820" }
  hl.RenderMarkdownH2Bg = { fg = acc.peach, bg = "#241E18" }
  hl.RenderMarkdownH3Bg = { fg = acc.sand, bg = "#22201A" }
  hl.RenderMarkdownH4Bg = { fg = acc.green, bg = "#1A211C" }
  hl.RenderMarkdownH5Bg = { fg = acc.blue, bg = "#1A1F26" }
  hl.RenderMarkdownH6Bg = { fg = acc.violet, bg = "#1E1D26" }

  -- ── alpha dashboard ────────────────────────────────────────────
  hl.AlphaHeader = { fg = acc.indigo, bold = true }
  hl.AlphaShortcut = { fg = acc.sand }
  hl.AlphaButtons = { fg = fg.dim }
  hl.AlphaButtonIcon = { fg = acc.blue }
  hl.AlphaFooter = { fg = fg.muted, italic = true }
  hl.AlphaProject = { fg = acc.teal }
  hl.AlphaHeaderLabel = { fg = acc.mauve }

  -- ── bufferline (fallbacks; plugin also gets a highlights table) ─
  hl.BufferCurrent = { fg = fg.base, bg = bg.base, bold = true }
  hl.BufferVisible = { fg = fg.dim, bg = bg.dark }
  hl.BufferInactive = { fg = fg.muted, bg = bg.dark }

  return hl
end
