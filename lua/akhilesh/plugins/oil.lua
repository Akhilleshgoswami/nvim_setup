-- ============================================================
--  lua/akhilesh/plugins/oil.lua
-- ============================================================

return {
  "stevearc/oil.nvim",
  lazy = false,  -- load immediately so `nvim .` works
  dependencies = {
    { "echasnovski/mini.icons",   opts = {} },
    { "SirZenith/oil-vcs-status"              },
  },

  keys = {
    { "-",          "<cmd>Oil<CR>",                    desc = "Open parent dir (Oil)" },
    { "<leader>e",  "<cmd>Oil<CR>",                    desc = "Explorer (Oil)" },
    { "<leader>E",  "<cmd>Oil --float<CR>",            desc = "Explorer float (Oil)" },
  },

  opts = {
    -- use mini.icons instead of nvim-web-devicons
    default_file_explorer = true,
    delete_to_trash       = true,
    skip_confirm_for_simple_edits = true,
    prompt_save_on_select_new_entry = true,

    win_options = {
      wrap         = false,
      signcolumn   = "yes:2",
      cursorcolumn = false,
      foldcolumn   = "0",
      spell        = false,
      list         = false,
      conceallevel = 3,
      concealcursor = "nvic",
    },

    view_options = {
      show_hidden  = true,
      -- hide real dotfiles from the list but keep .git visible
      is_hidden_file = function(name, _)
        return name == ".DS_Store"
      end,
      is_always_hidden = function(name, _)
        return name == ".."
      end,
      natural_order = true,
      sort = {
        { "type", "asc" },
        { "name", "asc" },
      },
    },

    float = {
      padding      = 2,
      max_width    = 90,
      max_height   = 0,
      border       = "rounded",
      win_options  = { winblend = 0 },
    },

    preview = {
      max_width    = { 100, 0.8 },
      min_width    = { 40,  0.4 },
      max_height   = { 30,  0.6 },
      min_height   = { 5,   0.1 },
      border       = "rounded",
      win_options  = { winblend = 0 },
    },

    keymaps = {
      ["g?"]    = "actions.show_help",
      ["<CR>"]  = "actions.select",
      ["l"]     = "actions.select",
      ["h"]     = "actions.parent",
      ["<C-v>"] = { "actions.select", opts = { vertical   = true }, desc = "Open vsplit" },
      ["<C-s>"] = { "actions.select", opts = { horizontal = true }, desc = "Open split"  },
      ["<C-t>"] = { "actions.select", opts = { tab        = true }, desc = "Open tab"    },
      ["<C-p>"] = "actions.preview",
      ["<C-r>"] = "actions.refresh",
      ["q"]     = "actions.close",
      ["<Esc>"] = "actions.close",
      ["."]     = "actions.toggle_hidden",
      ["gx"]    = "actions.open_external",
      ["gs"]    = "actions.change_sort",
      ["gd"]    = { "actions.select", opts = { close = false }, desc = "Open, keep oil" },
      ["Y"]     = { callback = function()
                      local oil = require("oil")
                      local entry = oil.get_cursor_entry()
                      if entry then
                        local dir = oil.get_current_dir()
                        vim.fn.setreg("+", dir .. entry.name)
                        vim.notify("Copied: " .. dir .. entry.name, vim.log.levels.INFO)
                      end
                    end, desc = "Yank filepath" },
    },

    use_default_keymaps = false,
  },

  config = function(_, opts)
    require("oil").setup(opts)

    -- ── VCS status signs ─────────────────────────────────────
    local ok, vcs = pcall(require, "oil-vcs-status")
    if not ok then return end

    local StatusType = require("oil-vcs-status.constant.status").StatusType

    vcs.setup({
      status_symbol = {
        [StatusType.Added]           = " ",
        [StatusType.Copied]          = "󰆏 ",
        [StatusType.Deleted]         = " ",
        [StatusType.Ignored]         = " ",
        [StatusType.Modified]        = " ",
        [StatusType.Renamed]         = " ",
        [StatusType.TypeChanged]     = "󰉺 ",
        [StatusType.Unmodified]      = "  ",
        [StatusType.Unmerged]        = " ",
        [StatusType.Untracked]       = " ",
        [StatusType.External]        = " ",

        [StatusType.UpstreamAdded]       = "󰈞 ",
        [StatusType.UpstreamCopied]      = "󰈒 ",
        [StatusType.UpstreamDeleted]     = " ",
        [StatusType.UpstreamIgnored]     = " ",
        [StatusType.UpstreamModified]    = "󰏫 ",
        [StatusType.UpstreamRenamed]     = " ",
        [StatusType.UpstreamTypeChanged] = "󱧶 ",
        [StatusType.UpstreamUnmodified]  = "  ",
        [StatusType.UpstreamUnmerged]    = " ",
        [StatusType.UpstreamUntracked]   = " ",
        [StatusType.UpstreamExternal]    = " ",
      },
    })
  end,
}
