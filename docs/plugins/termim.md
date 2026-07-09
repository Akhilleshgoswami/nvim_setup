# Termim.nvim

## Why it exists

`2kabhishek/termim.nvim` provides `:Fterm`, `:Sterm`, `:Vterm` commands for floating, horizontal, and vertical terminals with theme-adaptive borders and clean TermOpen settings.

## Features

- Floating (`Fterm`), horizontal (`Sterm`), vertical (`Vterm`) terminals
- Rounded borders, theme-synced highlights
- Auto insert mode on open; clean terminal options (no numbers, no signcolumn)
- Terminal keymaps: `Esc` → normal, `Ctrl-h/j/k/l` → split navigation
- Complements Snacks terminal (`Space tt`) for quick tasks

## Configuration

`lua/plugins/treminal.lua`

## Commands

| Command | Action |
|---------|--------|
| `:Fterm` / `:FTerm` | Floating terminal |
| `:Sterm` / `:STerm` | Horizontal split terminal |
| `:Vterm` / `:VTerm` | Vertical split terminal |

## Keymaps

| Key | Action |
|-----|--------|
| `Space t` | Horizontal terminal (`:Sterm`) — core mapping |
| `Space tf` | Floating terminal |
| `Space th` | Horizontal terminal |
| `Space tv` | Vertical terminal |

### Inside terminal (TermOpen)

| Key | Action |
|-----|--------|
| `Esc` | Exit to normal mode |
| `Ctrl-h/j/k/l` | Move to adjacent split |

**Note:** `Space t` also grouped under which-key "Toggle". Snacks `Space tt` is a separate terminal.

## Usage

`Space t` for a quick horizontal shell at the bottom. `Space tf` for a floating overlay. Use `Ctrl-h/j/k/l` to jump back to code splits.

## Troubleshooting

- **Terminal tiny:** Resize splits manually; Edgy may dock bottom terminals.
- **Esc closes terminal:** Esc only exits insert → normal in terminal buffer; `:q` to close.
- **Shell not starting:** Check `$SHELL` env var and termim plugin loaded (`:Lazy`).
