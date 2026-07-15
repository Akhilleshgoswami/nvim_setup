# Umbra — Keymap Reference

**Leader:** `Space`   ·   **Local leader:** `\`

A handcrafted, keyboard-first Neovim environment. `which-key` shows every
group live — press `Space` and wait, or `Space ?` for buffer-local maps.

---

## Essentials

| Key | Action |
|---|---|
| `jk` (insert) | Exit insert mode |
| `Esc` | Clear search highlight |
| `Ctrl-s` | Save file (any mode) |
| `Space w` / `Space W` | Save file / save all |
| `Space c` | Close window |
| `Space Q` | Quit all |
| `Space ur` | Reload Umbra config |
| `Space L` | Plugin manager (Lazy) |

## Motion & Editing

| Key | Action |
|---|---|
| `j` / `k` | Move by display line when wrapped |
| `n` / `N` | Next/prev search, centered |
| `J` | Join line, cursor stable |
| `<` / `>` (visual) | Indent, keep selection |
| `J` / `K` (visual) | Move selection down/up |
| `Space y` / `Space Y` | Yank to system clipboard |
| `Space d` | Delete without yanking |
| `Space p` (visual) | Paste, keep register |
| `s` / `S` | Flash jump / Flash Treesitter |
| `w` `e` `b` `ge` | Subword-aware motions (spider) |
| `af`/`if` `ac`/`ic` `aa`/`ia` | Treesitter text objects (func/class/param) |
| `]f`/`[f` `]c`/`[c` `]a`/`[a` | Next/prev function / class / parameter |
| `Ctrl-Space` / `Bs` | Grow / shrink Treesitter selection |

## Windows, Splits & Buffers

| Key | Action |
|---|---|
| `Ctrl-h/j/k/l` | Move between windows (tmux-aware) |
| `Space sv` / `Space ss` | Split vertical / horizontal |
| `Space se` / `Space sx` | Equalize / close split |
| `Space m` | Maximize split (toggle) |
| `Ctrl-Arrows` | Resize split |
| `Tab` / `Shift-Tab` | Next / previous buffer |
| `Space bd` / `Space bo` | Delete buffer / delete others |
| `Space bp` | Pin buffer |
| `Space b1/b2/b3` | Jump to buffer by position |
| `]q`/`[q`  `]l`/`[l` | Quickfix / location list nav |

## Find — `Space f` (Telescope)

| Key | Action |
|---|---|
| `Space Space` / `Space ff` | Find files |
| `Space fF` | Find all files (hidden + ignored) |
| `Space fg` / `Space fw` | Live grep / grep word |
| `Space fb` / `Space fr` | Buffers / recent files |
| `Space fs` / `Space fS` | Document / workspace symbols |
| `Space fd` / `Space ft` | Diagnostics / todo comments |
| `Space fh` `fk` `fc` | Help / keymaps / commands |
| `Space f/` / `Space fR` | Search in buffer / resume picker |
| `Space fp` | Projects |

## Explorer — one sidebar, three sources

All sources dock in the **same left window** — switching never opens extra
splits or duplicate buffers.

| Key | Action |
|---|---|
| `Space e` / `Space E` | Files sidebar (toggle) / float |
| `Space be` / `Space ge` | Buffers source / Git status source (same window) |
| `Tab` / `Shift-Tab` (in tree) | Cycle Files → Buffers → Git in place |
| `-` / `Space -` | Oil (edit filesystem as buffer) |

**Inside the Git status source** (`Space ge`): `ga` stage file · `gu` unstage ·
`gr` revert · `A` stage all · `gc` commit · `gp` push · `gg` commit + push ·
`Enter`/`l` open the file. Filesystem source: `H` toggles hidden files.

## Harpoon — `Space h`

| Key | Action |
|---|---|
| `Space ha` | Add file |
| `Ctrl-e` | Toggle quick menu |
| `Space hn` / `Space hp` | Next / previous mark |
| `Space 1`–`Space 4` | Jump to file 1–4 |

## LSP & Code — `Space c`, `Space r`

| Key | Action |
|---|---|
| `gd` `gr` `gI` `gy` `gD` | Definition / references / impl / type / declaration |
| `K` / `Ctrl-k` | Hover / signature help |
| `Space ca` | Code action |
| `Space rn` | Rename (live preview) |
| `Space cf` / `Space uf` | Format / toggle format-on-save |
| `Space cd` | Line diagnostics |
| `]d` / `[d` | Next / prev diagnostic |
| `Space ch` | Toggle inlay hints |
| `Space cl` / `Space cr` | Run code lens / restart LSP |
| `Space cs` / `Space cS` | Swap parameter next / prev |

## Diagnostics — `Space x` (Trouble)

| Key | Action |
|---|---|
| `Space xx` / `Space xX` | Diagnostics workspace / buffer |
| `Space xs` / `Space xr` | Symbols / LSP references |
| `Space xl` / `Space xq` | Location / quickfix list |
| `Space xt` | Todo comments |
| `Space o` | Symbol outline (aerial) |

## Git — `Space g`

VS Code-style Source Control: real-time gutter (green add / blue modify /
red delete), `M A D R U !` badges in the explorer, and a native panel.

| Key | Action |
|---|---|
| `Space gg` | Git panel — Neogit (branch, ahead/behind, staged/untracked, conflicts) |
| `Space gG` / `Space gF` | LazyGit / LazyGit current-file history |
| `Space ge` | Git status in sidebar (stage/unstage/commit — see Explorer) |
| `Space gd` / `Space gq` | Diff view (toggle) / toggle diff file panel |
| `Space gh` / `Space gH` | File history / branch history |
| `Space gl` / `Space gf` / `Space go` | Commit log / changed files / branches |
| `]h` / `[h` | Next / prev hunk |
| `Space gp` | Preview hunk (floating window) |
| `Space gs` / `Space gr` | Stage / reset hunk (normal + visual) |
| `Space gS` / `Space gR` | Stage / reset file |
| `Space gu` / `Space gU` | Undo staged hunk / undo all staged in file |
| `Space gb` / `Space gB` | Toggle inline blame / blame popup (author, hash, date) |
| `Space gw` | Toggle word diff |
| `Space gC` / `Space gP` | Commit / pull (Neogit) |
| `ih` (visual/operator) | Select hunk |

## Terminal — `Space t`

WezTerm is the primary terminal (see below); the internal toggleterm remains
for quick throwaway shells.

| Key | Action |
|---|---|
| `Space tw` | WezTerm: new window (project root) |
| `Space tp` / `Space td` | WezTerm: new tab in project root / file's dir |
| `Space t\` / `Space t-` | WezTerm: split right / down (file's dir) |
| `Ctrl-\` / `Space tt` | Toggle internal terminal |
| `Space tf` `th` `tv` | Float / horizontal / vertical (internal) |
| `Space t2` / `Space t3` | Extra internal terminals |
| `Esc Esc` (term) | To normal mode |
| `Ctrl-h/j/k/l` (term) | Move between windows |

WezTerm launches reuse a running instance (new tab/pane, no second process)
when Neovim is started from WezTerm; otherwise a fresh GUI window opens. The
working directory is inherited automatically. The WezTerm colorscheme mirrors
your Neovim theme live — change it with `:Theme` and the terminal follows.

### WezTerm keys (config at `~/.config/wezterm`)

Leader is `Ctrl-a` (tmux-style); `⌘` bindings mirror macOS/IDE habits.

| Key | Action |
|---|---|
| `⌘ d` / `⌘ ⇧ d` | Split right / down |
| `Leader \` / `Leader -` | Split right / down |
| `Leader h/j/k/l` | Move between panes |
| `Leader z` / `⌘ ⏎` | Zoom pane (toggle) |
| `⌘ t` / `Leader t` | New tab |
| `⌘ 1‑9` / `Leader 1‑9` | Jump to tab |
| `⌘ ⇧ [ / ]` | Previous / next tab |
| `Leader [` / `⌘ f` | Copy mode / search |
| `⌘ ⇧ p` / `Leader P` | Command palette |
| `⌘ ⇧ ⏎` | Toggle fullscreen |
| `Leader Ctrl-a` | Send a literal Ctrl-a (Neovim increment) |

## AI — `Space a`

| Key | Action |
|---|---|
| `Space aa` / `Space ac` | AI actions / chat toggle (CodeCompanion) |
| `Space ai` / `Space ad` | Inline prompt / add selection to chat |
| `Space av` / `Space aA` / `Space ae` | Avante toggle / ask / edit selection |
| `Space aC` / `Space as` / `Space af` | Claude Code toggle / send / focus |

> Copilot suggestions appear inline as ghost text and in the completion menu.

## Folds

| Key | Action |
|---|---|
| `zR` / `zM` | Open / close all folds |
| `zK` | Peek folded lines |
| `za` `zo` `zc` | Toggle / open / close fold |

## Tools & UI — `Space u`, `Space q`, `Space n`, `Space R`

| Key | Action |
|---|---|
| `Space ut` / `:Theme` | Theme picker (live preview, remembered on restart) |
| `Space uu` / `Space uz` | Undo tree / Zen mode |
| `Space uD` / `Space uC` | Database UI / toggle cursor smear |
| `Space un` / `Space nd` | Dismiss notifications |
| `Space na` / `Space nl` | Notification history / last message |
| `Space ql` `qs` `qd` | Session restore / save / delete |
| `Space mp` | Markdown preview (browser) |
| `Space Rs` `Ra` `Rt` `Rc` | REST send / send all / toggle view / copy curl |
| `Space ;` | Breadcrumb picker (dropbar) |

## Themes

Umbra is the handcrafted default. Run `:Theme` (or `Space ut`) for a live
preview picker of every installed colorscheme; your choice is remembered across
restarts. Bundled alternates: Catppuccin, Tokyo Night, Kanagawa, Rosé Pine,
Gruvbox, Everforest, OneDark (onedarkpro), Nightfox, Oxocarbon, Nord.

Add or remove a theme by editing `lua/plugins/themes.lua` (the statusline
adapts automatically). Variants like `catppuccin-mocha` or `tokyonight-moon`
are selectable directly from the picker.

## Completion (blink.cmp — insert mode)

| Key | Action |
|---|---|
| `Tab` | Accept / jump snippet forward |
| `Shift-Tab` | Prev item / jump snippet back |
| `Enter` | Accept |
| `Ctrl-Space` | Toggle documentation |
| `Ctrl-n` / `Ctrl-p` | Next / previous item |
| `Ctrl-f` / `Ctrl-b` | Scroll docs |
| `Ctrl-e` | Cancel |

## Misc

| Key | Action |
|---|---|
| `Ctrl-f` | tmux-sessionizer |
| `Space X` | `chmod +x` current file |
| `Space ?` | Buffer-local keymaps (which-key) |
