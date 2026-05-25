-- ============================================================
--  lua/akhilesh/plugins/gitsigns.lua
--  Modern Minimal Git UI
--  Theme-aware + clean signs
-- ============================================================

return {
  "lewis6991/gitsigns.nvim",

  event = { "BufReadPre", "BufNewFile" },

  opts = {

    -- ======================================================
    -- UI
    -- ======================================================

    signcolumn = true,
    numhl = false,
    linehl = false,
    word_diff = false,

    attach_to_untracked = true,
    current_line_blame = false,

    sign_priority = 6,
    update_debounce = 100,
    max_file_length = 40000,

    -- ======================================================
    -- MODERN SIGNS
    -- ======================================================

    signs = {
      add = {
        text = "│",

      },

      change = {
        text = "│",
      },

      delete = {
        text = "󰍵",
      },

      topdelete = {
        text = "‾",
      },

      changedelete = {
        text = "~",
      },

      untracked = {
        text = "┆",
      },
    },

    signs_staged = {
      add = {
        text = "│",
      },

      change = {
        text = "│",
      },

      delete = {
        text = "󰍵",
      },

      topdelete = {
        text = "‾",
      },

      changedelete = {
        text = "~",
      },
    },

    -- ======================================================
    -- GIT WATCHER
    -- ======================================================

    watch_gitdir = {
      interval = 1000,
      follow_files = true,
    },

    -- ======================================================
    -- BLAME
    -- ======================================================

    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol",
      delay = 300,
      ignore_whitespace = false,
    },

    current_line_blame_formatter =
      "󰊢 <author> • <author_time:%R> • <summary>",

    -- ======================================================
    -- PREVIEW WINDOW
    -- ======================================================

    preview_config = {
      border = "rounded",
      style = "minimal",
      relative = "cursor",
      row = 1,
      col = 1,
    },

    -- ======================================================
    -- ON ATTACH
    -- ======================================================

    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(
          mode,
          lhs,
          rhs,
          {
            buffer = bufnr,
            silent = true,
            noremap = true,
            desc = desc,
          }
        )
      end

      -- ====================================================
      -- NAVIGATION
      -- ====================================================

      map("n", "]h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gs.next_hunk()
        end
      end, "Next Hunk")

      map("n", "[h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gs.prev_hunk()
        end
      end, "Prev Hunk")

      -- ====================================================
      -- STAGE
      -- ====================================================

      map("n", "<leader>hs", gs.stage_hunk, "Stage Hunk")

      map("v", "<leader>hs", function()
        gs.stage_hunk({
          vim.fn.line("."),
          vim.fn.line("v"),
        })
      end, "Stage Hunk")

      map("n", "<leader>hS", gs.stage_buffer, "Stage Buffer")

      map("n", "<leader>hu", gs.undo_stage_hunk, "Undo Stage")

      -- ====================================================
      -- RESET
      -- ====================================================

      map("n", "<leader>hr", gs.reset_hunk, "Reset Hunk")

      map("v", "<leader>hr", function()
        gs.reset_hunk({
          vim.fn.line("."),
          vim.fn.line("v"),
        })
      end, "Reset Hunk")

      map("n", "<leader>hR", gs.reset_buffer, "Reset Buffer")

      -- ====================================================
      -- PREVIEW / DIFF
      -- ====================================================

      map("n", "<leader>hp", gs.preview_hunk, "Preview Hunk")

      map("n", "<leader>hi", gs.preview_hunk_inline, "Inline Preview")

      map("n", "<leader>hd", gs.diffthis, "Diff This")

      map("n", "<leader>hD", function()
        gs.diffthis("~")
      end, "Diff Against ~")

      -- ====================================================
      -- BLAME
      -- ====================================================

      map("n", "<leader>hb", function()
        gs.blame_line({ full = true })
      end, "Blame Line")

      map("n", "<leader>hB", gs.toggle_current_line_blame, "Toggle Blame")

      -- ====================================================
      -- TOGGLES
      -- ====================================================

      map("n", "<leader>hx", gs.toggle_deleted, "Toggle Deleted")

      map("n", "<leader>hw", gs.toggle_word_diff, "Toggle Word Diff")

      -- ====================================================
      -- TEXT OBJECT
      -- ====================================================

      map(
        { "o", "x" },
        "ih",
        ":<C-U>Gitsigns select_hunk<CR>",
        "Select Hunk"
      )
    end,
  },

  -- ==========================================================
  -- THEME HIGHLIGHTS
  -- ==========================================================

  config = function(_, opts)
    require("gitsigns").setup(opts)

    -- TOKYONIGHT STYLE
    vim.api.nvim_set_hl(0, "GitSignsAdd", {
      fg = "#9ece6a",
      bg = "NONE",
    })

    vim.api.nvim_set_hl(0, "GitSignsChange", {
      fg = "#e0af68",
      bg = "NONE",
    })

    vim.api.nvim_set_hl(0, "GitSignsDelete", {
      fg = "#f7768e",
      bg = "NONE",
    })

    vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", {
      fg = "#565f89",
      italic = true,
      bg = "NONE",
    })

    -- remove ugly signcolumn background
    vim.api.nvim_set_hl(0, "SignColumn", {
      bg = "NONE",
    })

    vim.api.nvim_set_hl(0, "GitSignsAddLn", {
      bg = "NONE",
    })

    vim.api.nvim_set_hl(0, "GitSignsChangeLn", {
      bg = "NONE",
    })

    vim.api.nvim_set_hl(0, "GitSignsDeleteLn", {
      bg = "NONE",
    })
  end,
}
