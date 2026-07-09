# Comment.nvim

## Why it exists

`numToStr/Comment.nvim` toggles line and block comments with simple operators. Integrated with `nvim-ts-context-commentstring` for correct JSX/TSX comment syntax.

## Features

- Line toggle: `gcc`
- Block toggle: `gbc`
- Operator-pending: `gc` + motion
- Block operator: `gb` + motion
- Context-aware commentstring for TS/JSX via treesitter

## Configuration

`lua/plugins/comments.lua`

`ts_context_commentstring` with `pre_hook` for block/visual comment detection.

## Commands

| Command | Action |
|---------|--------|
| `:ToggleComment` | Toggle comment (if exposed) |

Primary workflow uses keymaps, not commands.

## Keymaps

| Key | Action |
|-----|--------|
| `gcc` | Toggle line comment |
| `gbc` | Toggle block comment |
| `gc` + motion | Comment motion (e.g. `gcap`, `gc3j`) |
| `gb` + motion | Block comment motion |

## Usage

`gcc` on a line toggles `//` or `#` depending on filetype. In JSX, `gcc` uses `{/* */}` via context commentstring. Visual select + `gc` comments the selection.

## Troubleshooting

- **Wrong comment style in TSX:** Ensure treesitter parser installed (`tsx`, `javascriptreact`).
- **`gc` not working in operator mode:** Must wait for operator — `gc` then motion key.
- **Conflict with nvim default:** Comment.nvim replaces native comment behavior when loaded.
