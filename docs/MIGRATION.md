# NvChad Migration Report

This document describes the migration from the custom `akhilesh` Lazy.nvim configuration to **NvChad v2.5** as the base, while preserving your existing workflow and keymaps.

## Summary

| Area | Before | After |
|------|--------|-------|
| Base framework | Custom `akhilesh.lazy` bootstrap | NvChad v2.5 starter (imported as plugin) |
| UI chrome | lualine + bufferline + tokyonight | NvChad statusline + tabufline + base46 themes |
| Dashboard | Snacks dashboard | NvChad nvdash |
| File explorer default | Oil (`-`) + Snacks sidebar (`<leader>e`) | Unchanged |
| Primary picker | Snacks picker | Unchanged |
| Completion | blink.cmp | Unchanged |
| LSP | mason + lspconfig (custom) | NvChad lspconfig defaults + your servers/keymaps |
| Formatting | conform.nvim | NvChad conform + your formatters |

**Config location:** `~/.config/nvim-12` (symlinked from this repo for testing). To use as your main config:

```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.backup

# Option A: symlink this repo
ln -sfn ~/Desktop/nvim-12 ~/.config/nvim

# Option B: use NVIM_APPNAME
export NVIM_APPNAME=nvim-12
```

---

## Plugin Mapping

### Replaced by NvChad equivalents

| Old Plugin | New Plugin | Notes |
|------------|------------|-------|
| `lualine.nvim` | NvChad statusline (`nvchad/ui`) | Removed; NvChad tabline/statusline via `chadrc.lua` |
| `bufferline.nvim` | NvChad tabufline | Tab/Shift-Tab/Shift-C bridged to tabufline API |
| `tokyonight.nvim` (+ alternates) | `base46` themes | `<leader>cs/ct/ca` adapted to NvChad theme API |
| Snacks dashboard | NvChad nvdash | Snacks dashboard disabled; `nvdash.load_on_startup = true` |
| `nvim-tree.lua` | Disabled | Oil + Snacks explorer used instead |
| `nvim-cmp` | `blink.cmp` | NvChad cmp disabled; blink retained |
| `indent-blankline.nvim` | `hlchunk.nvim` | NvChad ibl disabled |

### Kept (unique workflow)

| Plugin | Purpose |
|--------|---------|
| `folke/snacks.nvim` | Primary picker, terminal, notify, zen, git, bufdelete |
| `saghen/blink.cmp` | Completion (LSP, snippets, copilot, ripgrep) |
| `stevearc/oil.nvim` | Default file explorer (`-`) |
| `folke/edgy.nvim` | IDE layout (explorer left, terminals bottom) |
| `ThePrimeagen/harpoon` | Quick file marks |
| `folke/flash.nvim` | Jump/search (`s`, `S`, `r`, `R`) |
| `gbprod/substitute.nvim` | Text substitution |
| `chrisgrieser/nvim-rip-substitute` | Regex replace UI |
| `2kabhishek/termim.nvim` | `:Fterm`/`:Sterm`/`:Vterm` terminals |
| `rmagatti/auto-session` | Session save/restore |
| `cdreetz/groq-nvim` | Groq LLM integration |
| `nvim-flutter/flutter-tools.nvim` | Dart/Flutter LSP |
| `mmsaki/forgefmt.nvim` | Solidity formatting |
| `shellRaining/hlchunk.nvim` | Indent guides |
| `kevinhwang91/nvim-ufo` | LSP-aware folding |
| `folke/noice.nvim` + `dressing.nvim` | Cmdline, LSP progress, input UI |
| `Bekaboo/dropbar.nvim` | Winbar breadcrumbs |
| `sindrets/diffview.nvim` | Git diff UI |
| All other motion/editing plugins | Unchanged |

### Removed (dead / duplicate)

| Plugin | Reason |
|--------|--------|
| `bufferline.nvim` | Replaced by NvChad tabufline |
| `lualine.nvim` | Replaced by NvChad statusline |
| `colorscheme.lua` (tokyonight) | Replaced by base46 |
| `alpha.nvim`, `neotree`, `nvim-cmp`, `origami`, etc. | Already removed in prior refactor |

---

## Configuration Changes

### Directory structure

```
init.lua                 # NvChad bootstrap
lua/
  chadrc.lua             # NvChad UI/theme (nvdash, tabufline, statusline)
  options.lua            # Your editor options + nvchad.options
  mappings.lua           # ALL preserved keymaps + NvChad overrides
  autocmds.lua           # Cursor restore, Oil preview, UI setup
  configs/
    lazy.lua             # Lazy.nvim performance settings
    lspconfig.lua        # LSP servers + your on_attach keymaps
    conform.lua          # Formatters
  core/
    hjkl.lua             # Arrow-key discipline
    scratch.lua          # Todo notes float
    theme.lua            # Theme picker (NvChad themes API)
  akhilesh/ui/init.lua   # Design system overlay (blink, notify, which-key HL)
  plugins/               # Custom plugin specs + overrides.lua
snippets/                # LuaSnip snippets (unchanged)
```

