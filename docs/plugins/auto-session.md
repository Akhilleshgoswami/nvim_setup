# Auto-Session

## Why it exists

`rmagatti/auto-session` saves and restores Neovim workspace sessions (buffers, windows, layout) per project directory — pick up where you left off.

## Features

- Manual save/restore (auto-restore disabled)
- Suppressed dirs: home, Dev, Downloads, Documents, Desktop
- nvdash shortcut `s` can restore session on startup

## Configuration

`lua/plugins/auto-session.lua`

`auto_restore_enabled = false` — sessions only restore on explicit `Space wr`.

## Commands

| Command | Action |
|---------|--------|
| `:SessionSave` | Save session |
| `:SessionRestore` | Restore session |
| `:SessionDelete` | Delete session |

## Keymaps

| Key | Action |
|-----|--------|
| `Space wr` | Restore session for cwd |
| `Space ws` | Save session |

## Usage

Before switching projects: `Space ws`. When returning: `Space wr`. nvdash `s` key also offers session restore on startup.

## Troubleshooting

- **Session not restoring:** Auto-restore is off — must use `Space wr` explicitly.
- **Wrong session loaded:** Sessions are cwd-based; `cd` to project root first.
- **Suppressed directory:** Home/Desktop paths won't auto-save — check `auto_session_suppress_dirs`.
