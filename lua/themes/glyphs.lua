--- Theme-specific UI glyphs (finder, git marks, statusline diff).
--- Called on ColorScheme so built-in themes can switch without restart.
---
--- Two entry shapes coexist:
---   legacy — telescope + neo_tree_git (kiln, solder, meridian, umbra)
---   structured — finder + git + statusline/tabs/breadcrumbs/completion (loam+)

local icons = require("umbra.icons")

local M = {}

local INHERIT = "inherit"

local sets = {
  kiln = {
    telescope = {
      prompt_prefix = " ◇ ",
      selection_caret = " ❯ ",
    },
    neo_tree_git = {
      added = "A",
      modified = "M",
      deleted = "D",
      renamed = "R",
      untracked = "○",
      ignored = "·",
      unstaged = "×",
      staged = "◆",
      conflict = "◇",
    },
  },
  solder = {
    telescope = {
      prompt_prefix = " ⊙ ",
      selection_caret = " ▸ ",
    },
    neo_tree_git = {
      added = "+",
      modified = "M",
      deleted = "-",
      renamed = "R",
      untracked = "⊙",
      ignored = "·",
      unstaged = "×",
      staged = "◆",
      conflict = "!",
    },
  },
  meridian = {
    telescope = {
      prompt_prefix = " ◇ ",
      selection_caret = " ❯ ",
    },
    neo_tree_git = {
      added = "A",
      modified = "M",
      deleted = "D",
      renamed = "R",
      untracked = "○",
      ignored = "·",
      unstaged = "×",
      staged = "◆",
      conflict = "◇",
    },
  },
  umbra = {
    telescope = {
      prompt_prefix = " ◇ ",
      selection_caret = " ❯ ",
    },
    neo_tree_git = {
      added = "A",
      modified = "M",
      deleted = "D",
      renamed = "R",
      untracked = "○",
      ignored = "·",
      unstaged = "×",
      staged = "◆",
      conflict = "◇",
    },
  },
  loam = {
    finder = {
      prompt_prefix = "❦ ",
      selection_caret = "» ",
    },
    git = {
      added = "+",
      modified = "~",
      deleted = "✖",
      untracked = "?",
      renamed = "»",
      conflict = "!",
      ignored = "·",
      unstaged = "~",
      staged = "+",
    },
    statusline = {
      branch = nil, -- branch icon: umbra/icons; diff symbols: git above
      diagnostics = INHERIT,
    },
    tabs = {
      implementation = "native",
      overrides = nil,
    },
    breadcrumbs = {
      kinds = INHERIT,
    },
    completion = {
      kinds = INHERIT,
    },
  },
}

local function expand_git(git)
  return {
    added = git.added,
    modified = git.modified,
    deleted = git.deleted or git.removed,
    renamed = git.renamed,
    untracked = git.untracked,
    ignored = git.ignored or "·",
    unstaged = git.unstaged or git.modified,
    staged = git.staged or git.added,
    conflict = git.conflict,
  }
end

--- Normalize any theme entry to { telescope, neo_tree_git, statusline }.
local function normalize(set)
  if set.telescope then
    return {
      telescope = set.telescope,
      neo_tree_git = set.neo_tree_git,
      statusline = set.statusline,
    }
  end

  local git = set.git and expand_git(set.git) or nil
  return {
    telescope = set.finder and {
      prompt_prefix = set.finder.prompt_prefix,
      selection_caret = set.finder.selection_caret,
    } or nil,
    neo_tree_git = git,
    statusline = set.statusline,
    git = git,
  }
end

function M.for_theme(name)
  name = name or vim.g.colors_name or "kiln"
  return sets[name] or sets.kiln
end

function M.runtime(name)
  return normalize(M.for_theme(name))
end

function M.finder(name)
  local rt = M.runtime(name)
  return rt.telescope
end

function M.git(name)
  local raw = M.for_theme(name)
  if raw.git then
    return expand_git(raw.git)
  end
  if raw.neo_tree_git then
    return vim.deepcopy(raw.neo_tree_git)
  end
  return nil
end

function M.neo_tree_git(name)
  local git = M.git(name)
  return git and vim.deepcopy(git) or {}
end

--- Statusline branch icon. Nil in spec → umbra/icons.git.branch.
function M.statusline_branch_icon(name)
  local raw = M.for_theme(name)
  local sl = raw.statusline
  if sl and sl.branch then
    return sl.branch
  end
  return icons.git.branch
end

--- Statusline diff symbols. Theme git when defined, else umbra/icons.
function M.statusline_diff_symbols(name)
  local git = M.git(name)
  if git then
    return {
      added = git.added .. " ",
      modified = git.modified .. " ",
      removed = (git.deleted or git.removed) .. " ",
    }
  end
  return {
    added = icons.git.added .. " ",
    modified = icons.git.modified .. " ",
    removed = icons.git.removed .. " ",
  }
end

--- Diagnostic symbols for statusline. Always umbra/icons unless overridden later.
function M.statusline_diagnostic_symbols(_name)
  return {
    error = icons.diagnostics.Error .. " ",
    warn = icons.diagnostics.Warn .. " ",
    info = icons.diagnostics.Info .. " ",
    hint = icons.diagnostics.Hint .. " ",
  }
end

function M.apply(name)
  name = name or vim.g.colors_name
  local rt = M.runtime(name)
  if not rt.telescope then
    return
  end

  pcall(function()
    require("telescope.config").set("defaults.prompt_prefix", rt.telescope.prompt_prefix)
    require("telescope.config").set("defaults.selection_caret", rt.telescope.selection_caret)
  end)

  if not rt.neo_tree_git then
    return
  end

  pcall(function()
    if not package.loaded["neo-tree"] then
      return
    end
    local neo = require("neo-tree")
    local current = neo.config or {}
    local merged = vim.tbl_deep_extend("force", current, {
      default_component_configs = {
        git_status = {
          symbols = vim.deepcopy(rt.neo_tree_git),
        },
      },
    })
    neo.setup(merged)
    if package.loaded["neo-tree.sources.git_status"] then
      pcall(require("neo-tree.sources.git_status").refresh)
    end
  end)
end

return M
