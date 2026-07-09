# hlchunk.nvim

## Why it exists

`shellRaining/hlchunk.nvim` replaces NvChad's indent-blankline (disabled in `overrides.lua`) with rainbow scope chunk lines and subtle indent guides — clearer block structure without clutter.

## Features

- **Chunk** — colored `╭─│╰` scope lines (treesitter-aware)
- **Indent** — muted `│` indent guides
- Blank line and line-number modules disabled
- Palette synced with `akhilesh.ui` colors
- Re-applies on ColorScheme change

## Configuration

`lua/plugins/indentaion.lua`

NvChad `indent-blankline.nvim` disabled in `lua/plugins/overrides.lua`.

## Commands

| Command | Action |
|---------|--------|
| `:HLChunkEnable` | Enable highlights |
| `:HLChunkDisable` | Disable highlights |

Snacks toggle: `Space uI` toggles indent (Snacks indent module — separate from hlchunk).

## Keymaps

No dedicated keymaps. Visual only.

## Usage

Open any code file — scope chunk borders appear around blocks. Indent guides show nesting depth in muted gray.

## Troubleshooting

- **Guides missing after theme change:** ColorScheme autocmd re-runs setup — wait or `:HLChunkEnable`.
- **Double indent guides:** Ensure indent-blankline stays disabled in overrides.
- **Performance in large files:** Chunk uses treesitter — may lag on huge buffers; disable chunk in opts if needed.
