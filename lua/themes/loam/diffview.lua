--- Loam — Diffview panel + in-buffer diff highlights.

local M = {}

function M.flat(p)
  p = p or require("themes.loam").resolved or require("themes.loam").base_palette
  local c = require("themes.loam.telescope").flat(p)
  c.error = p.diag.error
  return c
end

function M.apply_highlights(p)
  local c = M.flat(p)
  local hl = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hl("DiffviewFilePanelTitle", { fg = c.ember, bold = true })
  hl("DiffviewFilePanelCounter", { fg = c.fg_muted })
  hl("DiffviewFilePanelFileName", { fg = c.fg })
  hl("DiffviewFilePanelPath", { fg = c.fg_muted })
  hl("DiffviewFilePanelInsertions", { fg = c.moss })
  hl("DiffviewFilePanelDeletions", { fg = c.error })
  hl("DiffviewStatusModified", { fg = c.straw })
  hl("DiffviewStatusAdded", { fg = c.moss })
  hl("DiffviewStatusDeleted", { fg = c.error })
  hl("DiffviewStatusRenamed", { fg = c.plum })

  hl("DiffAdd", { fg = c.moss, bg = c.bg_highlight })
  hl("DiffChange", { fg = c.straw, bg = c.bg_highlight })
  hl("DiffDelete", { fg = c.error, bg = c.bg_highlight })
  hl("DiffText", { fg = c.ember, bg = c.bg_highlight, bold = true })

  hl("NeoTreeDiffAdded", { fg = c.moss })
  hl("NeoTreeDiffRemoved", { fg = c.error })
end

function M.opts()
  return {
    enhanced_diff_hl = true,
    view = {
      default = { layout = "diff2_horizontal", winbar_info = true },
      merge_tool = { layout = "diff3_horizontal" },
    },
    file_panel = {
      listing_style = "tree",
      win_config = { width = 36 },
    },
  }
end

return M
