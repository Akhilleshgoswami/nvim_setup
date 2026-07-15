# LSP

## Why it exists

Language Server Protocol integration provides go-to-definition, references, hover, rename, code actions, diagnostics, and inlay hints. Built on NvChad's LSP defaults with your servers, blink capabilities, and preserved keymaps.

## Features

- **Servers:** `lua_ls`, `gopls`, `ts_ls`, `eslint`
- Mason + mason-tool-installer for `stylua`, `prettier`, `prettierd`
- blink.cmp LSP capabilities
- Inlay hints enabled on attach
- Diagnostic virtual text with rounded float
- fidget.nvim LSP progress
- lazydev.nvim for Lua dev

## Configuration

| File | Purpose |
|------|---------|
| `lua/configs/lspconfig.lua` | Servers, diagnostics, on_attach keymaps |
| `lua/plugins/init.lua` | Mason, fidget, lazydev wiring |

## Commands

| Command | Action |
|---------|--------|
| `:Mason` | Install/manage LSP servers and tools |
| `:LspRestart` | Restart all language servers |
| `:LspInfo` | Show attached clients |
| `:lua vim.diagnostic.open_float()` | Diagnostic float |

`Space zig` maps to `:LspRestart`.

## Keymaps

Buffer-local when LSP attached:

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | References |
| `gI` | Implementation |
| `gy` | Type definition |
| `K` | Hover documentation |
| `Space rn` | Rename symbol |
| `Space ca` | Code action |
| `Space de` | Diagnostic float |
| `[d` / `]d` | Prev / next diagnostic |
| `Space q` | Diagnostics → location list |

Global:

| Key | Action |
|-----|--------|
| `Space f` | Format buffer (`vim.lsp.buf.format`) |

**Conflict:** `Space gd` is global Diffview; buffer-local `gd` wins when LSP attached.

## Usage

Open a supported file — Mason-installed servers attach automatically. Use `gd` to jump to definitions, `K` for docs, `Space ca` for quick fixes. Format with `Space f` or conform (see `conform.md`).

## Troubleshooting

- **No LSP:** `:Mason` → install `lua_ls`, `gopls`, `ts_ls`, or `eslint`. Restart buffer.
- **eslint not running:** Ensure `eslint` is in project or global install; check `:LspInfo`.
- **Format does nothing:** LSP format may be unavailable — use conform (`Space f` via conform if NvChad wires it).
- **`Space ca` does nothing:** Ensure LSP is attached (`:LspInfo`). For missing imports, wait for the diagnostic first.
