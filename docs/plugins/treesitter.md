# Treesitter

## Why it exists

`nvim-treesitter/nvim-treesitter` provides incremental syntax highlighting, indentation, and parsing — powers flash Treesitter, ufo folds, rainbow-delimiters, context comments, and blink label highlighting.

## Features

- Syntax highlighting (treesitter primary, no legacy regex)
- Indentation via treesitter
- NvChad base config extended with your parsers
- Build hook: `:TSUpdate` on install

### Ensured parsers

`bash`, `c`, `diff`, `html`, `lua`, `go`, `vim`, `vimdoc`, `javascript`, `typescript`, `tsx`, `javascriptreact`, `move`

## Configuration

`lua/plugins/tree-sitter.lua`

Extends `nvchad.configs.treesitter` with `ensure_installed` and highlight/indent opts.

## Commands

| Command | Action |
|---------|--------|
| `:TSInstall <lang>` | Install parser |
| `:TSUpdate` | Update all parsers |
| `:TSBufEnable` | Enable for buffer |
| `:TSBufDisable` | Disable for buffer |
| `:TSModuleInfo` | Show module status |

## Keymaps

No dedicated keymaps. Treesitter underpins other plugins (flash `S`, ufo folds, dropbar symbols).

## Usage

After first install, run `:TSUpdate` if highlights are missing. Open a `.tsx` file — Treesitter highlight should be active (check `:TSBufInfo`).

## Troubleshooting

- **No highlight:** `:TSInstall <filetype>` then restart buffer.
- **Parser compile error:** Need C compiler installed; check `:checkhealth nvim-treesitter`.
- **Slow on large files:** Consider disabling highlight for minified files via filetype plugin.
