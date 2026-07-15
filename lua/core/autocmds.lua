-- Autocommands. Grouped and idempotent.

local function augroup(name)
  return vim.api.nvim_create_augroup("umbra_" .. name, { clear = true })
end
local autocmd = vim.api.nvim_create_autocmd

-- Briefly flash yanked text.
autocmd("TextYankPost", {
  group = augroup("yank_highlight"),
  callback = function()
    (vim.hl or vim.highlight).on_yank({ higroup = "Visual", timeout = 150 })
  end,
})

-- Return to last edit position when reopening a file.
autocmd("BufReadPost", {
  group = augroup("last_location"),
  callback = function(event)
    local exclude = { "gitcommit", "gitrebase" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].umbra_last_loc then
      return
    end
    vim.b[buf].umbra_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Equalize splits when the window is resized.
autocmd("VimResized", {
  group = augroup("resize_splits"),
  callback = function()
    local current = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current)
  end,
})

-- Close throwaway/util buffers with `q`.
autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "help", "man", "qf", "lspinfo", "checkhealth", "notify", "startuptime",
    "query", "spectre_panel", "neotest-output", "neotest-summary", "dbout",
    "fugitive", "git", "gitsigns-blame", "grug-far",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, { buffer = event.buf, silent = true, desc = "Close window" })
    end)
  end,
})

-- Create parent directories on save.
autocmd("BufWritePre", {
  group = augroup("auto_mkdir"),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Reload files changed on disk.
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Prose-friendly defaults for text filetypes.
autocmd("FileType", {
  group = augroup("prose"),
  pattern = { "markdown", "text", "gitcommit" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_us"
  end,
})

-- Skip heavy features on very large files.
autocmd("BufReadPre", {
  group = augroup("bigfile"),
  callback = function(event)
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(event.buf))
    if ok and stats and stats.size > 1.5 * 1024 * 1024 then
      vim.b[event.buf].umbra_bigfile = true
      vim.opt_local.foldmethod = "manual"
      vim.opt_local.spell = false
      vim.schedule(function()
        pcall(vim.treesitter.stop, event.buf)
        vim.bo[event.buf].syntax = "off"
      end)
    end
  end,
})

