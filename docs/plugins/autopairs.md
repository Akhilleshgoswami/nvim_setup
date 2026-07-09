# nvim-autopairs

## Why it exists

`windwp/nvim-autopairs` automatically inserts closing brackets/quotes and skips over existing pairs — pairs with blink.cmp for bracket-aware completion accept.

## Features

- Auto-insert `)`, `]`, `}`, quotes on open pair
- Skip closing pair when already present
- Fast-close on `<CR>` in pairs
- Works with Treesitter (when configured by plugin)
- blink.cmp `auto_brackets.enabled = true` complements autopairs

## Configuration

`lua/plugins/auto-pairs.lua`

Minimal setup: `require("nvim-autopairs").setup({})`

Loads on `InsertEnter` event.

## Commands

No commands.

## Keymaps

No custom keymaps — behavior is automatic in insert mode:

| Action | Result |
|--------|--------|
| Type `(` | Inserts `()` with cursor inside |
| Type `)` when `)` exists | Skips over existing `)` |
| Type `"` inside string | May auto-close or skip depending on context |

## Usage

Type normally in insert mode — pairs auto-close. blink.cmp also adds brackets on completion accept for functions.

## Troubleshooting

- **Double brackets from cmp + autopairs:** blink `auto_brackets` and autopairs both active — usually coordinated; disable one if duplicates appear.
- **Not working in `:` cmdline:** Autopairs is insert-mode buffer only.
- **Lua string weirdness:** Treesitter-aware pairing may differ in `[[` long strings.
