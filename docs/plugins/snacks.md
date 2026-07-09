# Snacks.nvim

## Why it exists

`folke/snacks.nvim` is the primary workflow plugin: fuzzy finder, sidebar explorer, notifications, terminal, zen mode, git tools, and buffer delete. It replaces Telescope for daily navigation and overrides `vim.notify`.

## Features

- **Picker** — files, grep, buffers, LSP symbols, diagnostics, keymaps, git
- **Explorer** — sidebar file tree (`Space e`)
- **Notify / Notifier** — all `vim.notify` routed to Snacks at startup
- **Terminal** — floating terminal and Lazydocker
- **Zen mode** — distraction-free editing
- **Bufdelete** — smart buffer close (`Space bd`)
- **Git** — Lazygit, blame, browse, status, log
- **UI toggles** — wrap, spell, relative numbers, dim, indent guides
- **Dashboard DISABLED** — `dashboard.enabled = false`; NvChad nvdash handles startup

## Configuration

`lua/plugins/snaks.lua`

Key options: picker layout with preview, `ui_select = true`, explorer sidebar preset, notifier style `fancy`, zen toggles dim/statusline/tabline off.

## Commands

Snacks is driven by keymaps and Lua API (`Snacks.picker.*`, `Snacks.terminal`, etc.). No required user commands.

## Keymaps

### Find & open

| Key | Action |
|-----|--------|
| `Space ff` | Find files |
| `Space fg` | Live grep |
| `Space fr` | Recent files |
| `Space fp` | Projects |
| `Space fb` | Buffers |
| `Space /` | Grep open buffers |
| `Space e` | Explorer sidebar |

### Search

| Key | Action |
|-----|--------|
| `Space sg` | Live grep |
| `Space sw` | Grep word under cursor |
| `Space sf` | Search files |
| `Space sb` | Search lines in buffer |
| `Space sr` | Resume last picker |
| `Space sh` | Help tags |
| `Space sk` | Keymaps |
| `Space sc` | Commands |
| `Space sd` / `Space sD` | Diagnostics (project / buffer) |
| `Space ss` / `Space sS` | LSP symbols (doc / workspace) |
| `Space sT` | TODO comments |

### Git & terminal

| Key | Action |
|-----|--------|
| `Space gg` | Lazygit |
| `Space gb` | Blame line |
| `Space gs` | Git status |
| `Space tt` | Snacks terminal |
| `Space td` | Lazydocker |
| `Space z` | Zen mode |
| `Space un` | Dismiss notifications |

### Picker (when open)

`Esc` close · `Ctrl-j/k` move · `Ctrl-q` send to quickfix

## Usage

Press `Space ff` to find files — this is the main entry point. Use `Space e` for a persistent sidebar explorer. Notifications from LSP, formatters, and plugins appear via Snacks notifier (top-right, fancy style).

## Troubleshooting

- **Dashboard still shows:** Confirm `dashboard.enabled = false` in `snaks.lua`; nvdash should load instead.
- **`Space sr` does substitute:** Substitute plugin loads later and wins — see `substitute.md`.
- **Explorer empty:** Ensure you're inside a git/project root; try `Space fp` for projects.
- **Notify not styled:** Snacks `init` must run early (`lazy = false`, `priority = 1000`).
