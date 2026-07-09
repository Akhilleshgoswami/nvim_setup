# Todo Comments

## Why it exists

`folke/todo-comments.nvim` highlights `TODO`, `FIXME`, `HACK`, `NOTE`, etc. in comments and provides jump navigation — keeps technical debt visible while coding.

## Features

- Highlight TODO/FIXME/NOTE/etc. in comments
- Jump next/prev todo in buffer
- Telescope integration (`Space fj`)
- Snacks picker integration (`Space sT`)

## Configuration

`lua/plugins/todo-comments.lua`

Also a dependency of `telescope.lua` for `:Telescope todo`.

## Commands

| Command | Action |
|---------|--------|
| `:TodoTrouble` | Todo list in Trouble (if trouble.nvim added) |
| `:Telescope todo` | Search all TODOs |

## Keymaps

| Key | Action |
|-----|--------|
| `]t` | Next TODO comment |
| `[t` | Previous TODO comment |
| `Space sT` | Search TODOs (Snacks) |
| `Space fj` | TODO picker (Telescope) |

## Usage

Write `// TODO: fix this` in code — it highlights. `]t` jumps to the next marker project-wide in buffer. `Space sT` searches all TODOs across the project.

## Usage tip

Customize keywords in `todo-comments.setup({ keywords = { ... } })` if you need project-specific tags.

## Troubleshooting

- **Not highlighting:** Ensure comment syntax is recognized — treesitter highlight helps.
- **Jump skips items:** `]t` searches current buffer by default; use `Space sT` for project-wide.
- **Telescope todo empty:** No TODO comments in project, or wrong cwd.
