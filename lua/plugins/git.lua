-- Git: a VS Code-grade Source Control experience.
--   gitsigns  → gutter, inline hunks, staging, blame
--   neogit    → native Source Control panel (branch, ahead/behind, stage, commit)
--   diffview  → side-by-side diffs + file/branch history
--   lazygit   → full TUI when you want it
--   telescope → branch / commit / status pickers

local icons = require("utils.icons")

return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    -- Keymaps live on the spec (not in on_attach) so they're reliable and
    -- discoverable; the functions operate on the current buffer.
    keys = {
      { "]h", function()
        if vim.wo.diff then vim.cmd.normal({ "]c", bang = true }) else require("gitsigns").nav_hunk("next") end
      end, desc = "Next hunk" },
      { "[h", function()
        if vim.wo.diff then vim.cmd.normal({ "[c", bang = true }) else require("gitsigns").nav_hunk("prev") end
      end, desc = "Prev hunk" },
      { "<leader>gp", function() require("gitsigns").preview_hunk() end, desc = "Preview hunk (float)" },
      { "<leader>gs", ":Gitsigns stage_hunk<CR>", mode = { "n", "v" }, desc = "Stage hunk" },
      { "<leader>gr", ":Gitsigns reset_hunk<CR>", mode = { "n", "v" }, desc = "Reset hunk" },
      { "<leader>gS", function() require("gitsigns").stage_buffer() end, desc = "Stage file" },
      { "<leader>gR", function() require("gitsigns").reset_buffer() end, desc = "Reset file" },
      { "<leader>gu", function()
        local gs = require("gitsigns")
        ;(gs.undo_stage_hunk or gs.reset_buffer_index)()
      end, desc = "Undo stage hunk" },
      { "<leader>gU", function() require("gitsigns").reset_buffer_index() end, desc = "Undo all staged (file)" },
      { "<leader>gb", function() require("gitsigns").toggle_current_line_blame() end, desc = "Toggle inline blame" },
      { "<leader>gB", function() require("gitsigns").blame_line({ full = true }) end, desc = "Blame line (popup)" },
      { "<leader>gw", function() require("gitsigns").toggle_word_diff() end, desc = "Toggle word diff" },
      { "ih", ":<C-U>Gitsigns select_hunk<CR>", mode = { "o", "x" }, desc = "Select hunk" },
    },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signs_staged = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
      },
      signs_staged_enable = true,
      -- Real-time gutter, VS Code style.
      watch_gitdir = { follow_files = true },
      update_debounce = 80,
      current_line_blame = false,
      current_line_blame_opts = { delay = 350, virt_text_pos = "eol", ignore_whitespace = true },
      current_line_blame_formatter = "  <author>, <author_time:%R> · <summary>",
      preview_config = { border = "rounded" },
    },
    config = function(_, opts)
      require("gitsigns").setup(opts)

      -- VS Code semantics for the gutter: green added, blue modified, red
      -- deleted — adapting to whatever theme is active (blue is pulled from the
      -- theme's own info/function color so it always fits).
      local function vscode_gutter()
        local function fg(groups, fallback)
          for _, g in ipairs(groups) do
            local ok, h = pcall(vim.api.nvim_get_hl, 0, { name = g, link = false })
            if ok and h and h.fg then
              return string.format("#%06x", h.fg)
            end
          end
          return fallback
        end
        local add = fg({ "Added", "diffAdded", "@diff.plus", "DiagnosticOk", "String" }, "#9BD09E")
        local change = fg({ "DiagnosticInfo", "@diff.delta", "Function" }, "#7FA7F0")
        local delete = fg({ "Removed", "diffRemoved", "@diff.minus", "DiagnosticError" }, "#EB6F82")
        local set = vim.api.nvim_set_hl
        set(0, "GitSignsAdd", { fg = add })
        set(0, "GitSignsChange", { fg = change })
        set(0, "GitSignsDelete", { fg = delete })
        set(0, "GitSignsChangedelete", { fg = change })
        set(0, "GitSignsTopdelete", { fg = delete })
        set(0, "GitSignsUntracked", { fg = add })
        set(0, "GitSignsAddNr", { fg = add })
        set(0, "GitSignsChangeNr", { fg = change })
        set(0, "GitSignsDeleteNr", { fg = delete })
      end

      vscode_gutter()
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("umbra_gitsigns_hl", { clear = true }),
        callback = vscode_gutter,
      })
    end,
  },

  -- ── Source Control panel (VS Code-like) ────────────────────────
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Git panel (source control)" },
      { "<leader>gC", "<cmd>Neogit commit<cr>", desc = "Git commit" },
      { "<leader>gP", "<cmd>Neogit pull<cr>", desc = "Git pull" },
    },
    opts = {
      -- Its own tab: shows branch, ahead/behind, staged/unstaged/untracked and
      -- merge conflicts without disturbing your window layout.
      kind = "tab",
      graph_style = "unicode",
      disable_hint = false,
      signs = {
        hunk = { icons.ui.fold_closed, icons.ui.fold_open },
        item = { icons.ui.fold_closed, icons.ui.fold_open },
        section = { icons.ui.fold_closed, icons.ui.fold_open },
      },
      integrations = { diffview = true, telescope = true },
    },
  },

  -- ── Side-by-side diff + history ────────────────────────────────
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles" },
    keys = {
      {
        "<leader>gd",
        function()
          local view = require("diffview.lib").get_current_view()
          if view then vim.cmd("DiffviewClose") else vim.cmd("DiffviewOpen") end
        end,
        desc = "Diff view (toggle)",
      },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history (current)" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Branch/project history" },
      { "<leader>gq", "<cmd>DiffviewToggleFiles<cr>", desc = "Toggle diff file panel" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default = { winbar_info = true },
        merge_tool = { layout = "diff3_mixed" },
      },
      file_panel = { win_config = { width = 32 } },
    },
  },

  -- ── Full TUI (optional power tool) ─────────────────────────────
  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitConfig", "LazyGitFilterCurrentFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gG", "<cmd>LazyGit<cr>", desc = "LazyGit (full TUI)" },
      { "<leader>gF", "<cmd>LazyGitFilterCurrentFile<cr>", desc = "LazyGit (file history)" },
    },
    init = function()
      vim.g.lazygit_floating_window_scaling_factor = 0.9
      vim.g.lazygit_floating_window_border_chars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
    end,
  },

  -- ── Telescope git pickers ──────────────────────────────────────
  {
    "nvim-telescope/telescope.nvim",
    optional = true,
    keys = {
      { "<leader>go", "<cmd>Telescope git_branches<cr>", desc = "Branches (checkout)" },
      { "<leader>gl", "<cmd>Telescope git_commits<cr>", desc = "Commit log" },
      { "<leader>gf", "<cmd>Telescope git_status<cr>", desc = "Changed files" },
    },
  },
}
