vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

-- ======================================================
-- Tabs & Indentation
-- ======================================================

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- ======================================================
-- UI
-- ======================================================

vim.opt.wrap = false
vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

vim.opt.signcolumn = "yes:1"

vim.opt.colorcolumn = "+1"

vim.opt.updatetime = 50

vim.opt.cursorline = true
vim.opt.cursorlineopt = "number,line"

vim.opt.cmdheight = 0

vim.opt.laststatus = 3

vim.opt.pumheight = 10
vim.opt.pumblend = 15
vim.opt.winblend = 15

vim.opt.showmode = false
vim.opt.showcmd = true
vim.opt.showmatch = true

vim.opt.list = true



vim.opt.list = true

vim.opt.listchars = {
  tab = "» ",
  trail = "·",
  nbsp = "␣",
  precedes = "←",
  extends = "→",
  eol = "↲",
}

vim.opt.fillchars = {
  eob = " ",
  fold = " ",
  foldopen = "",
  foldclose = "",
  foldsep = " ",
  diff = "╱",
}
vim.opt.listchars = {
  tab = "▏ ",
  trail = "·",
  nbsp = "␣",
}

vim.opt.fillchars = {
  eob = " ",
  fold = " ",
  foldopen = "",
  foldclose = "",
}




-- ======================================================
-- Search
-- ======================================================

vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- ======================================================
-- File handling
-- ======================================================

vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- ======================================================
-- Better file navigation
-- ======================================================

vim.opt.isfname:append("@-@")

-- ======================================================
-- Split windows
-- ======================================================

vim.opt.splitright = true
vim.opt.splitbelow = true

-- ======================================================
-- Folding
-- ======================================================

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldcolumn = "1"

-- ======================================================
-- Completion
-- ======================================================

vim.opt.completeopt = {
  "menu",
  "menuone",
  "noselect",
  "preview",
}

-- ======================================================
-- Disable netrw
-- ======================================================


-- ======================================================
-- Transparency
-- ======================================================

local transparent_group =
  vim.api.nvim_create_augroup("TransparentUI", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", {
  desc = "Transparent backgrounds",
  group = transparent_group,
  pattern = "*",

  callback = function()
    local transparent = {
      "Normal",
      "NormalNC",
      "NormalFloat",
      "FloatBorder",
      "SignColumn",
      "EndOfBuffer",
      "NeoTreeNormal",
      "NeoTreeNormalNC",
      "NvimTreeNormal",
      "NvimTreeNormalNC",
      "TelescopeNormal",
      "TelescopeBorder",
    }

    for _, group in ipairs(transparent) do
      vim.api.nvim_set_hl(0, group, {
        bg = "NONE",
        ctermbg = "NONE",
      })
    end
  end,
})

-- ======================================================
-- Harpoon UI
-- ======================================================

vim.cmd("highlight! HarpoonInactive guibg=NONE guifg=#63698c")
vim.cmd("highlight! HarpoonActive guibg=NONE guifg=white")

vim.cmd("highlight! HarpoonNumberActive guibg=NONE guifg=#7aa2f7")
vim.cmd("highlight! HarpoonNumberInactive guibg=NONE guifg=#7aa2f7")

vim.cmd("highlight! TabLineFill guibg=NONE guifg=white")

-- ======================================================
-- Diagnostics UI
-- ======================================================

vim.diagnostic.config({
  underline = true,
  update_in_insert = false,
  virtual_text = false,
  severity_sort = true,

  float = {
    border = "rounded",
    source = "if_many",
  },

  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "●",
      [vim.diagnostic.severity.WARN] = "●",
      [vim.diagnostic.severity.INFO] = "●",
      [vim.diagnostic.severity.HINT] = "●",
    },
  },
})

-- ======================================================
-- Oil.nvim
-- ======================================================

vim.keymap.set("n", "-", "<CMD>Oil<CR>", {
  desc = "Open parent directory",
})

vim.api.nvim_create_autocmd("User", {
  pattern = "OilEnter",

  callback = function(args)
    local ok, oil = pcall(require, "oil")

    if not ok then
      return
    end

    vim.schedule(function()
      if vim.api.nvim_get_current_buf() == args.data.buf
        and oil.get_cursor_entry()
      then
        oil.open_preview()
      end
    end)
  end,
})

-- ======================================================
-- Restore cursor position
-- ======================================================

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local last_pos = vim.fn.line([['"]])

    if last_pos > 0 and last_pos <= vim.fn.line("$") then
      vim.api.nvim_win_set_cursor(0, { last_pos, 0 })
    end
  end,
})

-- ======================================================
-- Highlight yanked text
-- ======================================================

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({
      higroup = "Visual",
      timeout = 150,
    })
  end,
})

-- ======================================================
-- Resize splits automatically
-- ======================================================

vim.api.nvim_create_autocmd("VimResized", {
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- ======================================================
-- Smooth Scroll (Neovim 0.10+)
-- ======================================================

if vim.fn.has("nvim-0.10") == 1 then
  vim.opt.smoothscroll = true
end

-- ======================================================
-- Hardmode movement trainer
-- ======================================================

local notify_id

for _, key in ipairs({ "h", "j", "k", "l" }) do
  local count = 0

  vim.keymap.set("n", key, function()
    if count >= 10 then
      notify_id = vim.notify(
        "Use better motions ⚡",
        vim.log.levels.WARN,
        {
          icon = "🧙",
          replace = notify_id,

          keep = function()
            return count >= 10
          end,
        }
      )
    else
      count = count + 1

      vim.defer_fn(function()
        count = math.max(count - 1, 0)
      end, 5000)

      return key
    end
  end, {
    expr = true,
    silent = true,
  })
end
vim.cmd("set list")
vim.schedule(function()
  vim.opt.list = true

  vim.opt.listchars = {
    tab = "» ",
    trail = "·",
    nbsp = "␣",
    extends = "→",
    precedes = "←",
  }

  vim.opt.fillchars = {
    eob = " ",
    foldopen = "",
    foldclose = "",
    foldsep = " ",
  }

  vim.opt.foldcolumn = "1"
  
end)


