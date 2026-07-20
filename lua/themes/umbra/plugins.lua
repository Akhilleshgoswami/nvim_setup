--- Third-party plugin highlight groups.

---@param p table
---@param sem table
---@param cfg UmbraConfig
---@return table<string, vim.api.keyset.highlight>
return function(p, sem, cfg)
  local bg, fg, acc, git, diag = p.bg, p.fg, p.accent, p.git, p.diag
  local none = p.none
  local selected = { fg = fg.base, bg = bg.active, bold = true }

  local hl = {}

  -- ── Telescope ──────────────────────────────────────────────────
  hl.TelescopeNormal = { fg = fg.dim, bg = bg.float }
  hl.TelescopeBorder = { fg = p.border, bg = bg.float }
  hl.TelescopeTitle = { fg = fg.muted, bg = bg.float }
  hl.TelescopePromptNormal = { fg = fg.base, bg = bg.overlay }
  hl.TelescopePromptBorder = { fg = p.border, bg = bg.overlay }
  hl.TelescopePromptTitle = { fg = fg.muted, bg = bg.overlay }
  hl.TelescopePromptPrefix = { fg = acc.orange, bg = bg.overlay }
  hl.TelescopePromptCounter = { fg = fg.muted, bg = bg.overlay }
  hl.TelescopeResultsNormal = { fg = fg.dim, bg = bg.float }
  hl.TelescopeResultsBorder = { fg = p.border, bg = bg.float }
  hl.TelescopeResultsTitle = { fg = fg.faint, bg = bg.float }
  hl.TelescopePreviewNormal = { fg = fg.base, bg = bg.float }
  hl.TelescopePreviewBorder = { fg = p.border, bg = bg.float }
  hl.TelescopePreviewTitle = { fg = fg.faint, bg = bg.float }
  hl.TelescopeSelection = { fg = acc.orange, bg = bg.active, bold = true }
  hl.TelescopeSelectionCaret = { fg = fg.muted, bg = bg.active }
  hl.TelescopeMultiSelection = { fg = acc.orange }
  hl.TelescopeMatching = { fg = bg.dark, bg = acc.orange, bold = true }

  -- ── blink.cmp / nvim-cmp ───────────────────────────────────────
  hl.BlinkCmpMenu = { fg = fg.dim, bg = bg.float }
  hl.BlinkCmpMenuBorder = { fg = p.border, bg = bg.float }
  hl.BlinkCmpMenuSelection = selected
  hl.BlinkCmpScrollBarThumb = { bg = p.border_bright }
  hl.BlinkCmpScrollBarGutter = { bg = bg.float }
  hl.BlinkCmpLabel = { fg = fg.dim }
  hl.BlinkCmpLabelDeprecated = { fg = fg.muted, strikethrough = true }
  hl.BlinkCmpLabelMatch = { fg = acc.orange, bold = true }
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
  hl.BlinkCmpSignatureHelpActiveParameter = { fg = acc.orange, bold = true }

  hl.CmpItemAbbr = { fg = fg.dim }
  hl.CmpItemAbbrDeprecated = { fg = fg.muted, strikethrough = true }
  hl.CmpItemAbbrMatch = { fg = acc.orange, bold = true }
  hl.CmpItemAbbrMatchFuzzy = { fg = acc.orange, bold = true }
  hl.CmpItemMenu = { fg = fg.muted, italic = true }
  hl.CmpItemKind = { fg = acc.blue }
  hl.CmpItemKindMatch = { fg = acc.orange, bold = true }

  -- Completion kind icons (shared)
  local kinds = {
    Text = fg.dim, Method = acc.blue, Function = acc.blue, Constructor = acc.orange,
    Field = acc.sky, Variable = fg.base, Class = acc.orange, Interface = acc.orange,
    Module = acc.mauve, Property = acc.sky, Unit = acc.cyan, Value = acc.peach,
    Enum = acc.orange, Keyword = acc.purple, Snippet = acc.cyan, Color = acc.pink,
    File = fg.dim, Reference = acc.cyan, Folder = acc.blue, EnumMember = acc.peach,
    Constant = acc.yellow, Struct = acc.orange, Event = acc.orange, Operator = fg.dim,
    TypeParameter = acc.orange, Copilot = acc.cyan, Namespace = acc.orange,
    Package = acc.mauve, String = acc.emerald, Number = acc.peach, Boolean = acc.peach,
    Array = acc.orange, Object = acc.orange, Key = acc.purple, Null = fg.muted,
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
    ERROR = diag.error, WARN = diag.warn, INFO = acc.blue, DEBUG = fg.muted, TRACE = acc.purple,
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
  hl.NoiceCmdlineIconSearch = { fg = acc.orange }
  hl.NoiceConfirm = { fg = fg.base, bg = bg.float }
  hl.NoiceConfirmBorder = { fg = p.border, bg = bg.float }
  hl.NoiceMini = { fg = fg.dim, bg = bg.float }
  hl.NoicePopupmenu = { fg = fg.dim, bg = bg.float }
  hl.NoicePopupmenuBorder = { fg = p.border, bg = bg.float }
  hl.NoicePopupmenuSelected = selected
  hl.NoiceVirtualText = { fg = fg.muted }

  -- ── which-key ──────────────────────────────────────────────────
  hl.WhichKey = { fg = acc.indigo }
  hl.WhichKeyGroup = { fg = acc.orange }
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
  hl.NeoTreeModified = { fg = acc.orange }

  -- ── nvim-tree ──────────────────────────────────────────────────
  hl.NvimTreeNormal = { fg = fg.dim, bg = bg.panel }
  hl.NvimTreeNormalNC = { fg = fg.dim, bg = bg.panel }
  hl.NvimTreeRootFolder = { fg = acc.indigo, bold = true }
  hl.NvimTreeFolderName = { fg = fg.dim }
  hl.NvimTreeFolderIcon = { fg = acc.blue }
  hl.NvimTreeEmptyFolderName = { fg = fg.muted }
  hl.NvimTreeOpenedFolderName = { fg = fg.base }
  hl.NvimTreeIndentMarker = { fg = fg.faint }
  hl.NvimTreeGitDirty = { fg = git.change }
  hl.NvimTreeGitNew = { fg = git.add }
  hl.NvimTreeGitDeleted = { fg = git.delete }
  hl.NvimTreeGitRenamed = { fg = git.renamed }
  hl.NvimTreeGitMerge = { fg = git.conflict }
  hl.NvimTreeCursorLine = { bg = bg.active }
  hl.NvimTreeWinSeparator = { fg = bg.base, bg = bg.base }

  -- ── oil / mini.files ───────────────────────────────────────────
  hl.OilDir = { fg = acc.blue }
  hl.OilDirIcon = { fg = acc.blue }
  hl.OilLink = { fg = acc.cyan }
  hl.OilFile = { fg = fg.dim }
  hl.OilCreate = { fg = git.add }
  hl.OilDelete = { fg = git.delete }
  hl.OilMove = { fg = acc.orange }
  hl.OilCopy = { fg = acc.cyan }
  hl.OilChange = { fg = git.change }

  hl.MiniFilesNormal = { fg = fg.dim, bg = bg.panel }
  hl.MiniFilesBorder = { fg = p.border, bg = bg.panel }
  hl.MiniFilesTitle = { fg = acc.indigo, bg = bg.panel, bold = true }
  hl.MiniFilesTitleFocused = { fg = bg.dark, bg = acc.indigo, bold = true }
  hl.MiniFilesDirectory = { fg = acc.blue }
  hl.MiniFilesFile = { fg = fg.dim }

  -- ── flash / leap / hop ─────────────────────────────────────────
  hl.FlashBackdrop = { fg = fg.muted }
  hl.FlashMatch = { fg = fg.base, bg = bg.match }
  hl.FlashCurrent = { fg = bg.dark, bg = acc.orange, bold = true }
  hl.FlashLabel = { fg = bg.dark, bg = acc.rose, bold = true }
  hl.FlashPrompt = { fg = fg.base, bg = bg.float }
  hl.FlashPromptIcon = { fg = acc.rose }

  hl.LeapMatch = { fg = bg.dark, bg = acc.orange, bold = true }
  hl.LeapLabel = { fg = bg.dark, bg = acc.rose, bold = true }
  hl.LeapBackdrop = { fg = fg.muted }

  hl.HopNextKey = { fg = bg.dark, bg = acc.orange, bold = true }
  hl.HopNextKey1 = { fg = bg.dark, bg = acc.indigo, bold = true }
  hl.HopNextKey2 = { fg = acc.indigo, bold = true }
  hl.HopUnmatched = { fg = fg.muted }

  -- ── indent-blankline / rainbow / ts-context ────────────────────
  hl.IblIndent = { fg = sem.indent }
  hl.IblWhitespace = { fg = sem.indent }
  hl.IblScope = { fg = p.border_bright }

  hl.RainbowDelimiterRed = { fg = acc.red }
  hl.RainbowDelimiterYellow = { fg = acc.yellow }
  hl.RainbowDelimiterBlue = { fg = acc.blue }
  hl.RainbowDelimiterOrange = { fg = acc.orange }
  hl.RainbowDelimiterGreen = { fg = acc.emerald }
  hl.RainbowDelimiterViolet = { fg = acc.purple }
  hl.RainbowDelimiterCyan = { fg = acc.cyan }

  hl.TreesitterContext = { bg = bg.elevated }
  hl.TreesitterContextLineNumber = { fg = fg.muted, bg = bg.elevated }
  hl.TreesitterContextBottom = { fg = p.border, bg = bg.elevated }
  hl.TreesitterContextLineNumberBottom = { fg = fg.muted, bg = bg.elevated }

  -- ── trouble ────────────────────────────────────────────────────
  hl.TroubleNormal = { fg = fg.dim, bg = bg.panel }
  hl.TroubleNormalNC = { fg = fg.dim, bg = bg.panel }
  hl.TroubleText = { fg = fg.dim }
  hl.TroubleCount = { fg = acc.mauve, bg = bg.active }
  hl.TroubleFoldIcon = { fg = fg.muted }
  hl.TroubleIndent = { fg = fg.faint }
  hl.TroublePos = { fg = fg.muted }
  hl.TroubleSource = { fg = fg.muted }
  hl.TroubleCode = { fg = acc.cyan }

  -- ── todo-comments / illuminate ─────────────────────────────────
  hl.TodoBgTODO = { fg = bg.dark, bg = acc.blue, bold = true }
  hl.TodoBgFIX = { fg = bg.dark, bg = acc.red, bold = true }
  hl.TodoBgHACK = { fg = bg.dark, bg = acc.orange, bold = true }
  hl.TodoBgWARN = { fg = bg.dark, bg = acc.yellow, bold = true }
  hl.TodoBgPERF = { fg = bg.dark, bg = acc.purple, bold = true }
  hl.TodoBgNOTE = { fg = bg.dark, bg = acc.cyan, bold = true }
  hl.TodoBgTEST = { fg = bg.dark, bg = acc.emerald, bold = true }
  hl.TodoFgTODO = { fg = acc.blue }
  hl.TodoFgFIX = { fg = acc.red }
  hl.TodoFgHACK = { fg = acc.orange }
  hl.TodoFgWARN = { fg = acc.yellow }
  hl.TodoFgPERF = { fg = acc.purple }
  hl.TodoFgNOTE = { fg = acc.cyan }
  hl.TodoFgTEST = { fg = acc.emerald }

  hl.IlluminatedWord = { bg = bg.match }
  hl.IlluminatedWordRead = { bg = bg.match }
  hl.IlluminatedWordWrite = { bg = bg.match, underline = true }

  -- ── aerial / dropbar / navic ───────────────────────────────────
  hl.AerialLine = { bg = bg.active }
  hl.AerialGuide = { fg = fg.faint }
  hl.AerialNormal = { fg = fg.dim, bg = bg.panel }

  hl.DropBarIconUISeparator = { fg = fg.faint }
  hl.DropBarIconUIPickPivot = { fg = acc.rose }
  hl.DropBarMenuNormalFloat = { fg = fg.dim, bg = bg.float }
  hl.DropBarMenuFloatBorder = { fg = p.border, bg = bg.float }
  hl.DropBarMenuCurrentContext = { bg = bg.active }
  hl.DropBarMenuHoverEntry = { bg = bg.active }
  hl.DropBarCurrentContext = { bg = none }
  hl.WinBarModified = { fg = acc.orange }
  hl.NavicSeparator = { fg = fg.faint }
  hl.NavicText = { fg = fg.muted }

  -- ── fidget / harpoon ───────────────────────────────────────────
  hl.FidgetTitle = { fg = acc.indigo, bold = true }
  hl.FidgetTask = { fg = fg.muted }

  hl.HarpoonWindow = { fg = fg.dim, bg = bg.float }
  hl.HarpoonBorder = { fg = p.border, bg = bg.float }
  hl.HarpoonTitle = { fg = acc.indigo, bg = bg.float, bold = true }

  -- ── mason / lazy ───────────────────────────────────────────────
  hl.MasonHeader = { fg = bg.dark, bg = acc.indigo, bold = true }
  hl.MasonHighlight = { fg = acc.cyan }
  hl.MasonHighlightBlockBold = { fg = bg.dark, bg = acc.cyan, bold = true }
  hl.MasonMuted = { fg = fg.muted }
  hl.MasonMutedBlock = { fg = fg.muted, bg = bg.active }

  hl.LazyNormal = { fg = fg.dim, bg = bg.float }
  hl.LazyButton = { fg = fg.dim, bg = bg.overlay }
  hl.LazyButtonActive = { fg = bg.dark, bg = acc.indigo, bold = true }
  hl.LazyH1 = { fg = bg.dark, bg = acc.indigo, bold = true }
  hl.LazyProgressDone = { fg = acc.emerald }
  hl.LazyProgressTodo = { fg = fg.faint }

  -- ── snacks.nvim ────────────────────────────────────────────────
  hl.SnacksNormal = { fg = fg.dim, bg = bg.float }
  hl.SnacksBorder = { fg = p.border, bg = bg.float }
  hl.SnacksTitle = { fg = acc.indigo, bg = bg.float, bold = true }
  hl.SnacksIndent = { fg = sem.indent }
  hl.SnacksDashboardNormal = { fg = fg.dim, bg = bg.base }
  hl.SnacksDashboardIcon = { fg = acc.blue }
  hl.SnacksDashboardKey = { fg = acc.orange }
  hl.SnacksDashboardDesc = { fg = fg.muted }
  hl.SnacksDashboardFooter = { fg = fg.muted, italic = true }

  -- ── render-markdown ────────────────────────────────────────────
  hl.RenderMarkdownCode = { bg = bg.float }
  hl.RenderMarkdownCodeInline = { fg = acc.emerald, bg = bg.elevated }
  hl.RenderMarkdownBullet = { fg = acc.mauve }
  hl.RenderMarkdownDash = { fg = fg.faint }
  hl.RenderMarkdownQuote = { fg = fg.muted }
  hl.RenderMarkdownH1Bg = { fg = acc.red, bg = sem.heading_bg(acc.red) }
  hl.RenderMarkdownH2Bg = { fg = acc.orange, bg = sem.heading_bg(acc.orange) }
  hl.RenderMarkdownH3Bg = { fg = acc.yellow, bg = sem.heading_bg(acc.yellow) }
  hl.RenderMarkdownH4Bg = { fg = acc.emerald, bg = sem.heading_bg(acc.emerald) }
  hl.RenderMarkdownH5Bg = { fg = acc.blue, bg = sem.heading_bg(acc.blue) }
  hl.RenderMarkdownH6Bg = { fg = acc.purple, bg = sem.heading_bg(acc.purple) }

  -- ── alpha / dashboard ──────────────────────────────────────────
  hl.AlphaHeader = { fg = acc.indigo, bold = true }
  hl.AlphaShortcut = { fg = acc.orange }
  hl.AlphaButtons = { fg = fg.dim }
  hl.AlphaButtonIcon = { fg = acc.blue }
  hl.AlphaFooter = { fg = fg.muted, italic = true }
  hl.AlphaProject = { fg = acc.cyan }
  hl.AlphaHeaderLabel = { fg = acc.mauve }

  hl.DashboardHeader = { fg = acc.indigo, bold = true }
  hl.DashboardShortCut = { fg = acc.orange }
  hl.DashboardKey = { fg = acc.blue }
  hl.DashboardDesc = { fg = fg.muted }
  hl.DashboardFooter = { fg = fg.muted, italic = true }
  hl.DashboardIcon = { fg = acc.cyan }

  -- ── bufferline ─────────────────────────────────────────────────
  hl.BufferLineFill = { fg = fg.muted, bg = bg.dark }
  hl.BufferLineBackground = { fg = fg.muted, bg = bg.dark }
  hl.BufferLineBuffer = { fg = fg.muted, bg = bg.dark }
  hl.BufferLineBufferVisible = { fg = fg.dim, bg = bg.dark }
  hl.BufferLineBufferSelected = { fg = fg.base, bg = bg.base, bold = true }
  hl.BufferLineTab = { fg = fg.muted, bg = bg.dark }
  hl.BufferLineTabSelected = { fg = fg.base, bg = bg.base }
  hl.BufferLineIndicatorSelected = { fg = acc.indigo, bg = bg.base }
  hl.BufferLineIndicatorVisible = { fg = bg.dark, bg = bg.dark }
  hl.BufferLineModified = { fg = acc.orange }
  hl.BufferLineModifiedSelected = { fg = acc.orange, bg = bg.base }
  hl.BufferLineCloseButton = { fg = fg.muted }
  hl.BufferLineCloseButtonSelected = { fg = fg.dim, bg = bg.base }
  hl.BufferLineSeparator = { fg = bg.dark, bg = bg.dark }
  hl.BufferLineSeparatorSelected = { fg = bg.base, bg = bg.base }

  -- ── diffview / fugitive / neogit ───────────────────────────────
  hl.DiffviewPrimary = { fg = acc.indigo }
  hl.DiffviewSecondary = { fg = fg.muted }
  hl.DiffviewDiffAdd = { bg = sem.diff.add }
  hl.DiffviewDiffChange = { bg = sem.diff.change }
  hl.DiffviewDiffDelete = { bg = sem.diff.delete }
  hl.DiffviewDiffAddInline = { bg = sem.inline.add }
  hl.DiffviewDiffChangeInline = { bg = sem.inline.change }
  hl.DiffviewDiffDeleteInline = { bg = sem.inline.delete }

  hl.fugitiveStaged = { fg = git.add }
  hl.fugitiveUnstaged = { fg = git.change }
  hl.fugitiveUntracked = { fg = git.untracked }
  hl.fugitiveHeading = { fg = acc.indigo, bold = true }
  hl.fugitiveHash = { fg = acc.cyan }
  hl.fugitiveRef = { fg = acc.orange }

  hl.NeogitBranch = { fg = acc.indigo, bold = true }
  hl.NeogitRemote = { fg = acc.cyan }
  hl.NeogitObject = { fg = fg.dim }
  hl.NeogitRebaseDone = { fg = git.add }
  hl.NeogitRebaseTodo = { fg = git.change }
  hl.NeogitDiffAdd = { bg = sem.diff.add }
  hl.NeogitDiffDelete = { bg = sem.diff.delete }
  hl.NeogitDiffContext = { bg = sem.diff.change }

  -- ── copilot / avante ───────────────────────────────────────────
  hl.CopilotSuggestion = { fg = fg.faint, italic = true }
  hl.CopilotAnnotation = { fg = fg.muted, italic = true }

  hl.AvanteTitle = { fg = acc.indigo, bg = bg.float, bold = true }
  hl.AvanteReversedTitle = { fg = bg.dark, bg = acc.indigo, bold = true }
  hl.AvanteSubtitle = { fg = fg.muted }
  hl.AvantePopupHint = { fg = acc.cyan }
  hl.AvanteInlineHint = { fg = fg.faint, italic = true }
  hl.AvanteConflictCurrent = { bg = sem.diff.change }
  hl.AvanteConflictIncoming = { bg = sem.diff.add }
  hl.AvanteConflictCurrentLabel = { fg = acc.orange }
  hl.AvanteConflictIncomingLabel = { fg = acc.emerald }

  -- ── DAP ────────────────────────────────────────────────────────
  hl.DapBreakpoint = { fg = diag.error }
  hl.DapBreakpointCondition = { fg = diag.warn }
  hl.DapLogPoint = { fg = diag.info }
  hl.DapBreakpointRejected = { fg = fg.muted }
  hl.DapStopped = { fg = diag.ok }
  hl.DapStoppedLine = { bg = sem.diff.add }

  -- ── Umbra custom (statusline harpoon pins) ─────────────────────
  hl.UmbraHarpoonActive = { fg = fg.base, bold = true }
  hl.UmbraHarpoonInactive = { fg = fg.muted }

  -- ── scrollbar / mini.indentscope ───────────────────────────────
  hl.ScrollbarHandle = { bg = bg.active }
  hl.ScrollbarHandleHover = { bg = p.border_bright }
  hl.ScrollView = { bg = bg.active }
  hl.MiniIndentscopeSymbol = { fg = fg.faint }
  hl.MiniIndentscopePrefixSymbol = { fg = fg.faint }

  return hl
end
