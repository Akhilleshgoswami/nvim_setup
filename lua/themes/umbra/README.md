# Umbra

A premium, handcrafted dark Neovim colorscheme inspired by Linear, Vercel, Raycast, and Stripe Dashboard. Graphite surfaces, soft contrast, desaturated accents — comfortable for long coding sessions and OLED-friendly.

## Features

- Modular architecture (palette, groups, treesitter, LSP, plugins, terminal)
- Full Treesitter support for Lua, TypeScript, JavaScript, JSX/TSX, HTML, CSS, JSON, YAML, Markdown, SQL, Bash, Rust, Go, Python, and more
- Complete LSP semantic highlights and diagnostics
- Git integration (GitSigns, Diffview, Fugitive, Neogit)
- 30+ plugin integrations (Telescope, Neo-tree, blink.cmp, Noice, Which-Key, Flash, Trouble, Mason, Lazy, Render Markdown, and others)
- 16-color terminal palette
- Configurable: transparency, dim inactive windows, italic comments, bold keywords, custom overrides

## Installation

Umbra ships with this Neovim config. For standalone use, copy `colors/umbra.lua` and `lua/themes/umbra/` into your config.

### Lazy.nvim (standalone)

```lua
{
  dir = vim.fn.stdpath("config"), -- or path to this repo
  lazy = false,
  priority = 1000,
  config = function()
    require("themes.umbra").setup({
      transparent = false,
      italic_comments = true,
    })
    vim.cmd.colorscheme("umbra")
  end,
}
```

## Configuration

```lua
require("themes.umbra").setup({
  transparent = false,       -- NONE editor background
  dim_inactive = false,      -- mute unfocused windows
  italic_comments = true,    -- italic @comment / Comment
  bold_keywords = false,     -- bold @keyword captures
  bright_cursorline = false, -- stronger CursorLine
  terminal = true,           -- apply ANSI palette
  plugins = true,            -- third-party plugin highlights
  overrides = {               -- custom highlight overrides
    CursorLine = { bg = "#1A1A24" },
  },
})
```

Or set before startup via global:

```lua
vim.g.umbra_config = { transparent = true }
```

## Color Palette

Soft blue-gray surfaces with clear elevation — optimized for 13–14" laptop screens.

| Element | Hex |
|---------|-----|
| Main Background | `#1A1E27` |
| Sidebar / Statusline | `#202532` |
| Floating Windows | `#252B3B` |
| Cursor Line | `#262D3F` |
| Selection | `#2F3850` |
| Borders | `#343D52` |
| Text | `#E5E9F0` |
| Comments | `#8B95A7` |
| Line Numbers | `#6D7890` |
| Active Line Number | `#8FB4FF` |

### Syntax

| Token | Hex |
|-------|-----|
| Keywords | `#C792EA` |
| Functions | `#82AAFF` |
| Strings | `#A3D977` |
| Numbers | `#F7C66F` |
| Types | `#7FD1C5` |
| Constants | `#F38BA8` |
| Operators | `#89B4FA` |

## Architecture

```
lua/themes/umbra/
├── init.lua         -- setup() + apply()
├── config.lua       -- configuration API
├── palette.lua      -- color tokens
├── util.lua         -- blend, resolve, merge
├── highlights.lua   -- orchestrator
├── groups.lua       -- editor chrome + syntax
├── treesitter.lua   -- @ captures
├── lsp.lua          -- diagnostics + LSP
├── plugins.lua      -- plugin integrations
└── terminal.lua     -- ANSI palette
```

## License

MIT — see [LICENSE](LICENSE).
