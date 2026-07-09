# nvim-surround

## Why it exists

`kylechui/nvim-surround` adds, changes, and deletes paired delimiters (quotes, brackets, tags) around text objects — essential for HTML, JSX, and string editing.

## Features

- Add surround: `ys{motion}{char}`
- Delete surround: `ds{char}`
- Change surround: `cs{old}{new}`
- Works with treesitter text objects
- Stable release pinned (`version = "*"`)

## Configuration

`lua/plugins/surround.lua`

`config = true` — uses plugin defaults.

## Commands

No commands. All via default keymaps.

## Keymaps

| Key | Action |
|-----|--------|
| `ys{motion}{char}` | Add surround (e.g. `ysiw"` → quote word) |
| `ds{char}` | Delete surround (e.g. `ds"` ) |
| `cs{old}{new}` | Change surround (e.g. `cs"'` ) |

Common chars: `"` `'` `` ` `` `(` `)` `[` `]` `{` `}` `t` (tag).

## Usage

To wrap a word in double quotes: `ysiw"`. To change single to double quotes: `cs'"`. To remove parens: `ds(`.

## Troubleshooting

- **Tag surround (`t`):** Prompts for tag name in HTML/JSX buffers.
- **Conflict with other `s` plugins:** Surround uses `ys`/`ds`/`cs` prefix — no conflict with flash `s`.
- **Visual mode:** Prefix with `yS` for line-wise surround (plugin default).
