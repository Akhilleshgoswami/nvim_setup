# Which-Key

## Why it exists

`folke/which-key.nvim` shows a popup of available keymaps after pressing `Space` (leader) — essential for discovering the large keymap surface in this config.

## Features

- Modern preset with rounded border
- 300ms timeout (`timeoutlen` set in init)
- Theme-adaptive highlights (WhichKey, WhichKeyGroup, WhichKeyDesc)
- Preset groups for operators, motions, windows, `z`, `g`
- Custom group labels for leader prefixes

## Configuration

`lua/plugins/which-key.lua`

## Commands

| Command | Action |
|---------|--------|
| `:WhichKey` | Open which-key |
| `:WhichKey <prefix>` | Show keys for prefix |

## Keymaps

| Key | Action |
|-----|--------|
| `Space` (pause) | Open which-key popup |

### Documented groups (spec)

| Prefix | Group |
|--------|-------|
| `Space f` | Find |
| `Space g` | Git |
| `Space h` | Hunk |
| `Space s` | Search |
| `Space u` | UI toggles |
| `Space t` | Toggle (terminal) |
| `Space b` | Buffer |
| `Space w` | Window |

Also: `Space sk` (Snacks) searches all keymaps programmatically.

## Usage

Press `Space` and wait ~200ms — groups appear (`f` Find, `s` Search, `h` Hunk, etc.). Type the next key to see leaf bindings or execute.

## Troubleshooting

- **Popup too slow:** Reduce `delay` in opts (default 200ms).
- **Missing new keymaps:** Add `{ "<leader>x", group = "..." }` to `spec` in which-key.lua.
- **Conflicts not shown:** which-key lists bindings, not conflicts — use `Space sk` or `:map <leader>q`.
