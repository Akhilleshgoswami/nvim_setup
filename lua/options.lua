require "nvchad.options"

-- Use vim.o (global-only) to avoid E21 when startup/dashboard buffer is not modifiable
local o = vim.o

vim.g.autoformat = true
vim.g.markdown_recommended_style = 0

o.fillchars = "fold: ,foldopen:,foldclose:,foldsep: ,diff:╱,eob: "
o.listchars = "tab:>>>,trail:·,precedes:←,extends:→,eol:↲,nbsp:␣"
o.autowrite = true
o.foldnestmax = 4
o.foldlevel = 99
o.foldlevelstart = 99
o.foldenable = true
o.mouse = "a"
o.backupcopy = "yes"
o.undolevels = 10000
vim.o.shortmess = vim.o.shortmess .. "WICcC"
o.showmode = false
o.hidden = true
o.splitright = true
o.splitbelow = true
o.wrapscan = true
o.backup = false
o.writebackup = false
o.showcmd = true
o.showmatch = true
o.ignorecase = true
o.hlsearch = true
o.smartcase = true
o.errorbells = false
o.joinspaces = false
o.title = true
o.encoding = "UTF-8"
o.completeopt = "menu,menuone,noselect"
o.clipboard = "unnamedplus"
o.laststatus = 3
o.timeoutlen = 500
o.splitkeep = "screen"
o.termguicolors = true
o.updatetime = 200
o.virtualedit = "block"
o.wildmode = "longest:full,full"
o.winminwidth = 5
o.fileformat = "unix"
o.tabstop = 2
o.spelllang = "it"
o.softtabstop = 2
o.swapfile = false
o.undofile = false
o.smartindent = true
o.expandtab = true
o.shiftwidth = 2
o.number = true
o.colorcolumn = "+1"
o.list = true
o.signcolumn = "yes:1"
o.relativenumber = true
o.cursorline = true
o.conceallevel = 2
o.confirm = true
o.formatoptions = "jcroqlnt"
o.grepformat = "%f:%l:%c:%m"
o.grepprg = "rg --vimgrep"
o.inccommand = "nosplit"
o.pumblend = 10
o.pumheight = 10
o.scrolloff = 4
o.sessionoptions = "buffers,curdir,tabpages,winsize,help,globals,skiprtp,folds"
o.shiftround = true
o.diffopt = "internal,filler,closeoff,linematch:60"
o.sidescrolloff = 8

if vim.fn.has("nvim-0.10") == 1 then
  o.smoothscroll = true
end
