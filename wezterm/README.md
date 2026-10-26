# WezTerm — Modular Configuration

Premium, maintainable WezTerm setup with Neovim theme sync.

## Layout

```text
~/.config/wezterm/
├── wezterm.lua                 # Tiny entrypoint
├── colors/
│   └── nvim-sync.lua           # Auto-written by Neovim (do not edit)
├── lua/
│   ├── core/                   # Config assembly
│   │   ├── init.lua            # Wires every module
│   │   ├── config.lua          # Preferences (fonts, opacity, FPS…)
│   │   ├── fonts.lua
│   │   ├── colors.lua
│   │   ├── window.lua
│   │   ├── tabbar.lua
│   │   ├── terminal.lua
│   │   ├── performance.lua
│   │   ├── appearance.lua
│   │   └── keys.lua
│   ├── themes/                 # Fallback palettes (when sync is absent)
│   │   ├── umbra.lua
│   │   ├── github.lua
│   │   ├── catppuccin.lua
│   │   ├── tokyonight.lua
│   │   └── kanagawa.lua
│   ├── events/                 # wezterm.on handlers
│   │   ├── smart-tab.lua
│   │   ├── smart-title.lua
│   │   ├── update-status.lua
│   │   ├── workspace.lua
│   │   └── startup.lua
│   ├── sync/
│   │   └── nvim-sync.lua       # Reads colors/nvim-sync.lua + watches it
│   └── utils/
│       ├── icons.lua
│       ├── colors.lua
│       ├── helpers.lua
│       ├── platform.lua
│       └── logger.lua
└── README.md
```

## How it loads

1. `wezterm.lua` sets `package.path` and creates a config builder.
2. `core.setup` applies fonts → window → performance → tabbar → terminal → colors → keys.
3. Event modules register tab titles and the right status bar.

## Neovim theme sync

Neovim (`features/wezterm.lua`) writes `colors/nvim-sync.lua` on every `:Theme` / `ColorScheme` change.

WezTerm watches that file (`add_to_config_reload_watch_list`) and reloads instantly.

**Do not edit `colors/nvim-sync.lua` by hand** — it is overwritten by Neovim.

If the sync file is missing (fresh machine), WezTerm uses the fallback theme from `lua/core/config.lua` → `fallback_theme` (default `umbra`).

## Customization

Edit **`lua/core/config.lua`** for everyday tweaks:

| Key | Purpose |
|-----|---------|
| `fonts.size` / `line_height` | Typography |
| `window.opacity` / `macos_blur` | Frosted glass |
| `window.padding` | Breathing room |
| `performance.max_fps` | Smoothness |
| `tabbar.hide_if_only_one` | Clean single-tab look |
| `fallback_theme` | Offline palette (`umbra`, `catppuccin`, …) |
| `leader` | Tmux-style leader key |

Add a new fallback theme by creating `lua/themes/mytheme.lua` and registering it in `lua/sync/nvim-sync.lua` → `THEME_MODULES`.

## Keybindings (unchanged)

### Leader (`Ctrl-a`)

| Keys | Action |
|------|--------|
| `\` / `-` | Split horizontal / vertical |
| `h j k l` | Focus pane |
| `z` | Zoom pane |
| `x` | Close pane |
| `t` / `w` | New / close tab |
| `n` / `p` | Next / prev tab |
| `1`–`9` | Jump to tab |
| `[` | Copy mode |
| `f` | Search |
| `Space` | Quick select |
| `r` | Reload config |
| `P` | Command palette |
| `Ctrl-a` | Send literal Ctrl-a (Neovim increment) |

### macOS ⌘

| Keys | Action |
|------|--------|
| `⌘D` / `⌘⇧D` | Split |
| `⌘T` | New tab |
| `⌘W` | Close pane |
| `⌘⇧[` / `]` | Cycle tabs |
| `⌘1`–`9` | Jump to tab |
| `⌘F` | Search |
| `⌘K` | Clear scrollback |
| `⌘⇧P` | Command palette |
| `⌘⇧Enter` | Fullscreen |
| `⌘-` / `=` / `0` | Font size |

## Status bar

Right status shows (when available):

`theme │ workspace │ folder │ battery │ host │ clock`

Tab titles are process-aware (`Neovim`, `Node`, `Go`…) or show the cwd / git branch in a shell.

## Debug

```bash
WEZTERM_DEBUG=1 wezterm
```

## Archive

Previous flat modules live in `lua/_archive/` for reference and can be deleted once you are comfortable with the new layout.
