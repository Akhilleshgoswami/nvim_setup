# Vim Maximizer

## Why it exists

`szw/vim-maximizer` temporarily maximizes the current split to full window — useful when you need focus on one buffer, then restore the previous layout.

## Features

- Toggle maximize on current window
- Preserves split layout when toggled off
- Zero config beyond keymap

## Configuration

`lua/plugins/vim-maximizer.lua`

## Commands

| Command | Action |
|---------|--------|
| `:MaximizerToggle` | Maximize / restore split |

## Keymaps

| Key | Action |
|-----|--------|
| `Space m` | Maximize / restore split |

## Usage

In a split layout, `Space m` expands current window to full size. Press `Space m` again to restore original splits.

## Troubleshooting

- **Layout not restored:** Avoid creating new splits while maximized; toggle off first.
- **Conflicts with nvdash `m`:** Dashboard `m` is Mason — only applies on startup screen.
- **Edgy layout breaks:** Maximizer may conflict with Edgy docks — close edge panels first.
