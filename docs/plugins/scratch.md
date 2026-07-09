# Scratch (Todo Notes)

## Why it exists

`lua/core/scratch.lua` opens a personal todo markdown file (`~/Notes/todo.md`) in a Snacks float or vertical split — quick capture without leaving Neovim, with optional git sync.

## Features

- Toggle float at 80% size with rounded border
- Vertical split variant
- Auto-creates `~/Notes/` directory
- Git sync via Snacks terminal (`gs` inside float)
- Spell check and wrap enabled in float

## Configuration

`lua/core/scratch.lua`

Loaded on `VeryLazy` via `lua/autocmds.lua`.

## Commands

| Command | Action |
|---------|--------|
| `:ScratchOpenFloat` | Toggle todo float |
| `:ScratchOpenSplit` | Open todo in vsplit |

## Keymaps

| Key | Action |
|-----|--------|
| `Space nt` | Toggle todo float |
| `Space nv` | Todo in vertical split |

### Inside todo float

| Key | Action |
|-----|--------|
| `q` | Save and close |
| `gs` | Git sync (pull, add, commit, push) |
| `gp` | Git pull only |

## Usage

`Space nt` → edit `todo.md` → `q` saves and closes. `gs` runs a non-interactive git sync in `~/Notes`.

## Troubleshooting

- **File not found:** `ensure_dir()` creates `~/Notes/` on first open.
- **Git sync fails:** Initialize git in `~/Notes` or remove `gs` mapping.
- **Float won't close:** Press `q` (not `Esc`) — `q` saves and closes.
