# nvim-colorizer

## Why it exists

`NvChad/nvim-colorizer.lua` previews hex/rgb/hsl/css colors inline — essential for frontend work, Tailwind classes, and theme editing.

## Features

- Background color swatches for hex, rgb, hsl, css functions
- Tailwind class color preview
- Virtual text icon `󱓻` fallback
- Enabled for all filetypes except lazy/nvdash/dashboard
- `always_update = true` for live edits

## Configuration

`lua/plugins/ui-extras.lua` (colorizer section)

Uses NvChad's bundled colorizer plugin.

## Commands

| Command | Action |
|---------|--------|
| `:ColorizerToggle` | Toggle for current buffer |
| `:ColorizerAttachToBuffer` | Attach to buffer |
| `:ColorizerDetachFromBuffer` | Detach from buffer |

## Keymaps

No default keymaps. Colors appear automatically when hex/rgb values are present.

## Usage

Open a CSS/TSX file with `#7aa2f7` or `rgb(122, 162, 247)` — background tint appears behind the value. Tailwind `bg-blue-500` classes also colorize when supported.

## Troubleshooting

- **No preview:** Filetype may be excluded — check `filetypes` in opts.
- **Performance:** Disable on huge files with `:ColorizerDetachFromBuffer`.
- **Wrong color:** `names = false` — only hex/rgb/hsl parsed, not named colors like `red`.
