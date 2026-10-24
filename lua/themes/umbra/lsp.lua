--- LSP semantic highlights, diagnostics, and references.

---@param p table
---@param sem table
---@param cfg UmbraConfig
---@return table<string, vim.api.keyset.highlight>
return function(p, sem, cfg)
  local bg, fg, acc, diag = p.bg, p.fg, p.accent, p.diag
  local none = p.none

  return {
    -- Semantic token types
    ["@lsp.type.class"] = { link = "@type" },
    ["@lsp.type.decorator"] = { fg = acc.pink },
    ["@lsp.type.enum"] = { fg = acc.teal },
    ["@lsp.type.enumMember"] = { link = "@constant" },
    ["@lsp.type.function"] = { link = "@function" },
    ["@lsp.type.interface"] = { fg = acc.teal, italic = true },
    ["@lsp.type.macro"] = { link = "@function.macro" },
    ["@lsp.type.method"] = { link = "@function.method" },
    ["@lsp.type.namespace"] = { link = "@module" },
    ["@lsp.type.parameter"] = { link = "@variable.parameter" },
    ["@lsp.type.property"] = { link = "@property" },
    ["@lsp.type.struct"] = { link = "@type" },
    ["@lsp.type.type"] = { link = "@type" },
    ["@lsp.type.typeParameter"] = { fg = acc.teal, italic = true },
    ["@lsp.type.variable"] = { link = "@variable" },
    ["@lsp.type.keyword"] = { link = "@keyword" },
    ["@lsp.type.string"] = { link = "@string" },
    ["@lsp.type.number"] = { link = "@number" },
    ["@lsp.type.operator"] = { link = "@operator" },
    ["@lsp.type.comment"] = { link = "@comment" },
    ["@lsp.type.event"] = { fg = acc.orange },
    ["@lsp.type.modifier"] = { link = "@keyword.modifier" },
    ["@lsp.type.regexp"] = { link = "@string.regexp" },

    -- Modifiers
    ["@lsp.typemod.function.defaultLibrary"] = { link = "@function.builtin" },
    ["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" },
    ["@lsp.typemod.variable.readonly"] = { fg = acc.pink },
    ["@lsp.typemod.variable.constant"] = { fg = acc.pink },
    ["@lsp.typemod.method.defaultLibrary"] = { link = "@function.builtin" },
    ["@lsp.typemod.class.defaultLibrary"] = { fg = acc.teal, italic = true },
    ["@lsp.mod.deprecated"] = { strikethrough = true },
    ["@lsp.mod.async"] = { italic = true },
    ["@lsp.mod.readonly"] = {},
    ["@lsp.mod.static"] = { italic = true },

    LspInlayHint = { fg = fg.faint, bg = none, italic = true },
    LspReferenceText = { bg = bg.match },
    LspReferenceRead = { bg = bg.match },
    LspReferenceWrite = { bg = bg.match, underline = true },
    LspSignatureActiveParameter = { fg = acc.orange, bold = true },
    LspCodeLens = { fg = fg.muted, italic = true },
    LspInfoBorder = { fg = p.border, bg = bg.float },

    DiagnosticError = { fg = diag.error },
    DiagnosticWarn = { fg = diag.warn },
    DiagnosticInfo = { fg = diag.info },
    DiagnosticHint = { fg = diag.hint },
    DiagnosticOk = { fg = diag.ok },
    DiagnosticVirtualTextError = { fg = diag.error, bg = none },
    DiagnosticVirtualTextWarn = { fg = diag.warn, bg = none },
    DiagnosticVirtualTextInfo = { fg = diag.info, bg = none },
    DiagnosticVirtualTextHint = { fg = diag.hint, bg = none },
    DiagnosticVirtualLinesError = { fg = diag.error },
    DiagnosticVirtualLinesWarn = { fg = diag.warn },
    DiagnosticVirtualLinesInfo = { fg = diag.info },
    DiagnosticVirtualLinesHint = { fg = diag.hint },
    -- Soft underlines — undercurl with muted specialty color, never aggressive.
    DiagnosticUnderlineError = { undercurl = true, sp = diag.error },
    DiagnosticUnderlineWarn = { undercurl = true, sp = diag.warn },
    DiagnosticUnderlineInfo = { undercurl = true, sp = diag.info },
    DiagnosticUnderlineHint = { undercurl = true, sp = diag.hint },
    DiagnosticUnnecessary = { fg = fg.muted },
    DiagnosticDeprecated = { fg = fg.muted, strikethrough = true },
  }
end
