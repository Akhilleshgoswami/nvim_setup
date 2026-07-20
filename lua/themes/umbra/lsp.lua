--- LSP semantic highlights, diagnostics, and references.

---@param p table
---@param sem table
---@param cfg UmbraConfig
---@return table<string, vim.api.keyset.highlight>
return function(p, sem, cfg)
  local bg, fg, acc, diag = p.bg, p.fg, p.accent, p.diag
  local none = p.none

  return {
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
    LspSignatureActiveParameter = { fg = acc.orange, bold = true },
    LspCodeLens = { fg = fg.muted, italic = true },

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
    DiagnosticUnderlineError = { undercurl = true, sp = diag.error },
    DiagnosticUnderlineWarn = { undercurl = true, sp = diag.warn },
    DiagnosticUnderlineInfo = { undercurl = true, sp = diag.info },
    DiagnosticUnderlineHint = { undercurl = true, sp = diag.hint },
    DiagnosticUnnecessary = { fg = fg.muted, undercurl = true, sp = fg.muted },
    DiagnosticDeprecated = { fg = fg.muted, strikethrough = true },
  }
end
