-- One motion clock. Scrolling, the cursor, notifications and the cmdline all
-- read the same durations, easing and frame rate, so nothing feels faster or
-- slower than anything else. `<leader>uM` flips reduce-motion.

local M = {}

M.enabled = true
M.easing = "sine"
M.fps = 60

-- Durations in milliseconds.
M.duration = { fast = 120, base = 200, slow = 320 }

-- neoscroll expresses duration as a multiplier over its internal default.
M.scroll_multiplier = 0.6

-- Toggle the most prominent motion (cursor smear) and record the intent so any
-- surface can honour reduced motion.
function M.toggle()
  M.enabled = not M.enabled
  pcall(vim.cmd, "SmearCursorToggle")
  if package.loaded["notify"] then
    require("notify").setup({
      stages = M.enabled and "fade_in_slide_out" or "static",
      fps = M.fps,
    })
  end
  vim.notify(
    M.enabled and "Motion enabled" or "Reduced motion",
    vim.log.levels.INFO,
    { title = "Umbra" }
  )
end

return M
