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
| `Tab` | Insert | Accept selected item (VS Code-style) / snippet jump |
| `Shift-Tab` | Insert | Prev item / snippet backward |
| `↑` / `↓` | Insert | Move selection |
| `Ctrl-n` / `Ctrl-p` | Insert | Next / prev item |
| `Enter` | Insert | Accept completion |
| `Ctrl-Space` | Insert | Show menu / toggle docs |
| `Ctrl-e` | Insert | Cancel menu |
| `Ctrl-j` / `Ctrl-k` | Insert | Scroll documentation |
| `Space ca` | Normal | Code action (auto-import missing symbols) |

Cmdline completion is **disabled** (`cmdline.enabled = false`).

## Usage

Start typing in any LSP-attached buffer — the menu appears automatically. Press **`Tab`** or **`Enter`** to accept. For TypeScript/JS, accepting an unimported symbol should insert the import. If not, use `Space ca` → "Add missing import".

## Troubleshooting

- **No completions:** Run `:LspInfo` — ensure `ts_ls` (or other server) is attached. Run `:Mason` to install missing servers.
- **Tab does nothing:** Make sure you are in **insert mode** and the completion menu is visible (`Ctrl-Space` to force it).
- **No auto-import:** Accept via `Tab`/`Enter` (menu item must be from LSP). Or `Space ca` → add missing import.
- **Snippets missing:** Check `snippets/` folder and `:LuaSnip` load path in blink config.
- **Copilot not showing:** `blink-copilot` is async; wait briefly. Check network if using remote model.
- **Two completion menus:** Verify `nvim-cmp` is disabled in `lua/plugins/overrides.lua`.
