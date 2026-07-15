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

A VS Code-style Source Control experience. The gutter shows changes in real
time (green = added, blue = modified, red = deleted), the file explorer shows
`M / A / D / R / U / !` badges, and `Space gg` opens a native panel.

### Panels & views

| Key | Action |
|---|---|
| `Space gg` | Git panel — Neogit source control (branch, ahead/behind, staged/untracked, conflicts) |
| `Space gG` | LazyGit (full TUI) |
| `Space gF` | LazyGit — current file history |
| `Space ge` | Git status in the explorer sidebar (neo-tree) |
| `Space gd` | Diff view — side-by-side, syntax highlighted (toggle) |
| `Space gq` | Diff view — toggle the file panel |
| `Space gh` | File history (current file) |
| `Space gH` | Branch / project history |
| `Space gl` | Commit log (Telescope) |
| `Space gf` | Changed files (Telescope) |
| `Space go` | Branches — checkout (Telescope) |

### Hunks (gutter)

| Key | Action |
|---|---|
| `]h` / `[h` | Next / previous hunk (also `]c` / `[c` inside a diff) |
| `Space gp` | Preview hunk in a floating window |
| `Space gs` | Stage hunk (works on a selection in visual mode) |
| `Space gr` | Reset hunk (works on a selection in visual mode) |
| `Space gS` | Stage entire file |
| `Space gR` | Reset entire file |
| `Space gu` | Undo stage (last hunk) |
| `Space gU` | Undo all staged changes in the file |
| `ih` | Hunk text object (e.g. `vih`, `dih`) |

### Blame & commit

| Key | Action |
|---|---|
| `Space gb` | Toggle inline blame for the current line (unobtrusive, end-of-line) |
| `Space gB` | Blame line — full popup (author, message, hash, date) |
| `Space gw` | Toggle word diff |
| `Space gC` | Commit (Neogit) |
| `Space gP` | Pull (Neogit) |

Inside the **Neogit** panel: `s` stage · `u` unstage · `x` discard ·
`c c` commit · `P` push · `p` pull · `Tab` toggle a diff · `q` close.

Inside the **neo-tree Git** view (`Space ge`): `A` stage all · `ga` stage ·
`gu` unstage · `gr` revert · `gc` commit · `gp` push · `gg` commit + push.

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

**Note:** `Space ca` is code action only. Day/night theme auto is `Space cD`.

## Completion (blink.cmp)

| Key | Action |
|---|---|
| `Tab` | Accept selected completion (or jump snippet forward) |
| `Shift-Tab` | Prev item / jump snippet backward |
| `↑` / `↓` or `Ctrl-n` / `Ctrl-p` | Next / previous item |
| `Enter` | Accept completion |
| `Ctrl-Space` | Show completion / toggle docs |
| `Ctrl-e` | Cancel completion |
| `Ctrl-j` / `Ctrl-k` | Scroll completion docs |
| `Space ca` | Code action (also "Add missing import") |

## Motion & Editing Plugins

### Flash
- `s`, `S`, `r`, `R`, `Ctrl-s` (cmdline)

### Spider
- `w`, `e`, `b`, `ge` (smart word motions)

### Substitute
- `Space sr`, `Space sl`, `Space sS`
- Rip substitute: `Space srf`

### Comment / Surround
- Comment: `gcc`, `gc`, `gbc`, `gb` /
- Surround: `ys`, `ds`, `cs`

## Harpoon

| Key | Action |
|---|---|
| `Space a` | Add fijke |
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
| `Space fc` / `Space fe` | Fold / unfold at cursor |
| `Space fa` | Toggle fold at cursor |
| `Space fR` / `Space fM` | Open all / close all folds |
| `Space fk` | Peek folded lines |
| `zc` / `zo` / `za` | Fold / unfold / toggle (Vim keys) |
| `zR` / `zM` / `zr` / `zp` | UFO fold shortcuts |
| `Space un` | Dismiss notifications |
| `Space uw/us/uL/uD/uZ/uS/uI/uW` | UI toggles |
| `Space ;`, `[;`, `];` | Dropbar navigation |
| `Space m` | Maximize split |

## Theme

| Key | Action |
|---|---|
| `Space cs` | Theme picker |
| `Space ct` | Next theme |
| `Space cD` | Auto day/night theme |

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
- `Space cD`: Auto day/night theme (`Space ca` is code action only)

Use `Space sk` (Snacks keymap picker) to inspect live mappings.
