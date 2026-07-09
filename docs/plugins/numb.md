# Numb.nvim

## Why it exists

`nacro90/numb.nvim` previews line numbers while typing a line number in cmdline mode — jump to line `:42` with live peek before pressing Enter.

## Features

- Peek target line while typing `:123`
- Shows line numbers and cursorline in peek window
- Lightweight, no keymaps required

## Configuration

`lua/plugins/numb.lua`

```lua
show_numbers = true
show_cursorline = true
```

## Commands

Activated automatically when typing `:` followed by digits in cmdline mode. No explicit command.

## Keymaps

| Input | Action |
|-------|--------|
| `:42` (typing) | Peek line 42 before Enter |
| `:42` + `Enter` | Jump to line 42 |

Works with any cmdline line-number jump (`:123`, `:.+5`, etc. depending on numb support).

## Usage

Type `:50` — a peek window highlights line 50. Press Enter to jump or Esc to cancel.

## Troubleshooting

- **Peek not showing:** Ensure numb loaded (`BufReadPre` event). Check `:Lazy` for numb.nvim.
- **Overlaps with Noice cmdline:** Both style cmdline — if issues, adjust noice cmdline position.
- **Wrong line highlighted:** Peek is approximate during partial input — complete the number.
