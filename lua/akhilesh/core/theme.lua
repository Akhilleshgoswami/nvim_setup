local M = {}

local themes = {
  "gruvbox",
  "catppuccin",
  "tokyonight",
  "rose-pine",
  "kanagawa",
}

-- =========================================================
-- APPLY THEME SAFELY (with smooth fade illusion)
-- =========================================================
function M.apply(theme)
  if not theme then return end

  -- fake fade-out
  vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
  vim.cmd("redraw")

  vim.schedule(function()
    vim.cmd("colorscheme " .. theme)
  end)

  vim.g.current_theme = theme
end

-- =========================================================
-- FUZZY PICKER (VSCode Cmd+K Cmd+T style)
-- =========================================================
function M.pick()
  local ok, telescope = pcall(require, "telescope.builtin")

  if not ok then
    vim.notify("Telescope not installed", vim.log.levels.ERROR)
    return
  end

  telescope.colorscheme({
    enable_preview = true,
    attach_mappings = function(_, map)
      local actions = require("telescope.actions")

      map("i", "<CR>", function(prompt_bufnr)
        local selection = require("telescope.actions.state").get_selected_entry()
        actions.close(prompt_bufnr)

        if selection and selection.value then
          M.apply(selection.value)
        end
      end)

      return true
    end,
  })
end

-- =========================================================
-- AUTO SWITCH (DAY / NIGHT MODE)
-- =========================================================
function M.auto()
  local hour = tonumber(os.date("%H"))

  if hour >= 7 and hour < 18 then
    M.apply("catppuccin")   -- daytime
  else
    M.apply("tokyonight")   -- night
  end
end

-- =========================================================
-- TOGGLE NEXT THEME
-- =========================================================
function M.next()
  local current = vim.g.current_theme or "gruvbox"

  local index = 1
  for i, t in ipairs(themes) do
    if t == current then
      index = i + 1
      break
    end
  end

  if index > #themes then
    index = 1
  end

  M.apply(themes[index])
end
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require("akhilesh.core.theme").auto()
  end,
})
return M
