# Conform.nvim

## Why it exists

`stevearc/conform.nvim` runs external formatters on save and on demand — prettier for JS/TS, stylua for Lua, gofmt for Go, rustfmt for Rust. NvChad integrates conform with `vim.g.autoformat = true`.

## Features

- Per-filetype formatter mapping with fallback chain
- `prettierd` preferred over `prettier` (stop after first success)
- NvChad conform defaults + your overrides
- `:ConformInfo` shows active formatter

## Configuration

| File | Purpose |
|------|---------|
| `lua/configs/conform.lua` | Formatter by filetype |
| `lua/plugins/init.lua` | Conform plugin spec |
| `lua/options.lua` | `vim.g.autoformat = true` |

### Formatters by filetype

| Filetype | Formatter |
|----------|-----------|
| lua | stylua |
| rust | rustfmt |
| javascript / typescript / jsx / tsx | prettierd → prettier |
| go | gofmt |

## Commands

| Command | Action |
|---------|--------|
| `:ConformInfo` | Show formatter for current buffer |
| `:ConformFormat` | Format buffer |

## Keymaps

| Key | Action |
|-----|--------|
| `Space f` | Format buffer (LSP format in mappings; conform may also run on save) |

## Usage

Save a file — conform formats automatically when `autoformat` is on. Manual format: `Space f` or `:ConformFormat`. Install formatters via `:Mason` (stylua, prettier, prettierd).

## Troubleshooting

- **Not formatting on save:** Check `:ConformInfo` — formatter may be missing. Run `:Mason`.
- **Prettier fails:** Install `prettierd` globally or via Mason; falls back to `prettier`.
- **Go not formatted:** Ensure `gofmt` in PATH or install via Mason.
