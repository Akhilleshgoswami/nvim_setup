-- Tasteful motion. Nothing flashy — just momentum that reinforces focus.
-- Every animation reads the same clock (umbra.motion): one easing, one tempo,
-- so nothing feels faster or slower than anything else. `<leader>uM` reduces it.

local motion = require("umbra.motion")

return {
  -- Smooth, eased scrolling for page/half-page/search jumps.
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    opts = {
      mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "zt", "zz", "zb" },
      hide_cursor = true,
      stop_eof = true,
      respect_scrolloff = true,
      cursor_scrolls_alone = true,
      easing_function = motion.easing,
      duration_multiplier = motion.scroll_multiplier,
    },
  },

  -- A soft animated cursor trail in the terminal. Toggled via `<leader>uM`
  -- (reduce motion) — smear is the most prominent movement in the editor.
  {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    opts = {
      stiffness = 0.8,
      trailing_stiffness = 0.6,
      trailing_exponent = 1.2,
      distance_stop_animating = 0.5,
      smear_between_buffers = true,
      smear_between_neighbor_lines = true,
      smear_insert_mode = false,
    },
  },
}
