# Umbra — Intelligent Neovim IDE

A high-performance, keyboard-first Neovim configuration built for modern development. Features real-time GitHub Copilot inline suggestions, blazing-fast autocompletion via `blink.cmp`, LSP intelligence, full Treesitter integration, bespoke colorschemes, and native terminal theme synchronization.

---

## Prerequisites (Any OS)

Before installing, ensure the following core tools are installed:

| Tool | Minimum Version | Installation Command |
| :--- | :--- | :--- |
| **Neovim** | `>= 0.10.0` | `brew install neovim` (macOS) / `sudo apt install neovim` or PPA (Ubuntu) / `sudo pacman -S neovim` (Arch) |
| **Git** | `>= 2.25` | Standard package manager |
| **Node.js** | `>= 18.0.0` | `nvm install 20` or `brew install node` / `sudo apt install nodejs npm` |
| **ripgrep** | `>= 13.0` | `brew install ripgrep` / `sudo apt install ripgrep` / `sudo pacman -S ripgrep` |
| **Build Tools** | `make`, `gcc` / `clang` | `xcode-select --install` (macOS) / `build-essential` (Linux) |
| **Nerd Font** | v3.0+ | [JetBrains Mono Nerd Font](https://www.nerdfonts.com/font-downloads) (recommended) |

> [!NOTE]
> **Node.js is required** for the GitHub Copilot Language Server and LSP servers (e.g., `vtsls`, `tailwindcss`).

---

## Installation / Cloning on a New Machine

### macOS & Linux

```bash
# 1. Back up any existing Neovim config (optional)
mv ~/.config/nvim ~/.config/nvim.backup 2>/dev/null
mv ~/.local/share/nvim ~/.local/share/nvim.backup 2>/dev/null

# 2. Clone the repository
git clone -b navchand git@github.com:Akhilleshgoswami/nvim_setup.git ~/.config/nvim
# Or using HTTPS:
# git clone -b navchand https://github.com/Akhilleshgoswami/nvim_setup.git ~/.config/nvim

# 3. Launch Neovim
nvim
```

### Windows (PowerShell)

```powershell
# 1. Clone repository to Neovim config directory
git clone -b navchand https://github.com/Akhilleshgoswami/nvim_setup.git $env:LOCALAPPDATA\nvim

# 2. Launch Neovim
nvim
```

Upon first launch, `lazy.nvim` will automatically download and install all plugins, Treesitter parsers, and LSP packages.

---

## How to Make GitHub Copilot Auto-Suggestions Work

Follow these simple steps on any OS to activate GitHub Copilot:

### Step 1: Ensure Node.js is on your PATH
Verify that `node` is available:
```bash
node -v
# Output should be v18+ or v20+
```

### Step 2: Open Neovim & Authenticate
Open Neovim and run the sign-in command:
```vim
:Copilot auth
```
*(or press `<Space>aa` in Normal mode)*

1. Neovim will display a popup with a **one-time 8-character device code** (e.g., `ABCD-1234`) and copy it to your system clipboard automatically.
2. Open your browser and navigate to: **[https://github.com/login/device](https://github.com/login/device)**
3. Paste the code, click **Continue**, and grant permission to GitHub Copilot.
4. Return to Neovim. The popup will automatically close and notify you:
   `[Copilot] Authenticated as GitHub user: <your-username>`

### Step 3: Verify Status
Run:
```vim
:Copilot status
```
*(or press `<Space>as` in Normal mode)*
It should display: `Copilot: Enabled and ready`.

### Step 4: Start Typing
Whenever you enter **Insert Mode** (`i`, `a`, `o`), Copilot will automatically analyze your context and display multi-line predictions in **faint ghost text** ahead of your cursor.

---

## Copilot & Completion Keybindings

The configuration uses a unified `<Tab>` workflow where Copilot and `blink.cmp` work seamlessly together without colliding:

| Keybinding | Mode | Action |
| :--- | :--- | :--- |
| **`<Tab>`** | Insert | **Accept Copilot suggestion** (when ghost text visible) / accept completion menu item / jump to next snippet placeholder / indent |
| **`<M-l>`** or **`<C-l>`** | Insert | **Accept full Copilot suggestion** |
| **`<M-w>`** | Insert | Accept next **word** of Copilot suggestion |
| **`<M-j>`** | Insert | Accept next **line** of Copilot suggestion |
| **`<M-]>`** / **`<M-[>`** | Insert | Cycle next / previous suggestion alternative |
| **`<C-]>`** | Insert | **Dismiss** Copilot suggestion |
| **`<Space>ap`** | Normal | **Toggle Copilot auto-suggestions ON / OFF** |
| **`<Space>as`** | Normal | Show Copilot connection status |
| **`<Space>aa`** | Normal | Initiate GitHub Copilot authentication (`:Copilot auth`) |

> [!TIP]
> **No Collision Guarantee**: `hide_during_completion = true` ensures that whenever the `blink.cmp` popup menu opens, Copilot's ghost text temporarily hides so that popup items remain completely legible.

---

## Core Keymap Reference

Leader key is **`Space`**.

### Navigation & Fuzzy Search
- `<Space><Space>` or `<Space>ff` — Find files (Telescope)
- `<Space>fg` — Live grep (search across files)
- `<Space>fb` — Open buffers
- `<Space>fr` — Recent files
- `<Space>e` — Toggle File Explorer sidebar (`neo-tree`)
- `-` — Open floating file editor (`oil.nvim`)

### Themes & Real-Time WezTerm Sync
- `:Theme` or `<Space>ut` — Open theme selector with instant live preview.
- Choosing a theme automatically synchronizes WezTerm's background and palette via terminal OSC sequences and configuration watchers.
- First-party themes: `kiln` (warm clay default), `umbra`, `solder`, `loam`, `meridian`.
- Bundled external themes: `catppuccin`, `tokyonight`, `gruvbox`, `kanagawa`, `rose-pine`, `nord`, `everforest`, `onedarkpro`, `oxocarbon`.

### Code Folding (`nvim-ufo`)
- `za` — Toggle fold under cursor
- `zR` — Open all folds
- `zM` — Close all folds
- `zK` — Peek fold (preview folded code without opening)

---

## Troubleshooting

- **Copilot says "You are not signed into GitHub"**:
  Run `:Copilot auth` (or `<Space>aa`) and approve the device code at `https://github.com/login/device`.
- **Copilot suggestions not triggering**:
  Press `<Space>ap` to ensure auto-trigger is set to `ON`. Ensure your file type is supported (markdown, lua, js, ts, python, go, rust, etc.).
- **Missing LSP or Formatters**:
  Run `:Mason` to install or update language servers, linters, and formatters for your chosen language.
