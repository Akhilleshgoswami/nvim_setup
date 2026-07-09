# Noice + Dressing

## Why it exists

`folke/noice.nvim` beautifies cmdline, routes messages, and shows LSP progress. `stevearc/dressing.nvim` styles vim.ui input/select dialogs (rename, code actions). Both live in `ui-polish.lua`.

## Features

### Noice
- Styled cmdline popup (`:`, `/`, `?`, `!`, lua)
- LSP progress in mini view (throttled)
- Message routing — filters noisy `"X fewer lines"` to mini
- Popupmenu backend disabled (blink handles completion)
- LSP hover delegated to blink; noice docs view for some LSP messages

### Dressing
- Rounded input prompts (relative to cursor)
- Select UI for code actions (centered, 80% width)
- Builtin + fzf backends

## Configuration

`lua/plugins/ui-polish.lua`

Highlights: NoiceCmdlinePopupBorder, NoiceMini synced with `akhilesh.ui` palette.

## Commands

| Command | Action |
|---------|--------|
| `:Noice` | Noice command palette |
| `:NoiceHistory` | Message history |
| `:NoiceDismiss` | Dismiss notifications |

## Keymaps

No dedicated leader keymaps. Noice activates automatically for `:`, `/`, LSP progress.

Dressing intercepts `vim.ui.input` and `vim.ui.select` — used by LSP rename (`Space rn`), code actions (`Space ca`).

## Usage

Type `:` — cmdline appears as a centered popup. LSP indexing shows a mini progress indicator. Rename symbol prompts use Dressing's rounded input.

## Troubleshooting

- **Double notifications:** Snacks also handles `vim.notify` — both coexist; Noice routes some LSP messages separately.
- **Progress overlap with fidget:** Both enabled intentionally; disable one in config if cluttered.
- **Cmdline not popup:** Ensure noice loaded (`VeryLazy` event) and not overridden.
