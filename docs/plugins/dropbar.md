# Dropbar (Breadcrumbs)

## Why it exists

`Bekaboo/dropbar.nvim` renders a winbar breadcrumb trail — file path + LSP/Treesitter symbols. Quick navigation via pivot keys and symbol picker. Config lives in `barbecue.lua` (historical filename).

## Features

- Winbar: path › symbols with ` › ` separator
- Sources: path + LSP (fallback Treesitter)
- Markdown: path + markdown headings
- Symbol picker with letter pivots (`a`–`z`)
- Click symbols for context menu
- Excluded filetypes: nvdash, oil, lazy, mason, etc.
- Custom DropBar highlight groups

## Configuration

`lua/plugins/barbecue.lua`

## Commands

No user commands. API: `require("dropbar.api")`.

## Keymaps

| Key | Action |
|-----|--------|
| `Space ;` | Pick symbol in winbar |
| `[;` | Go to context start |
| `];` | Next context |

Click any winbar segment to open the dropbar menu.

## Usage

Open a code file — winbar shows `path › Module › function`. Press `Space ;` then a pivot letter to jump. Use `];` to walk into nested contexts.

## Troubleshooting

- **No winbar:** Buffer may be excluded (oil, help, lazy). Check `bar.enable` function.
- **Symbols missing:** LSP must attach; Treesitter parser required as fallback.
- **Menu icons broken:** Guard in config strips invalid `icons.kinds` booleans from stale lazy merges.
