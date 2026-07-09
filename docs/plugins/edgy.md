# Edgy.nvim

## Why it exists

`folke/edgy.nvim` creates an IDE-style layout — docks explorers, terminals, quickfix, help, Lazy, and messages into fixed edge windows instead of floating everywhere.

## Features

- **Left:** Snacks explorer, Oil file buffers (`buftype=acwrite`)
- **Bottom:** Snacks terminals (bottom position), quickfix, help, noice messages, Lazy
- Animated edges disabled for snappy feel
- Winbar titles per pane (" Explorer ", " Files ", etc.)
- Highlights synced with `akhilesh.ui` (EdgyWinBar, EdgyBorder)

## Configuration

`lua/plugins/eady.lua`

Sizes: left 38 cols, bottom 12 lines, right 50 (empty), top 10.

## Commands

No commands. Layout reacts automatically when supported buffers open.

## Keymaps

No dedicated Edgy keymaps. Open sources normally:

| Key | Opens in Edgy |
|-----|---------------|
| `Space e` | Left — Snacks explorer |
| `-` / `Space oe` | Left — Oil (when acwrite) |
| `Space tt` | Bottom — Snacks terminal (bottom) |
| `:Lazy` | Bottom — Lazy panel |

## Usage

Press `Space e` — explorer docks left instead of overlapping code. Terminals opened via Snacks with bottom position snap to the bottom edge. Close panes by closing the buffer (`q` in Oil, etc.).

## Troubleshooting

- **Explorer not docking:** Check buffer `filetype` is `snacks_explorer` or `snacks_picker_list`.
- **Double sidebar:** Close floating explorer before opening Edgy dock.
- **Layout stuck:** `:Edgy` reload or restart Neovim; check for conflicting window plugins.
