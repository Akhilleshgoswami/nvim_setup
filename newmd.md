# Umbra — Keymap Reference

**Leader:** `Space`   ·   **Local leader:** `\`

## Essentials


| Key                   | Action                 |
| --------------------- | ---------------------- |
| `jk` (insert)         | Exit insert mode       |
| `Esc`                 | Clear search highlight |
| `Ctrl-s`              | Save file (any mode)   |
| `Space w` / `Space W` | Save file / save all   |
| `Space c`             | Close window           |
| `Space Q`             | Quit all               |
| `Space ur`            | Reload Umbra config    |
| `Space L`             | Plugin manager (Lazy)  |


## Motion & Editing


| Key                           | Action                                     |
| ----------------------------- | ------------------------------------------ |
| `j` / `k`                     | Move by display line when wrapped          |
| `n` / `N`                     | Next/prev search, centered                 |
| `J`                           | Join line, cursor stable                   |
| `<` / `>` (visual)            | Indent, keep selection                     |
| `J` / `K` (visual)            | Move selection down/up                     |
| `Space y` / `Space Y`         | Yank to system clipboard                   |
| `Space d`                     | Delete without yanking                     |
| `Space p` (visual)            | Paste, keep register                       |
| `s` / `S`                     | Flash jump / Flash Treesitter              |
| `w` `e` `b` `ge`              | Subword-aware motions (spider)             |
| `af`/`if` `ac`/`ic` `aa`/`ia` | Treesitter text objects (func/class/param) |
| `]f`/`[f` `]c`/`[c` `]a`/`[a` | Next/prev function / class / parameter     |
| `Ctrl-Space` / `Bs`           | Grow / shrink Treesitter selection         |


## Windows, Splits & Buffers


| Key                     | Action                                    |
| ----------------------- | ----------------------------------------- |
| `Ctrl-h/j/k/l`          | Move between windows (tmux-aware)         |
| `Space sv` / `Space ss` | Split vertical / horizontal               |
| `Space se` / `Space sx` | Equalize / close split                    |
| `Space sm`              | Maximize split (toggle)                   |
| `Ctrl-Arrows`           | Resize split                              |
| `Tab` / `Shift-Tab`     | Next / previous Harpoon pin (working set) |
| `Space bd` / `Space bo` | Delete buffer / delete others             |
| `Space bn`              | New buffer                                |
| `]q`/`[q` `]l`/`[l`     | Quickfix / location list nav              |


## Find — `Space f` (Telescope)


| Key                        | Action                            |
| -------------------------- | --------------------------------- |
| `Space Space` / `Space ff` | Find files                        |
| `Space fF`                 | Find all files (hidden + ignored) |
| `Space fg` / `Space fw`    | Live grep / grep word             |
| `Space fb` / `Space fr`    | Buffers / recent files            |
| `Space fs` / `Space fS`    | Document / workspace symbols      |
| `Space fd` / `Space ft`    | Diagnostics / todo comments       |
| `Space fh` `fk` `fc`       | Help / keymaps / commands         |
| `Space f/` / `Space fR`    | Search in buffer / resume picker  |
| `Space fp`                 | Projects                          |


## Explorer — one sidebar, three sources


| Key                           | Action                                           |
| ----------------------------- | ------------------------------------------------ |
| `Space e` / `Space E`         | Files sidebar (toggle) / float                   |
| `Space be` / `Space ge`       | Buffers source / Git status source (same window) |
| `Tab` / `Shift-Tab` (in tree) | Cycle Files → Buffers → Git in place             |
| `-` / `Space -`               | Oil (edit filesystem as buffer)                  |


## Harpoon — the working set (`Space h`)


| Key                     | Action                      |
| ----------------------- | --------------------------- |
| `Space ha`              | Add file to the working set |
| `Ctrl-e`                | Toggle quick menu           |
| `Tab` / `Shift-Tab`     | Next / previous pin         |
| `Space hn` / `Space hp` | Next / previous pin         |
| `Space 1`–`Space 4`     | Jump to pin 1–4             |


## LSP & Code — `Space c`, `Space r`


| Key                      | Action                                              |
| ------------------------ | --------------------------------------------------- |
| `gd` `gr` `gI` `gy` `gD` | Definition / references / impl / type / declaration |
| `K` / `Ctrl-k`           | Hover / signature help                              |
| `Space ca`               | Code action                                         |
| `Space rn`               | Rename (live preview)                               |
| `Space cf` / `Space uf`  | Format / toggle format-on-save                      |
| `Space cd`               | Line diagnostics                                    |
| `]d` / `[d`              | Next / prev diagnostic                              |
| `Space ch`               | Toggle inlay hints                                  |
| `Space cl` / `Space cr`  | Run code lens / restart LSP                         |
| `Space cs` / `Space cS`  | Swap parameter next / prev                          |


## Diagnostics — `Space x` (Trouble)


| Key                     | Action                         |
| ----------------------- | ------------------------------ |
| `Space xx` / `Space xX` | Diagnostics workspace / buffer |
| `Space xs` / `Space xr` | Symbols / LSP references       |
| `Space xl` / `Space xq` | Location / quickfix list       |
| `Space xt`              | Todo comments                  |
| `Space o`               | Symbol outline (aerial)        |


## Git — `Space g`


| Key                                  | Action                                      |
| ------------------------------------ | ------------------------------------------- |
| `Space gg`                           | Git panel — Neogit                          |
| `Space gG` / `Space gF`              | LazyGit / LazyGit current-file history      |
| `Space ge`                           | Git status in sidebar                       |
| `Space gd` / `Space gq`              | Diff view (toggle) / toggle diff file panel |
| `Space gh` / `Space gH`              | File history / branch history               |
| `Space gl` / `Space gf` / `Space go` | Commit log / changed files / branches       |
| `]h` / `[h`                          | Next / prev hunk                            |
| `Space gp`                           | Preview hunk (floating window)              |
| `Space gs` / `Space gr`              | Stage / reset hunk (normal + visual)        |
| `Space gS` / `Space gR`              | Stage / reset file                          |
| `Space gu` / `Space gU`              | Undo staged hunk / undo all staged in file  |
| `Space gb` / `Space gB`              | Toggle inline blame / blame popup           |
| `Space gw`                           | Toggle word diff                            |
| `Space gC` / `Space gP`              | Commit / pull (Neogit)                      |
| `ih` (visual/operator)               | Select hunk                                 |


## Terminal — `Space t`


| Key                     | Action                                        |
| ----------------------- | --------------------------------------------- |
| `Space tw`              | WezTerm: new window (project root)            |
| `Space tp` / `Space td` | WezTerm: new tab in project root / file's dir |
| `Space t\` / `Space t-` | WezTerm: split right / down (file's dir)      |
| `Ctrl-\` / `Space tt`   |                                               |
| `Space tf` `th` `tv`    | Float / horizontal / vertical (internal)      |
| `Space t2` / `Space t3` | Extra internal terminals                      |
| `Space tr` / `Space tR` | Run project / run tests (auto-detected)       |
| `Space tn` / `Space tD` | Pick npm script / Docker menu                 |
| `Esc Esc` (term)        | To normal mode                                |
| `Ctrl-h/j/k/l` (term)   | Move between windows                          |


## Debug — `Space d` / function keys (nvim-dap)


| Key                                  | Action                             |
| ------------------------------------ | ---------------------------------- |
| `F5` / `Space dc`                    | Start / continue                   |
| `F10` `F11` `⇧F11`                   | Step over / into / out             |
| `F9` / `Space db`                    | Toggle breakpoint                  |
| `Space dB` / `Space dl`              | Conditional breakpoint / log point |
| `Space du` / `Space dr`              | Toggle UI / REPL                   |
| `Space de` / `Space dw`              | Eval expression / watch            |
| `Space dt` / `Space dR` / `Space dp` | Terminate / restart / pause        |
| `Space dC` / `Space dX`              | Run to cursor / clear breakpoints  |


## Markdown — `Space m`


| Key        | Action                                   |
| ---------- | ---------------------------------------- |
| `Space mp` | Toggle browser preview (Mermaid + KaTeX) |
| `Space mi` | Paste image from clipboard               |


## Health & performance


| Key                         | Action                                         |
| --------------------------- | ---------------------------------------------- |
| `Space uh` / `:UmbraHealth` | Snapshot: startup, slow plugins, LSP, etc.     |
| `Space up`                  | Full per-plugin load profile (`:Lazy profile`) |


## Folds


| Key            | Action                     |
| -------------- | -------------------------- |
| `zR` / `zM`    | Open / close all folds     |
| `zK`           | Peek folded lines          |
| `za` `zo` `zc` | Toggle / open / close fold |


## Tools & UI — `Space u`, `Space q`, `Space n`, `Space R`


| Key                       | Action                                         |
| ------------------------- | ---------------------------------------------- |
| `Space ut` / `:Theme`     | Theme picker (live preview)                    |
| `Space uu` / `Space uz`   | Undo tree / Zen mode                           |
| `Space uD` / `Space uM`   | Database UI / reduce motion (toggle)           |
| `Space un` / `Space nd`   | Dismiss notifications                          |
| `Space na` / `Space nl`   | Notification history / last message            |
| `Space ql` `qs` `qd`      | Session restore / save / delete                |
| `Space Rs` `Ra` `Rt` `Rc` | REST send / send all / toggle view / copy curl |
| `Space ;`                 | Breadcrumb picker (dropbar)                    |


## Completion (blink.cmp — insert mode)


| Key                 | Action                        |
| ------------------- | ----------------------------- |
| `Tab`               | Accept / jump snippet forward |
| `Shift-Tab`         | Prev item / jump snippet back |
| `Enter`             | Accept                        |
| `Ctrl-Space`        | Toggle documentation          |
| `Ctrl-n` / `Ctrl-p` | Next / previous item          |
| `Ctrl-f` / `Ctrl-b` | Scroll docs                   |
| `Ctrl-e`            | Cancel                        |


## Misc


| Key        | Action                           |
| ---------- | -------------------------------- |
| `Space P`  | Command palette (commands)       |
| `Space pp` | Switch project                   |
| `Space X`  | `chmod +x` current file          |
| `Space ur` | Reload config                    |
| `Space ?`  | Buffer-local keymaps (which-key) |