### Disabled NvChad plugins (`lua/plugins/overrides.lua`)

- `nvim-tree/nvim-tree.lua`
- `hrsh7th/nvim-cmp`
- `lukas-reineke/indent-blankline.nvim`

### Keymap preservation

All original keymaps from `akhilesh.core.keymaps` are in `lua/mappings.lua`. NvChad defaults load first; your mappings override conflicts:

| Key | Your binding | NvChad default overridden |
|-----|--------------|---------------------------|
| `<leader>ff/fg/fb/fo` | Snacks picker | Telescope |
| `<leader>e` | Snacks explorer | NvimTree |
| `<leader>bd` | Snacks bufdelete | `:bd` / tabufline close |
| `<Tab>` / `<S-Tab>` / `<S-C>` | Buffer prev/next/close | `<S-h>` / `<S-l>` / `<leader>x` |
| `<leader>f` | LSP format | (NvChad uses `<leader>fm`) |
| `-` | Oil parent dir | — |

### Known pre-existing conflicts (unchanged)

| Key | Conflict | Resolution |
|-----|----------|------------|
| `<leader>q` | Diffview toggle · LSP loclist · Go snippet | Last global wins (Diffview); LSP overrides in buffer |
| `<leader>sr` / `<leader>sS` | Snacks resume/symbols · Substitute | Substitute loads later (same as before) |
| `<leader>ca` | Auto theme (global) · LSP code action (buffer) | Buffer-local LSP wins when attached |
| `<leader>gd` | Diffview (global) · LSP definition (buffer) | Buffer-local LSP wins when attached |

---

## Manual Steps

1. **Deploy config** — symlink or copy to `~/.config/nvim` (see above).
2. **First launch** — run `nvim`; Lazy.nvim will install all plugins (~1–2 min).
3. **Mason tools** — run `:Mason` and verify `stylua`, `prettier`, `prettierd`, LSP servers install.
4. **Treesitter** — run `:TSUpdate` if parsers are missing.
5. **Environment** — set `GROQ_API_KEY` for groq-nvim if used.
6. **Tmux sessionizer** — `<C-f>` calls `tmux-sessionizer` (external script; unchanged).
7. **Notes sync** — `<leader>nt` opens `~/Notes/todo.md` (create dir if needed).
8. **Clean old lockfile** — if migrating from old config: `:Lazy clean`.

---

## Limitations

1. **`<leader>mr` (CellularAutomaton)** — keymap preserved but plugin not installed; mapping will error until you add the plugin or remove the keymap.
2. **`<leader>vpp`** — still points to old dotfiles packer path; update if needed.
3. **Theme cycling** — uses NvChad base46 themes, not standalone colorscheme plugins.
4. **Snacks vs NvChad notifications** — Snacks overrides `vim.notify` at startup; NvChad uses its own notify for some UI. Both coexist.
5. **Noice LSP progress** — may overlap with fidget.nvim; both kept as in original config.

---

## Items Requiring Your Approval

| Item | Status | Action needed |
|------|--------|---------------|
| Replace `~/.config/nvim` with this config | Pending | Confirm deploy method |
| `<leader>mr` CellularAutomaton | Broken | Install plugin or remove keymap |
| `<leader>vpp` old path | Stale | Update path or remove |
| Substitute vs Snacks `<leader>sr/sS` conflict | Preserved as-is | Decide if you want to remap substitute |
| `node_modules/` in old config repo | Not migrated | Remove from dotfiles if unused |

---

## Validation Checklist

- [x] All Lua modules load (`options`, `mappings`, `configs.*`, `core.*`)
- [x] Lazy.nvim sync completes without errors
- [x] No startup Lua errors (headless test)
- [ ] Interactive test: LSP attach, completion, formatting
- [ ] Interactive test: Snacks picker (`<leader>ff`)
- [ ] Interactive test: Oil (`-`)
- [ ] Interactive test: NvChad dashboard on startup
- [ ] Interactive test: Tab buffer cycling

Run interactive validation after deploy:

```vim
:checkhealth lazy
:Mason
:Telescope find_files
:Oil
```

---

## Per-plugin documentation

See `docs/plugins/` for individual plugin docs (why, features, config, commands, keymaps, usage, troubleshooting).
