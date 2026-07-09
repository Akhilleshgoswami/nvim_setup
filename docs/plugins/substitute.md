# Substitute.nvim

## Why it exists

`gbprod/substitute.nvim` replaces text with the contents of a register using operator-pending motions — faster than visual replace-paste. Remapped from `s`/`S` to `Space sr`/`Space sl`/`Space sS` to avoid flash.nvim conflict.

## Features

- Operator substitute with motion (`Space sr`)
- Line substitute (`Space sl`)
- Substitute to end of line (`Space sS`)
- Visual mode substitute (`Space sr` in visual)
- **Rip substitute** companion: `Space srf` (see `nvim-rip.lua`)

## Configuration

| File | Purpose |
|------|---------|
| `lua/plugins/subsitutie.lua` | substitute.nvim keymaps |
| `lua/plugins/nvim-rip.lua` | nvim-rip-substitute popup UI |

## Commands

No commands. Register-based: yank text first, then substitute.

## Keymaps

| Key | Action |
|-----|--------|
| `Space sr` | Substitute with motion (n + visual) |
| `Space sl` | Substitute line |
| `Space sS` | Substitute to EOL |
| `Space srf` | Rip substitute (regex UI) |

**Rip substitute popup:** `Enter` confirm · `q` close · `Ctrl-j/k` cycle · `Ctrl-f` fixed strings · `Ctrl-c` ignore case

**Conflicts:** `Space sr` / `Space sS` also bound by Snacks (resume / workspace symbols). Substitute loads later and wins.

## Usage

1. Yank replacement text: `yy` or visual yank.
2. `Space sr` then motion (e.g. `w`, `iw`, `ap`) to replace.
3. For regex replace across file, use `Space srf`.

## Troubleshooting

- **Nothing replaced:** Default register must hold text — yank first.
- **Snacks opens instead:** Plugin load order — substitute should load after Snacks.
- **Rip popup off-screen:** Adjust `popupWin.position` in `nvim-rip.lua`.
