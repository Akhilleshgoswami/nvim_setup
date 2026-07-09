# Keymaps README

Leader key: `Space`

This file documents the active keymaps in your current NvChad-based setup.

## Core Editing

| Key | Action |
|---|---|
| `jk` (insert) | Exit insert mode |
| `Space w` | Save file |
| `Space c` | Close window |
| `Space nh` | Clear search highlights |
| `J` | Join line (cursor stable) |
| `Shift-J` / `Shift-K` (visual) | Move selected lines down/up |
| `Ctrl-d` / `Ctrl-u` | Scroll down/up and center |
| `n` / `N` | Next/prev search and center |
| `Q` | Disabled |

## Clipboard / Text

| Key | Action |
|---|---|
| `Space y` / `Space Y` | Yank to system clipboard |
| `Space d` | Delete without yanking |
| `Space p` (visual) | Paste without replacing register |

## Navigation Lists

| Key | Action |
|---|---|
| `Ctrl-j` / `Ctrl-k` | Quickfix prev/next |
| `Space j` / `Space k` | Loclist prev/next |

## Buffers / Tabs

| Key | Action |
|---|---|
| `Tab` | Previous buffer |
| `Shift-Tab` | Next buffer |
| `Shift-C` | Close buffer |
| `Space bd` | Delete buffer (Snacks bufdelete) |

## Files & Explorer

| Key | Action |
|---|---|
| `Space ff` | Find files (NvChad Telescope) |
| `Space fb` | Buffers (NvChad Telescope) |
| `Space fo` | Old files (NvChad Telescope) |
| `Space fw` | Live grep (NvChad Telescope) |
| `Space e` | Snacks explorer sidebar |
| `-` | Oil float explorer |
| `Space oe` | Oil float explorer |
| `Space pv` | Netrw `:Ex` |

## Snacks Picker (Search)

| Key | Action |
|---|---|
| `Space fg` | Live grep |
| `Space fr` | Recent files |
| `Space fp` | Projects |
| `Space sg` | Search in project |
| `Space sw` | Search word under cursor |
| `Space sf` | Search files |
| `Space sb` | Search lines in buffer |
| `Space sr` | Resume search |
| `Space sh` | Help tags |
| `Space sk` | Keymaps |
| `Space sc` | Commands |
| `Space sm` | Marks |
| `Space sR` | Registers |
| `Space sd` / `Space sD` | Diagnostics (workspace/buffer) |
| `Space ss` / `Space sS` | LSP symbols (doc/workspace) |
| `Space sT` | TODO comments |
| `Space sn` | Notifications |
| `Space sj` | Jumplist |
| `Space sJ` | Project-wide jump grep |
| `<leader>/` | Search in open buffers |

## Git

| Key | Action |
|---|---|
| `Space gd` | Diffview open |
| `Space gc` | Diffview close |
| `Space q` | Diffview toggle files panel |
| `Space gg` | Lazygit |
| `Space gb` | Blame line |
| `Space go` | Git browse |
| `Space gl` | Git log picker |
| `Space gs` | Git status picker |

### Gitsigns (buffer local)

| Key | Action |
|---|---|
| `]h` / `[h` | Next/prev hunk |
| `Space hs` / `Space hS` | Stage hunk / stage buffer |
| `Space hu` | Undo stage hunk |
| `Space hr` / `Space hR` | Reset hunk / reset buffer |
| `Space hp` / `Space hi` | Preview hunk / inline preview |
| `Space hd` / `Space hD` | Diff this / diff against `~` |
| `Space hb` / `Space hB` | Blame popup / toggle line blame |
| `Space hx` / `Space hw` / `Space hl` | Toggle deleted / word diff / linehl |

## LSP (buffer local)

| Key | Action |
|---|---|
| `gd` | Go to definition |
| `gr` | References |
| `gI` | Implementation |
| `gy` | Type definition |
| `K` | Hover docs |
| `Space rn` | Rename symbol |
| `Space ca` | Code action |
| `Space de` | Diagnostic float |
| `[d` / `]d` | Prev/next diagnostic |
| `Space q` | Diagnostics to loclist |
| `Space zig` | Restart LSP |
| `Space f` | Format via LSP |

## Completion (blink.cmp)

| Key | Action |
|---|---|
| `Tab` / `Shift-Tab` | Next/prev completion or snippet jump |
| `Ctrl-Space` | Show completion/docs |
| `Ctrl-e` | Hide completion |
| `Ctrl-j` / `Ctrl-k` | Scroll completion docs |
| `Enter` | Accept completion |

## Motion & Editing Plugins

### Flash
- `s`, `S`, `r`, `R`, `Ctrl-s` (cmdline)

### Spider
- `w`, `e`, `b`, `ge` (smart word motions)

### Substitute
- `Space sr`, `Space sl`, `Space sS`
- Rip substitute: `Space srf`

### Comment / Surround
- Comment: `gcc`, `gc`, `gbc`, `gb`
- Surround: `ys`, `ds`, `cs`

## Harpoon

| Key | Action |
|---|---|
| `Space a` | Add file |
| `Ctrl-m` | Toggle menu |
| `Ctrl-h` | File 1 |
| `Ctrl-n` | File 3 |
| `Ctrl-s` | File 4 |

## Terminal

| Key | Action |
|---|---|
| `Space t` | `:Sterm` |
| `Space tf` | Floating terminal |
| `Space th` | Horizontal terminal |
| `Space tv` | Vertical terminal |
| `Space tt` | Snacks terminal |
| `Space td` | Lazydocker |

Terminal mode:
- `Esc` to normal mode
- `Ctrl-h/j/k/l` window navigation

## Sessions / Notes / UI

| Key | Action |
|---|---|
| `Space wr` / `Space ws` | Restore/save session |
| `Space nt` / `Space nv` | Todo note float/vsplit |
| `Space z` | Zen mode |
| `Space un` | Dismiss notifications |
| `Space uw/us/uL/uD/uZ/uS/uI/uW` | UI toggles |
| `Space ;`, `[;`, `];` | Dropbar navigation |
| `zR`, `zM`, `zr`, `zp` | UFO folds |
| `Space m` | Maximize split |

## Theme

| Key | Action |
|---|---|
| `Space cs` | Theme picker |
| `Space ct` | Next theme |
| `Space ca` | Auto day/night theme |

## Misc

| Key | Action |
|---|---|
| `Space x` | `chmod +x` current file |
| `Space vpp` | Open old packer config path |
| `Space mr` | CellularAutomaton rain (requires plugin) |
| `Ctrl-f` | tmux-sessionizer |
| `Space Space` | Source current file |

---

## Known Conflicts

- `Space q`: Diffview toggle files and LSP loclist (buffer-local may win when attached)
- `Space sr` / `Space sS`: Snacks search vs Substitute
- `Space ca`: Theme auto (global) vs LSP code action (buffer-local)

Use `Space sk` (Snacks keymap picker) to inspect live mappings.
