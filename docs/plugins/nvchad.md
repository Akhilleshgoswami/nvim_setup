# NvChad

## Why it exists

NvChad v2.5 is the base framework for this config. It replaces the old custom `lualine`, `bufferline`, and standalone colorscheme plugins with NvChad's integrated UI stack: **base46** themes, **statusline**, **tabufline**, and **nvdash** startup screen.

## Features

- NvChad plugin bundle loaded from `NvChad/NvChad` (branch `v2.5`)
- **base46** theming with `onedark` as default (`lua/chadrc.lua`)
- **nvdash** dashboard on startup (replaces Snacks dashboard)
- **tabufline** buffer tabs with custom Tab / Shift-Tab / Shift-C bridge
- **statusline** with default theme
- Theme picker via `lua/core/theme.lua` (onedark, tokyonight, catppuccin, gruvbox, rosepine, nord, chadracula)
- NvChad defaults disabled where they conflict: nvim-tree, nvim-cmp, indent-blankline (`lua/plugins/overrides.lua`)

## Configuration

| File | Purpose |
|------|---------|
| `init.lua` | Bootstrap, Lazy.nvim, NvChad import |
| `lua/chadrc.lua` | UI: base46 theme, nvdash, tabufline, statusline |
| `lua/plugins/overrides.lua` | Disable conflicting NvChad plugins |
| `lua/mappings.lua` | Override NvChad keymaps (Snacks picker, Oil, buffers) |
| `lua/core/theme.lua` | Theme picker and cycling |
| `lua/options.lua` | Editor options layered on `nvchad.options` |

## Commands

| Command | Action |
|---------|--------|
| `:Lazy` | Plugin manager |
| `:Mason` | LSP / formatter installer |
| `:checkhealth` | Health checks |

## Keymaps

| Key | Action |
|-----|--------|
| `Tab` | Previous buffer (tabufline) |
| `Shift-Tab` | Next buffer |
| `Shift-C` | Close buffer |
| `Space cs` | Theme picker |
| `Space ct` | Next theme |
| `Space ca` | Auto theme (day/night) |

**Note:** `Space ca` is global (theme). LSP code action also uses `Space ca` buffer-locally when attached.

## Usage

1. On first launch, Lazy.nvim installs NvChad and all plugins.
2. nvdash appears on startup with shortcuts for find file, grep, recent, Mason, Lazy, quit.
3. Use `Space cs` to switch base46 themes; changes apply via NvChad's theme API.
4. Buffer cycling uses Tab keys instead of NvChad's default Shift-h / Shift-l.

## Troubleshooting

- **Wrong picker opens on `Space ff`:** Your `lua/mappings.lua` overrides should load after NvChad — verify Snacks mappings exist.
- **Two completion UIs:** Ensure `hrsh7th/nvim-cmp` stays disabled in `overrides.lua`.
- **No dashboard:** Check `M.nvdash.load_on_startup = true` in `chadrc.lua`.
- **Theme not applying:** Run `:Lazy reload base46` or restart Neovim after changing `chadrc.lua`.
