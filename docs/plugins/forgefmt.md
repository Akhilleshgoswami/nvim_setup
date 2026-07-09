# Forgefmt (Solidity)

## Why it exists

`mmsaki/forgefmt.nvim` formats Solidity (`.sol`) files using `forge fmt` from Foundry — the standard formatter for Ethereum smart contract development.

## Features

- Auto-format on save for `solidity` and `sol` filetypes
- Foundry `forge fmt` integration
- Lazy-loads on Solidity filetypes only

## Configuration

`lua/plugins/sol-formater.lua`

```lua
require("forgefmt").setup({ auto_format = true })
```

## Commands

Forgefmt runs automatically. Manual format via conform if configured, or:

| Command | Action |
|---------|--------|
| `:ForgeFmt` | Format buffer (if exposed by plugin) |

Typically saving the buffer triggers format.

## Keymaps

None. Use `Space w` (save) to trigger auto-format, or `Space f` if LSP format available.

## Usage

Install Foundry (`forge` in PATH). Open a `.sol` file, edit, save — `forge fmt` runs automatically.

## Troubleshooting

- **Not formatting:** Install Foundry: `curl -L https://foundry.paradigm.xyz | bash && foundryup`
- **`forge` not in PATH:** Neovim must inherit PATH with `~/.foundry/bin`.
- **Format errors:** Run `forge fmt` manually in terminal to see syntax errors.
