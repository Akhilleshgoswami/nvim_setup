-- ============================================================
--  lua/akhilesh/plugins/gitsigns.lua
--  Modern Minimal Git UI  ·  Always-On Blame  ·  VS Code-style line hl (toggle)
-- ============================================================

return {
  "lewis6991/gitsigns.nvim",

  event = { "BufReadPre", "BufNewFile" },

  opts = {

    -- ======================================================
    -- UI
    -- ======================================================

    signcolumn = true,
    numhl      = true,   -- subtle number-column tinting
    linehl     = false,  -- off by default, toggle with <leader>hl
    word_diff  = false,

    attach_to_untracked  = true,
    current_line_blame   = false,

    sign_priority    = 6,
    update_debounce  = 100,
    max_file_length  = 40000,

    -- ======================================================
    -- SIGNS  (staged vs unstaged share the same glyphs,
    --         color tells them apart via highlights)
    -- ======================================================

    signs = {
      add          = { text = "▎" },
      change       = { text = "▎" },
      delete       = { text = "▁" },
      topdelete    = { text = "▔" },
      changedelete = { text = "▎" },
      untracked    = { text = "╎" },
    },

    signs_staged = {
      add          = { text = "▎" },
      change       = { text = "▎" },
      delete       = { text = "▁" },
      topdelete    = { text = "▔" },
      changedelete = { text = "▎" },
    },

    -- ======================================================
    -- GIT WATCHER
    -- ======================================================

    watch_gitdir = {
      interval     = 1000,
      follow_files = true,
    },

    -- ======================================================
    -- BLAME  ← always visible, richer format
    -- ======================================================

    current_line_blame_opts = {
      virt_text       = true,
      virt_text_pos   = "eol",
      delay           = 200,
      ignore_whitespace = false,
    },

    current_line_blame_formatter =
      " 󰊢 <author>  ·  <author_time:%R>  ·  <summary>",

    -- ======================================================
    -- PREVIEW WINDOW
    -- ======================================================

    preview_config = {
      border   = "rounded",
      style    = "minimal",
      relative = "cursor",
      row      = 1,
      col      = 1,
    },

    -- ======================================================
    -- ON ATTACH  — keymaps
    -- ======================================================

    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, {
          buffer  = bufnr,
          silent  = true,
          noremap = true,
          desc    = desc,
        })
      end

      -- NAVIGATION ─────────────────────────────────────────

      map("n", "]h", function()
        if vim.wo.diff then vim.cmd.normal({ "]c", bang = true })
        else gs.next_hunk() end
      end, "Next Hunk")

      map("n", "[h", function()
        if vim.wo.diff then vim.cmd.normal({ "[c", bang = true })
        else gs.prev_hunk() end
      end, "Prev Hunk")

      -- STAGE ───────────────────────────────────────────────

      map("n", "<leader>hs", gs.stage_hunk,  "Stage Hunk")
      map("v", "<leader>hs", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Stage Hunk")

      map("n", "<leader>hS", gs.stage_buffer,    "Stage Buffer")
      map("n", "<leader>hu", gs.undo_stage_hunk, "Undo Stage")

      -- RESET ───────────────────────────────────────────────

      map("n", "<leader>hr", gs.reset_hunk, "Reset Hunk")
      map("v", "<leader>hr", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Reset Hunk")

      map("n", "<leader>hR", gs.reset_buffer, "Reset Buffer")

      -- PREVIEW / DIFF ──────────────────────────────────────

      map("n", "<leader>hp", gs.preview_hunk,        "Preview Hunk")
      map("n", "<leader>hi", gs.preview_hunk_inline, "Inline Preview")

      -- diffthis auto-enables linehl so you see VS Code-style colours
      -- while reviewing, then restores off when you close
      map("n", "<leader>hd", function()
        gs.toggle_linehl()
        gs.diffthis()
      end, "Diff This")

      map("n", "<leader>hD", function()
        gs.toggle_linehl()
        gs.diffthis("~")
      end, "Diff Against ~")

      -- BLAME ───────────────────────────────────────────────

      map("n", "<leader>hb", function()
        gs.blame_line({ full = true })
      end, "Blame Line (popup)")

      map("n", "<leader>hB", gs.toggle_current_line_blame, "Toggle Blame")

      -- TOGGLES ─────────────────────────────────────────────

      map("n", "<leader>hx", gs.toggle_deleted,   "Toggle Deleted")
      map("n", "<leader>hw", gs.toggle_word_diff, "Toggle Word Diff")
      map("n", "<leader>hl", gs.toggle_linehl,    "Toggle Line Highlight")

    end,
  },

  -- ============================================================
  -- CONFIG + HIGHLIGHTS  (TokyoNight palette + VS Code-style linehl)
  -- ============================================================

  config = function(_, opts)
    require("gitsigns").setup(opts)

    local hl = vim.api.nvim_set_hl

    -- Signs ────────────────────────────────────────────────────
    hl(0, "GitSignsAdd",    { fg = "#9ece6a", bg = "NONE" })
    hl(0, "GitSignsChange", { fg = "#e0af68", bg = "NONE" })
    hl(0, "GitSignsDelete", { fg = "#f7768e", bg = "NONE" })

    -- Staged signs (slightly brighter / desaturated to differ)
    hl(0, "GitSignsStagedAdd",    { fg = "#b9f27c", bg = "NONE" })
    hl(0, "GitSignsStagedChange", { fg = "#f7c67f", bg = "NONE" })
    hl(0, "GitSignsStagedDelete", { fg = "#ff9aab", bg = "NONE" })

    -- Line-number tinting (numhl = true)
    hl(0, "GitSignsAddNr",    { fg = "#9ece6a", bg = "NONE", bold = true })
    hl(0, "GitSignsChangeNr", { fg = "#e0af68", bg = "NONE", bold = true })
    hl(0, "GitSignsDeleteNr", { fg = "#f7768e", bg = "NONE", bold = true })

    -- Blame virtual text  ─ dim + italic, fits right of code
    hl(0, "GitSignsCurrentLineBlame", {
      fg     = "#4a5170",
      bg     = "NONE",
      italic = true,
    })

    -- ── VS Code-style full-line backgrounds (active when linehl toggled on) ──
    --    Unstaged
    hl(0, "GitSignsAddLn",    { bg = "#1a2b1a" })  -- muted green
    hl(0, "GitSignsChangeLn", { bg = "#2b2209" })  -- muted amber
    hl(0, "GitSignsDeleteLn", { bg = "#3d0f0f" })  -- deep red, like VS Code

    --    Staged (a touch brighter to signal "ready to commit")
    hl(0, "GitSignsStagedAddLn",    { bg = "#1e3320" })
    hl(0, "GitSignsStagedChangeLn", { bg = "#332d14" })
    hl(0, "GitSignsStagedDeleteLn", { bg = "#4a1515" })

    -- Clean signcolumn — no bg bleed
    hl(0, "SignColumn", { bg = "NONE" })
  end,
}
