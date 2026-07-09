# Harpoon

## Why it exists

`ThePrimeagen/harpoon` (v2) marks quick-access files for fast switching — like a project-specific bookmark list pinned to Ctrl-h/n/s slots.

## Features

- Add current file to harpoon list
- Quick menu toggle
- Jump to slots 1, 3, 4 (slot 2 commented out)
- Custom highlight groups (HarpoonActive, HarpoonNumberActive) in `mappings.lua`

## Configuration

`lua/plugins/harpoon.lua`

Uses harpoon2 branch with plenary dependency.

## Commands

No dedicated commands. API: `require("harpoon"):list()`.

## Keymaps

| Key | Action |
|-----|--------|
| `Space a` | Add file to list |
| `Ctrl-m` | Toggle harpoon menu |
| `Ctrl-h` | Jump to file 1 |
| `Ctrl-n` | Jump to file 3 |
| `Ctrl-s` | Jump to file 4 |

**Note:** `Ctrl-s` conflicts with Oil horizontal split inside Oil buffers only.

## Usage

Open a file you visit often → `Space a` to mark it. `Ctrl-m` opens the menu to reorder/remove. `Ctrl-h` jumps to your primary file instantly.

## Troubleshooting

- **Menu empty:** Add files with `Space a` first.
- **Marks lost:** Harpoon persists per project; ensure you're in the same git root.
- **Want slot 2:** Uncomment `Ctrl-r` mapping in `harpoon.lua`.
