--- Treesitter @ captures for all supported languages.

local util = require("themes.umbra.util")

---@param p table
---@param sem table
---@param cfg UmbraConfig
---@return table<string, vim.api.keyset.highlight>
return function(p, sem, cfg)
  local bg, fg, acc, git, diag = p.bg, p.fg, p.accent, p.git, p.diag
  local comment = { fg = fg.comment, italic = cfg.italic_comments or nil }
  local kw = cfg.bold_keywords and { fg = acc.purple, bold = true } or { fg = acc.purple }

  return {
    ["@variable"] = { fg = fg.base },
    ["@variable.builtin"] = { fg = acc.rose, italic = true },
    ["@variable.parameter"] = { fg = fg.dim, italic = true },
    ["@variable.member"] = { fg = acc.sky },
    ["@constant"] = { fg = acc.pink },
    ["@constant.builtin"] = { fg = acc.peach },
    ["@constant.macro"] = { fg = acc.mauve },
    ["@module"] = { fg = acc.teal },
    ["@module.builtin"] = { fg = acc.teal },
    ["@label"] = { fg = acc.cyan },
    ["@string"] = { fg = acc.emerald },
    ["@string.documentation"] = comment,
    ["@string.regexp"] = { fg = acc.teal },
    ["@string.escape"] = { fg = acc.cyan, bold = true },
    ["@string.special"] = { fg = acc.cyan },
    ["@string.special.url"] = { fg = acc.blue, underline = true },
    ["@character"] = { fg = acc.emerald },
    ["@character.special"] = { fg = acc.cyan },
    ["@boolean"] = { fg = acc.peach },
    ["@number"] = { fg = acc.peach },
    ["@number.float"] = { fg = acc.peach },
    ["@function"] = { fg = acc.blue },
    ["@function.builtin"] = { fg = acc.blue, italic = true },
    ["@function.call"] = { fg = acc.blue },
    ["@function.macro"] = { fg = acc.mauve },
    ["@function.method"] = { fg = acc.blue },
    ["@function.method.call"] = { fg = acc.blue },
    ["@constructor"] = { fg = acc.teal },
    ["@operator"] = { fg = acc.sky },
    ["@keyword"] = kw,
    ["@keyword.function"] = kw,
    ["@keyword.operator"] = kw,
    ["@keyword.import"] = { fg = acc.mauve },
    ["@keyword.type"] = kw,
    ["@keyword.modifier"] = kw,
    ["@keyword.repeat"] = kw,
    ["@keyword.return"] = util.style(kw, { italic = true }),
    ["@keyword.debug"] = { fg = acc.red },
    ["@keyword.exception"] = kw,
    ["@keyword.conditional"] = kw,
    ["@keyword.directive"] = { fg = acc.mauve },
    ["@keyword.coroutine"] = kw,
    ["@punctuation.delimiter"] = { fg = fg.dim },
    ["@punctuation.bracket"] = { fg = fg.muted },
    ["@punctuation.special"] = { fg = acc.cyan },
    ["@comment"] = comment,
    ["@comment.documentation"] = comment,
    ["@comment.error"] = { fg = bg.dark, bg = diag.error, bold = true },
    ["@comment.warning"] = { fg = bg.dark, bg = diag.warn, bold = true },
    ["@comment.todo"] = { fg = bg.dark, bg = acc.orange, bold = true },
    ["@comment.note"] = { fg = bg.dark, bg = acc.cyan, bold = true },
    ["@type"] = { fg = acc.teal },
    ["@type.builtin"] = { fg = acc.teal, italic = true },
    ["@type.definition"] = { fg = acc.teal },
    ["@type.qualifier"] = { fg = acc.purple },
    ["@attribute"] = { fg = acc.mauve },
    ["@attribute.builtin"] = { fg = acc.mauve },
    ["@property"] = { fg = acc.sky },
    ["@field"] = { fg = acc.sky },
    ["@namespace"] = { fg = acc.teal },
    ["@decorator"] = { fg = acc.pink },

    -- Markdown / markup (Notion-like reading)
    ["@markup.heading"] = { fg = acc.indigo, bold = true },
    ["@markup.heading.1.markdown"] = { fg = acc.red, bold = true },
    ["@markup.heading.2.markdown"] = { fg = acc.orange, bold = true },
    ["@markup.heading.3.markdown"] = { fg = acc.yellow, bold = true },
    ["@markup.heading.4.markdown"] = { fg = acc.emerald, bold = true },
    ["@markup.heading.5.markdown"] = { fg = acc.blue, bold = true },
    ["@markup.heading.6.markdown"] = { fg = acc.purple, bold = true },
    ["@markup.strong"] = { fg = fg.base, bold = true },
    ["@markup.italic"] = { fg = fg.base, italic = true },
    ["@markup.strikethrough"] = { fg = fg.muted, strikethrough = true },
    ["@markup.underline"] = { underline = true },
    ["@markup.heading.marker"] = { fg = fg.muted },
    ["@markup.quote"] = { fg = fg.dim, italic = true },
    ["@markup.math"] = { fg = acc.cyan },
    ["@markup.link"] = { fg = acc.blue },
    ["@markup.link.label"] = { fg = acc.cyan },
    ["@markup.link.url"] = { fg = acc.blue, underline = true },
    ["@markup.raw"] = { fg = acc.emerald },
    ["@markup.raw.block"] = { fg = fg.dim, bg = bg.elevated },
    ["@markup.list"] = { fg = acc.mauve },
    ["@markup.list.checked"] = { fg = acc.emerald },
    ["@markup.list.unchecked"] = { fg = fg.muted },

    ["@tag"] = { fg = acc.red },
    ["@tag.builtin"] = { fg = acc.red },
    ["@tag.attribute"] = { fg = acc.teal },
    ["@tag.delimiter"] = { fg = fg.muted },

    ["@diff.plus"] = { fg = git.add },
    ["@diff.minus"] = { fg = git.delete },
    ["@diff.delta"] = { fg = git.change },

    -- Tailwind / CSS extras
    ["@string.special.symbol"] = { fg = acc.cyan },
    ["@constructor.tsx"] = { fg = acc.orange },
  }
end
