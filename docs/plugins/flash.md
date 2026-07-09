# Flash.nvim

## Why it exists

`folke/flash.nvim` provides lightning-fast jump labels across the screen and Treesitter-aware search — a modern alternative to easymotion/sneak. Bound to `s` / `S` (substitute keys were remapped to `Space sr` etc.).

## Features

- Character jump with labels (`s`)
- Treesitter node jump (`S`)
- Remote flash in operator-pending mode (`r`)
- Treesitter search (`R`)
- Cmdline flash search toggle (`Ctrl-s`)

## Configuration

`lua/plugins/flash.lua`

Default opts; keys defined in plugin spec.

## Commands

No user commands. All interaction via keymaps.

## Keymaps

| Key | Mode | Action |
|-----|------|--------|
| `s` | n, x, o | Flash jump |
| `S` | n, x, o | Flash Treesitter |
| `r` | o | Remote flash |
| `R` | o, x | Treesitter search |
| `Ctrl-s` | cmdline | Toggle flash search |

## Usage

Press `s` then type target characters — labels appear on screen; press the label key to jump. Use `S` in code files for Treesitter-aware targets (functions, blocks). In visual mode, `s` jumps then operates on the motion.

## Troubleshooting

- **Labels hard to see:** Check highlight groups after theme change; flash inherits Normal/Search highlights.
- **`s` does something else:** Substitute was remapped to `Space sr` — `s` should be free for flash.
- **Treesitter flash empty:** Run `:TSUpdate` for current filetype parser.
