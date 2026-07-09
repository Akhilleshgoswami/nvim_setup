# Telescope

## Why it exists

`nvim-telescope/telescope.nvim` remains as a **fallback picker** with NvChad styling. Snacks handles daily find/grep; Telescope covers colorscheme picking and TODO search where Snacks doesn't replace it.

## Features

- NvChad telescope config (`require "nvchad.configs.telescope"`)
- Extensions: fzf-native, ui-select, file-browser, todo-comments
- Theme picker fallback in `lua/core/theme.lua` when NvChad themes API unavailable
- Only two leader keymaps — rest via `:Telescope` command

## Configuration

`lua/plugins/telescope.lua`

Opts pulled from NvChad defaults; extensions loaded in config function.

## Commands

| Command | Action |
|---------|--------|
| `:Telescope` | Open Telescope picker list |
| `:Telescope find_files` | Find files |
| `:Telescope live_grep` | Live grep |
| `:Telescope colorscheme` | Theme picker |
| `:Telescope todo` | TODO comments |

## Keymaps

| Key | Action |
|-----|--------|
| `Space ft` | Colorscheme picker |
| `Space fj` | TODO comments picker |

NvChad default Telescope bindings (`Space ff`, etc.) are overridden by Snacks in `lua/mappings.lua`.

## Usage

Prefer Snacks (`Space ff`, `Space fg`) for daily search. Use `Space ft` to preview and apply base46 themes via Telescope when needed. `Space fj` or `Space sT` (Snacks) for TODO hunting.

## Troubleshooting

- **fzf-native build failed:** Requires `make` and a C compiler. Telescope works without it but slower.
- **Wrong theme list:** Telescope colorscheme shows installed colorschemes; base46 themes use `Space cs` / NvChad API instead.
- **Picker looks unstyled:** Ensure NvChad loaded and `nvchad.configs.telescope` is available.
