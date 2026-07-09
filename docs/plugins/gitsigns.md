# Gitsigns

## Why it exists

`lewis6991/gitsigns.nvim` shows git change signs in the sign column, provides hunk navigation, staging, blame, and inline diff preview — your primary in-buffer git workflow.

## Features

- Sign column glyphs for add/change/delete (staged vs unstaged colors)
- Number column tinting (`numhl`)
- Optional line highlight (`linehl`, off by default)
- Hunk stage/reset/preview
- Blame popup and inline blame toggle
- Word diff and deleted virtual text toggles
- Tokyo Night–aligned custom highlights

## Configuration

`lua/plugins/gitsigns.lua`

All keymaps defined in `on_attach`. Signs use minimal bar glyphs (`▎`, `▁`).

## Commands

Gitsigns is keymap-driven. Useful ex commands:

| Command | Action |
|---------|--------|
| `:Gitsigns toggle_signs` | Toggle signs |
| `:Gitsigns blame_line` | Blame current line |

## Keymaps

Buffer-local:

| Key | Action |
|-----|--------|
| `]h` / `[h` | Next / prev hunk |
| `Space hs` | Stage hunk (normal + visual) |
| `Space hS` | Stage buffer |
| `Space hu` | Undo stage hunk |
| `Space hr` | Reset hunk (normal + visual) |
| `Space hR` | Reset buffer |
| `Space hp` | Preview hunk |
| `Space hi` | Inline hunk preview |
| `Space hd` | Diff this (+ line highlight) |
| `Space hD` | Diff against `~` |
| `Space hb` | Blame line (popup) |
| `Space hB` | Toggle inline blame |
| `Space hx` | Toggle deleted virtual text |
| `Space hw` | Toggle word diff |
| `Space hl` | Toggle line highlight |

In diff mode, `]h`/`[h` fall back to `]c`/`[c`.

## Usage

Edit a tracked file — signs appear in the gutter. Stage hunks with `Space hs` before commit. Use `Space hp` to preview changes. `Space hd` opens diff view with VS Code–style line backgrounds.

## Troubleshooting

- **No signs:** Not a git repo, or file exceeds `max_file_length` (40000 lines).
- **Blame not showing:** `current_line_blame` starts false — toggle with `Space hB`.
- **Signs clash with diagnostics:** Both use signcolumn; `sign_priority = 6` for gitsigns.
