# blink.cmp

## Why it exists

`saghen/blink.cmp` replaces NvChad's default `nvim-cmp` (disabled in `overrides.lua`). It provides fast LSP completion, snippets, Copilot-style suggestions, and ripgrep word completion in one menu.

## Features

- LSP, path, snippets, buffer, **Copilot** (`blink-copilot`), **ripgrep** completions
- Ghost text for inline suggestions
- Auto brackets on accept
- Signature help with rounded border
- Treesitter-highlighted completion labels
- LuaSnip + friendly-snippets + custom snippets in `snippets/`
- SQL filetype: dadbod completion provider

## Configuration

`lua/plugins/blink.lua`

NvChad cmp is disabled; blink loads with `lazy = false`. LSP capabilities are merged in `lua/configs/lspconfig.lua` via `blink.get_lsp_capabilities()`.

## Commands

No dedicated commands. Completion is automatic in insert mode.

## Keymaps

| Key | Mode | Action |
|-----|------|--------|
| `Tab` | Insert | Next snippet stop / next item |
| `Shift-Tab` | Insert | Prev snippet stop / prev item |
| `Ctrl-Space` | Insert | Show menu / toggle docs |
| `Ctrl-e` | Insert | Hide menu |
| `Ctrl-j` / `Ctrl-k` | Insert | Scroll documentation |
| `Enter` | Insert | Accept completion |

Cmdline completion is **disabled** (`cmdline.enabled = false`).

## Usage

Start typing in any LSP-attached buffer — the menu appears automatically. Press `Ctrl-Space` to force-open or view docs. In snippet fields, `Tab` jumps between placeholders. Copilot and ripgrep sources appear alongside LSP results (ripgrep needs 4+ char prefix).

## Troubleshooting

- **No completions:** Run `:LspInfo` — ensure server attached. Run `:Mason` to install missing servers.
- **Snippets missing:** Check `snippets/` folder and `:LuaSnip` load path in blink config.
- **Copilot not showing:** `blink-copilot` is async; wait briefly. Check network if using remote model.
- **Two completion menus:** Verify `nvim-cmp` is disabled in `lua/plugins/overrides.lua`.
