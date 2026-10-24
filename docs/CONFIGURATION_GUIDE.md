# Neovim & WezTerm Configuration Guide

Comprehensive documentation for Neovim setup, real-time WezTerm theme synchronization, autocompletion, and folding workflows.

---

## 1. Dynamic WezTerm Theme Synchronization

Neovim and WezTerm are linked so that switching colorschemes in Neovim immediately updates WezTerm's background, foreground, tab bar, and status bar.

### How It Works

1. **Active Theme Resolution**:
   - When you switch colorschemes (via `:Theme`, `<leader>ut`, or `:colorscheme <name>`), Neovim's `ColorScheme` autocmd triggers `features.wezterm.sync_theme()`.
   - Even when transparent editor background is enabled (`transparent = true`), Neovim resolves the true canonical background and palette for the active theme instead of defaulting to a static fallback.

2. **Instant Terminal OSC Sequences**:
   - Neovim emits terminal escape sequences directly to stdout:
     - `\027]11;#RRGGBB\007` (OSC 11: Set background color)
     - `\027]10;#RRGGBB\007` (OSC 10: Set foreground color)
     - `\027]12;#RRGGBB\007` (OSC 12: Set cursor color)
   - This recolors your active WezTerm pane **instantly in real time** without any lag, even while scrolling through theme previews in Telescope.

3. **Persistent Sync File & Automatic Reload**:
   - Neovim writes `~/.config/wezterm/colors/nvim-sync.lua` containing the theme name, palette, and UI tokens.
   - Neovim automatically touches `~/.config/wezterm/wezterm.lua`, triggering WezTerm's native config file watcher to update tabs, inactive panes, and window chrome.

### Supported Themes

- **First-Party Bespoke Themes**: `kiln` (warm clay & ember default), `umbra`, `meridian`, `solder`, `loam`
- **External Themes Mapped to WezTerm**:
  - `gruvbox` → `Gruvbox Dark (Gogh)`
  - `tokyonight` (night, storm, moon, day) → `Tokyo Night` variants
  - `catppuccin` (mocha, macchiato, frappe, latte) → `Catppuccin` variants
  - `kanagawa` (wave, dragon, lotus) → `Kanagawa (Gogh)` variants
  - `rose-pine` (main, moon, dawn) → `rose-pine` variants
  - `everforest` → `Everforest Dark (Gogh)`
  - `nord` → `nord`
  - `onedark` / `onelight` → `OneDark (base16)`
  - `nightfox` (duskfox, nordfox, terafox, carbonfox, etc.) → `nightfox` variants
  - `oxocarbon` → `Oxocarbon`

### How to Switch Themes

- `:Theme` or `<leader>ut`: Opens Telescope theme picker with live preview.
- `:colorscheme <name>`: Directly activates any colorscheme (e.g., `:colorscheme gruvbox`).

---

## 2. Autocompletion & Non-Intrusive Suggestions

### Completion Engine: `blink.cmp` + `LuaSnip`

- High-performance, low-latency autocompletion powered by LSP, snippets, path completion, and buffer words.
- Clean floating completion menu with modern icon badges and documentation previews.

### Disabled Intrusive Jump Predictor (`neocursor`)

- `neocursor.nvim` was disabled (`enabled = false` in `lua/plugins/ai.lua`).
- **Why**: Neocursor inserted multi-line inline diff predictions, strike-through virtual text (`《neocursor · <Tab> jump`), and hijacked `<Tab>` presses, interrupting typing flow.
- **Result**: You retain clean, standard, predictable code completion without disruptive text rewrites or jumped cursors.

### Standard Keybindings

| Key | Mode | Description |
| --- | --- | --- |
| `<Tab>` | Insert | Accept selected completion / jump to next snippet placeholder / indent |
| `<S-Tab>` | Insert | Select previous completion item / jump to previous snippet placeholder |
| `<CR>` | Insert | Accept completion item |
| `<C-space>` | Insert | Manually trigger completion menu / toggle documentation |
| `<C-e>` | Insert | Cancel/dismiss completion popup |
| `<Up>` / `<Down>` | Insert | Navigate completion menu |

---

## 3. Code Folding

Code folding is driven by `kevinhwang91/nvim-ufo` combined with Treesitter and LSP folding ranges.

### Keybindings

| Key | Mode | Action |
| --- | --- | --- |
| **`za`** | Normal | **Toggle fold** under the cursor (open if closed, close if open) |
| **`zc`** | Normal | **Close fold** under cursor |
| **`zo`** | Normal | **Open fold** under cursor |
| **`zM`** | Normal | **Close all folds** in the entire buffer |
| **`zR`** | Normal | **Open all folds** in the entire buffer |
| **`zK`** | Normal | **Peek fold** (preview folded code in a hover popup without opening it) |
| **`V`** + select + **`zf`** | Visual | Manually fold any selected range of lines |

---

## 4. File Structure Overview

```
~/.config/nvim (-> ~/Desktop/nvim-12)
├── init.lua
├── lua/
│   ├── core/               # Options, keymaps, lazy.nvim bootstrap
│   ├── features/
│   │   ├── theme.lua       # Theme state persistence, picker command (:Theme)
│   │   └── wezterm.lua     # WezTerm theme synchronization & OSC emission
│   ├── plugins/
│   │   ├── ai.lua          # AI integrations (neocursor disabled, Avante, CodeCompanion)
│   │   ├── completion.lua  # blink.cmp configuration and keymaps
│   │   ├── lsp.lua         # LSP servers & nvim-ufo folding setup
│   │   └── themes.lua      # External colorscheme plugin specifications
│   └── themes/             # Bespoke theme palettes (kiln, umbra, loam, etc.)
└── docs/
    └── CONFIGURATION_GUIDE.md  # This document
```
