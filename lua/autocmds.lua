local autocmd = vim.api.nvim_create_autocmd

autocmd("BufReadPost", {
  callback = function()
    local last_pos = vim.fn.line("'\"")
    if last_pos > 0 and last_pos <= vim.fn.line("$") then
      vim.api.nvim_win_set_cursor(0, { last_pos, 0 })
    end
  end,
})

autocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank()
  end,
})

autocmd("User", {
  pattern = "VeryLazy",
  once = true,
  callback = function()
    require("core.theme").setup_startup()
    require("akhilesh.ui").setup()
    require("core.scratch")
    require("core.hjkl")
    require("core.theme").setup_keymaps()
  end,
})

-- Close stray empty splits (e.g. leftover preview panes)
autocmd("BufEnter", {
  callback = function()
    if #vim.api.nvim_list_tabpages() > 1 or #vim.api.nvim_list_wins() < 2 then
      return
    end

    local current = vim.api.nvim_get_current_win()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if win ~= current and vim.api.nvim_win_is_valid(win) then
        local buf = vim.api.nvim_win_get_buf(win)
        local name = vim.api.nvim_buf_get_name(buf)
        local empty = vim.bo[buf].buftype == ""
          and name == ""
          and vim.api.nvim_buf_line_count(buf) <= 1
          and (vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] or "") == ""

        if empty then
          pcall(vim.api.nvim_win_close, win, true)
        end
      end
    end
  end,
})
