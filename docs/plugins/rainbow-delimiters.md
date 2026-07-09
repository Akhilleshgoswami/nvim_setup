# Rainbow Delimiters

## Why it exists

`HiPhish/rainbow-delimiters.nvim` colorizes matching brackets/parens/tags in distinct colors — makes deeply nested code (JSX, Lua, HTML) readable at a glance.

## Features

- Rainbow colors for `()`, `[]`, `{}`, JSX/TSX tags
- Per-language query: `rainbow-blocks` for Lua, `rainbow-delimiters-react` for JS, `rainbow-tags` for HTML
- 7-color palette (Tokyo Night–aligned)
- Priority system avoids Treesitter conflicts

## Configuration

`lua/plugins/ui-extras.lua` (rainbow-delimiters section)

Highlight groups: RainbowDelimiter1–7 with custom hex colors.

## Commands

| Command | Action |
|---------|--------|
| `:RainbowDelimit` | Enable (if disabled) |
| `:RainbowDelimitDisable` | Disable |

## Keymaps

No keymaps. Colors apply automatically when Treesitter parses the buffer.

## Usage

Open a nested JSX or Lua file — each paren/bracket level gets a different color (blue → green → amber → purple → cyan → orange → red).

## Troubleshooting

- **All one color:** Treesitter parser missing — `:TSInstall javascript` / `tsx` / `lua`.
- **Wrong nesting in TSX:** Uses `rainbow-delimiters-react` query — update plugin if React syntax breaks.
- **Conflict with other rainbow plugins:** Only one rainbow plugin should be active.
