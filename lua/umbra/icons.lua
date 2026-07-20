-- The single glyph language. One folder, one chevron, one fold, one prompt,
-- one separator, one git set, one diagnostic set. No plugin may introduce a
-- different glyph — they all read from here. Requires a Nerd Font.
--
-- Every Nerd Font glyph is written as a \u{...} escape (Material Design range)
-- so the source is robust and unambiguous; plain box-drawing / symbol glyphs
-- stay literal.

return {
  diagnostics = {
    Error = "\u{f0159}", -- md-close-circle
    Warn = "\u{f0026}", -- md-alert
    Info = "\u{f02fc}", -- md-information
    Hint = "\u{f0335}", -- md-lightbulb
  },
  git = {
    added = "\u{f0415}", -- md-plus
    modified = "\u{f03eb}", -- md-pencil
    removed = "\u{f0374}", -- md-minus
    branch = "\u{f062c}", -- md-source-branch
    unstaged = "\u{f0130}", -- md-circle-outline
    staged = "\u{f012c}", -- md-check
    conflict = "\u{f0026}", -- md-alert
    untracked = "\u{f0417}", -- md-plus-circle
    ignored = "\u{f0130}", -- md-circle-outline
    renamed = "\u{f0177}", -- md-arrow-right-bold
  },
  kinds = {
    Text = "\u{f027f}", Method = "\u{f0295}", Function = "\u{f0295}", Constructor = "\u{f0645}", Field = "\u{f0722}",
    Variable = "\u{f002b}", Class = "\u{f0831}", Interface = "\u{f0831}", Module = "\u{f0169}", Property = "\u{f0722}",
    Unit = "\u{f046d}", Value = "\u{f03a0}", Enum = "\u{f016a}", Keyword = "\u{f030b}", Snippet = "\u{f027f}", Color = "\u{f03d8}",
    File = "\u{f0219}", Reference = "\u{f0207}", Folder = "\u{f024b}", EnumMember = "\u{f03ff}", Constant = "\u{f03ff}",
    Struct = "\u{f0645}", Event = "\u{f0335}", Operator = "\u{f0195}", TypeParameter = "\u{f0831}", Copilot = "\u{f0295}",
    Namespace = "\u{f0169}", Package = "\u{f024b}", String = "\u{f002c}", Number = "\u{f03a0}", Boolean = "\u{25e9}",
    Array = "\u{f016a}", Object = "\u{f0169}", Key = "\u{f030b}", Null = "\u{f07e2}",
  },
  ui = {
    -- Navigation / structure
    chevron_right = "\u{203a}", -- ›
    arrow = "\u{2192}", -- →
    ellipsis = "\u{2026}", -- …
    separator = "\u{2502}", -- │
    prompt = "\u{276f}", -- ❯
    search = "\u{f0349}", -- md-magnify
    -- Status dots
    dot = "\u{25cf}", -- ●
    circle = "\u{25cb}", -- ○
    modified = "\u{25cf}", -- ●
    -- Folds & expanders (the ONE fold pair, used everywhere)
    fold_open = "\u{f0140}", -- md-chevron-down
    fold_closed = "\u{f0142}", -- md-chevron-right
    -- Affordances
    close = "\u{f0156}", -- md-close-box
    lock = "\u{f033e}", -- md-lock
    bookmark = "\u{f00c0}", -- md-bookmark
    lightbulb = "\u{f0335}", -- md-lightbulb
    -- Powerline caps (statusline / winbar halves)
    left_half = "\u{e0b6}",
    right_half = "\u{e0b4}",
    left_thin = "\u{e0b1}",
    right_thin = "\u{e0b3}",
  },
  -- Tree guides — declared once, consumed by neo-tree, trouble and aerial so
  -- the branch glyphs never diverge again.
  tree = {
    indent = "\u{2502}", -- │
    last = "\u{2570}", -- ╰
    top = "\u{2502} ", -- "│ "
    mid_item = "\u{251c}\u{2574}", -- ├╴
    last_item = "\u{2570}\u{2574}", -- ╰╴
  },
  ft = {
    default = "\u{f0219}", -- md-file
  },
}
