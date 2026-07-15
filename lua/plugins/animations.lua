-- Tasteful motion. Nothing flashy — just momentum that reinforces focus.

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
      easing_function = "sine",
      duration_multiplier = 0.6,
    },
  },

  -- A soft animated cursor trail in the terminal.
  {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    keys = { { "<leader>uC", "<cmd>SmearCursorToggle<cr>", desc = "Toggle cursor smear" } },
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
