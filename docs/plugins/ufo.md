# nvim-ufo (Folding)

## Why it exists

`kevinhwang91/nvim-ufo` provides LSP- and Treesitter-aware folding with clean fold text, peek preview, and import/comment-aware open — replaces manual fold management with smart providers.

## Features

- Treesitter + indent fold providers (per filetype)
- Fold level 99 (all folds open by default, fold on demand)
- Custom fold virt text with line count ellipsis
- Peek folded lines under cursor (or LSP hover fallback)
- `foldcolumn = "0"` for clean gutter
- Close fold kinds: imports, comments (via `zr`)

## Configuration

`lua/plugins/folds.lua`

Init sets `foldlevel = 99`, `foldenable = true`, `signcolumn = "yes:1"`.

## Commands

No dedicated commands. Uses fold keymaps below.

## Keymaps

| Key | Action |
|-----|--------|
| `Space fc` / `Space fe` | Fold / unfold at cursor |
| `Space fa` | Toggle fold at cursor |
| `Space fR` / `Space fM` | Open all / close all folds |
| `Space fk` | Peek fold under cursor |
| `zc` / `zo` / `za` | Fold / unfold / toggle (Vim keys) |
| `zC` / `zO` | Fold / unfold recursively |
| `zR` | Open all folds |
| `zM` | Close all folds |
| `zr` | Open folds except imports/comments |
| `zp` | Peek fold (or LSP hover) |

Standard Vim `zc`/`zo`/`za` still work for individual folds.

## Usage

Fold code with `za` on a line or `zM` to collapse all. `zr` opens everything except import blocks. `zp` previews folded content in a float without opening.

## Troubleshooting

- **No folds:** Ensure Treesitter parser installed for filetype. `:TSUpdate`.
- **Folds wrong in Python:** Provider set to `indent` only for python in config.
- **Fold column visible:** Config forces `foldcolumn = "0"` — if visible, check another plugin overriding.
