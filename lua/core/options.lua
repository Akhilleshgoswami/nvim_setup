-- Editor options. Sensible, opinionated, kept in one readable place.

local o = vim.opt
local g = vim.g

g.autoformat = true
g.markdown_recommended_style = 0

-- UI
o.number = true
o.relativenumber = true
o.cursorline = true
o.cursorlineopt = "number,line"
o.signcolumn = "yes:1"
o.colorcolumn = "+1"
o.termguicolors = true
o.showmode = false -- lualine owns the mode
o.laststatus = 3 -- single global statusline
o.cmdheight = 0 -- noice owns the cmdline; reclaim the row
o.pumheight = 12
o.pumblend = 0
o.winblend = 0
o.scrolloff = 8
o.sidescrolloff = 8
o.wrap = false
o.linebreak = true
o.breakindent = true
o.list = true
o.fillchars = {
  foldopen = "▾",
  foldclose = "▸",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
  msgsep = "─",
}
o.listchars = { tab = "→ ", trail = "·", nbsp = "␣", extends = "›", precedes = "‹" }
o.shortmess:append("WIsScC")

-- A beautiful, mode-aware cursor with a soft blink cadence.
o.guicursor = table.concat({
  "n-v-c:block-Cursor",
  "i-ci-ve:ver25-Cursor/lCursor-blinkwait200-blinkon500-blinkoff400",
  "r-cr-o:hor20-Cursor",
}, ",")

-- Editing
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.softtabstop = 2
o.shiftround = true
o.smartindent = true
o.autoindent = true
o.smoothscroll = true
o.virtualedit = "block"
o.formatoptions = "jcroqlnt"

-- Search
o.ignorecase = true
o.smartcase = true
o.hlsearch = true
o.incsearch = true
o.inccommand = "split"
o.grepprg = "rg --vimgrep --smart-case"
o.grepformat = "%f:%l:%c:%m"

-- Windows & splits
o.splitright = true
o.splitbelow = true
o.splitkeep = "screen"
o.winminwidth = 5

-- Files & persistence
o.undofile = true
o.undolevels = 10000
o.swapfile = false
o.backup = false
o.writebackup = false
o.autowrite = true
o.confirm = true
o.updatetime = 200
o.timeoutlen = 400
o.clipboard = "unnamedplus"
o.mouse = "a"
o.mousemoveevent = true
o.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- Folding (nvim-ufo drives the content; keep them open by default)
o.foldlevel = 99
o.foldlevelstart = 99
o.foldenable = true
o.foldcolumn = "1"

-- Completion / diagnostics feel
o.completeopt = "menu,menuone,noinsert"
o.conceallevel = 2
o.diffopt:append("linematch:60")
