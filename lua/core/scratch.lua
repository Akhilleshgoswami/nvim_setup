-- lua/akhilesh/core/scratch.lua
local M = {}

local NOTE_PATH = "~/Notes/todo.md"

local function ensure_dir()
  vim.fn.mkdir(vim.fn.expand("~/Notes"), "p")
end

local function git_sync()
  local term = Snacks.terminal
  term.open("cd ~/Notes && git pull && git add . && git commit -m 'notes sync' && git push", {
    interactive = false,
    auto_close  = true,
  })
end

function M.open_float()
  ensure_dir()

  -- toggle: close if already open
  if M._win and vim.api.nvim_win_is_valid(M._win) then
    vim.api.nvim_win_close(M._win, false)
    M._win = nil
    return
  end

  Snacks.win({
    file     = vim.fn.expand(NOTE_PATH),
    width    = 0.8,
    height   = 0.8,
    border   = "rounded",
    title    = " todo.md ",
    title_pos = "center",
    wo = {
      spell    = true,
      wrap     = true,
      signcolumn = "no",
    },
    on_win = function(win)
      M._win = win.win
      local buf = vim.api.nvim_win_get_buf(win.win)

      -- q → save and close
      vim.keymap.set("n", "q", function()
        vim.cmd("silent! w")
        vim.api.nvim_win_close(win.win, false)
        M._win = nil
      end, { buffer = buf, desc = "Save and close" })

      -- gs → git sync
      vim.keymap.set("n", "gs", function()
        vim.cmd("silent! w")
        git_sync()
      end, { buffer = buf, desc = "Git sync notes" })

      -- gp → git pull only
      vim.keymap.set("n", "gp", function()
        Snacks.terminal.open("cd ~/Notes && git pull", {
          interactive = false,
          auto_close  = true,
        })
      end, { buffer = buf, desc = "Git pull notes" })
    end,
  })
end

function M.open_split()
  ensure_dir()
  vim.cmd("vsplit " .. vim.fn.fnameescape(vim.fn.expand(NOTE_PATH)))
end

vim.api.nvim_create_autocmd("User", {
  pattern  = "VeryLazy",
  once     = true,
  callback = function()
    vim.keymap.set("n", "<leader>nt", M.open_float,  { desc = "Toggle todo float" })
    vim.keymap.set("n", "<leader>nv", M.open_split,  { desc = "Todo vsplit" })
  end,
})

vim.api.nvim_create_user_command("ScratchOpenFloat", M.open_float,  {})
vim.api.nvim_create_user_command("ScratchOpenSplit", M.open_split, {})

return M
