# Oil.nvim

## Why it exists

`stevearc/oil.nvim` is the default file explorer. It edits the filesystem like a buffer — rename, move, delete in place. Opens as a float on `-` for quick parent-directory navigation. Replaces nvim-tree (disabled).

## Features

- Float explorer on `-` and `Space oe`
- Default file explorer (`default_file_explorer = true`)
- Delete to trash, skip confirm for simple edits
- Hidden files shown (toggle with `.`)
- Detail columns toggle (`gd` inside Oil)
- Manual file preview (`Ctrl-p` inside Oil)
- Custom highlights synced with `akhilesh.ui` palette

## Configuration

`lua/plugins/oil.lua`

Custom `:Oil` command forces float by default. `use_default_keymaps = false` — keymaps defined in opts.

## Commands

| Command | Action |
|---------|--------|
| `:Oil` | Open float at parent directory |
| `:Oil --float` | Float (explicit) |
| `:Oil --split` | Horizontal split |
| `:Oil --vsplit` | Vertical split |
| `:Oil <path>` | Open at path |

## Keymaps

### Global

| Key | Action |
|-----|--------|
| `-` | Oil float (`:Oil`) |
| `Space oe` | Oil float |

### Inside Oil

| Key | Action |
|-----|--------|
| `Enter` / `l` | Open / enter |
| `h` / `-` | Parent directory |
| `q` / `Esc` | Close |
| `Ctrl-v` | Open vertical split |
| `Ctrl-s` | Open horizontal split |
| `.` | Toggle hidden files |
| `Ctrl-r` | Refresh |
| `Ctrl-p` | Preview file |
| `gd` | Toggle detail columns |

## Usage

Press `-` in normal mode to float-open the parent folder. Edit filenames directly, then `:w` to apply changes. Use `Space e` (Snacks) for a persistent sidebar; Oil is for quick in-place file ops.

## Troubleshooting

- **Oil opens full buffer not float:** `:Oil` user command should call `oil.open_float()` — check `oil.lua` config block.
- **Preview error in float (`relative requires row/col`):** Auto-preview on `OilEnter` was removed; use `Ctrl-p` inside Oil to preview. `preview_win.update_on_cursor_moved` is disabled for float stability.
- **Edgy layout issues:** Oil buffers with `buftype=acwrite` dock left in Edgy — see `edgy.md`.
