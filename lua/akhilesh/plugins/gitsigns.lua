-- ============================================================
--  lua/akhilesh/plugins/gitsigns.lua
-- ============================================================

return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signcolumn = true,
    numhl      = true,
    linehl     = false,
    word_diff  = false,

    signs = {
      add          = { text = "▎" },
      change       = { text = "▎" },
      delete       = { text = "" },
      topdelete    = { text = "" },
      changedelete = { text = "▎" },
      untracked    = { text = "▎" },
    },

    signs_staged = {
      add          = { text = "▎" },
      change       = { text = "▎" },
      delete       = { text = "" },
      topdelete    = { text = "" },
      changedelete = { text = "▎" },
    },

    watch_gitdir        = { interval = 1000, follow_files = true },
    attach_to_untracked = true,
    sign_priority       = 6,
    update_debounce     = 100,
    max_file_length     = 40000,

    current_line_blame = false,
    current_line_blame_opts = {
      virt_text        = true,
      virt_text_pos    = "eol",
      ignore_whitespace = false,
      delay            = 300,
    },
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> · <summary>",

    preview_config = {
      border   = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" },
      style    = "minimal",
      relative = "cursor",
      row      = 0,
      col      = 1,
    },

    -- ── Keymaps ────────────────────────────────────────────
    on_attach = function(bufnr)
      local gs  = package.loaded.gitsigns
      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, noremap = true, desc = desc })
      end

      -- Navigation: jump between hunks, respecting diff mode
      map("n", "]h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gs.next_hunk()
        end
      end, "Next hunk")

      map("n", "[h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gs.prev_hunk()
        end
      end, "Prev hunk")

      -- Staging
      map("n", "<leader>hs", gs.stage_hunk,                                            "Stage hunk")
      map("n", "<leader>hS", gs.stage_buffer,                                          "Stage buffer")
      map("n", "<leader>hu", gs.undo_stage_hunk,                                       "Undo stage hunk")
      map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage hunk (visual)")

      -- Resetting
      map("n", "<leader>hr", gs.reset_hunk,                                            "Reset hunk")
      map("n", "<leader>hR", gs.reset_buffer,                                          "Reset buffer")
      map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Reset hunk (visual)")

      -- Preview / blame / diff
      map("n", "<leader>hp", gs.preview_hunk,                                          "Preview hunk")
      map("n", "<leader>hi", gs.preview_hunk_inline,                                   "Preview hunk inline")
      map("n", "<leader>hb", function() gs.blame_line({ full = true }) end,            "Blame line (full)")
      map("n", "<leader>hB", gs.toggle_current_line_blame,                             "Toggle line blame")
      map("n", "<leader>hd", gs.diffthis,                                              "Diff this")
      map("n", "<leader>hD", function() gs.diffthis("~") end,                          "Diff this ~")

      -- Toggles
      map("n", "<leader>hx", gs.toggle_deleted,                                        "Toggle deleted")
      map("n", "<leader>hw", gs.toggle_word_diff,                                      "Toggle word diff")

      -- Text object: ih = inner hunk
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>",                       "Select hunk")
    end,
  },
}
