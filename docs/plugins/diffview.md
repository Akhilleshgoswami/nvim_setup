# Diffview

## Why it exists

`sindrets/diffview.nvim` provides a full Git diff UI — compare branches, staged/unstaged files, and merge conflicts in a structured multi-pane layout. Complements gitsigns hunk-level workflow.

## Features

- Horizontal 2-pane diff (`diff2horizontal`) and 3-pane merge tool
- Enhanced diff highlights (custom VS Code–style colors)
- File panel toggle for browsing changed files
- Icons, winbar info, index watching
- `<leader>e` disabled inside diffview (avoids Snacks explorer conflict)

## Configuration

`lua/plugins/diffview.lua`

Diff highlights: green add, blue change, red delete. Hooks disable wrap in diff buffers.

## Commands

| Command | Action |
|---------|--------|
| `:DiffviewOpen` | Open diff view |
| `:DiffviewClose` | Close diff view |
| `:DiffviewToggleFiles` | Toggle file panel |
| `:DiffviewFocusFiles` | Focus file panel |

## Keymaps

Global (from `lua/mappings.lua`):

| Key | Action |
|-----|--------|
| `Space gd` | Open Diffview (`:DiffviewOpen`) |
| `Space gc` | Close Diffview |
| `Space q` | Toggle file panel |

**Conflict:** `Space q` also binds LSP diagnostics list (buffer) and a Go snippet. Global Diffview toggle wins; LSP overrides in buffer when attached.

**Conflict:** `Space gd` vs LSP `gd` — buffer-local LSP wins when attached.

## Usage

Run `Space gd` in a git repo to open the diff UI. Use the file panel (`Space q`) to jump between changed files. Close with `Space gc` when done reviewing.

## Troubleshooting

- **Empty diff:** Ensure you're in a git repository with changes.
- **`Space gd` goes to definition:** LSP buffer mapping overrides when attached — use `:DiffviewOpen` directly.
- **Layout too wide:** Adjust `view.default.layout` in `diffview.lua`.
