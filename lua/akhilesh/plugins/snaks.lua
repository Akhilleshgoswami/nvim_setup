-- ============================================================
--  lua/akhilesh/plugins/snacks.lua
-- ============================================================

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy     = false,

  ---@type snacks.Config
  opts = {

    -- ── Core modules ─────────────────────────────────────────
    animate      = { enabled = true },
    bigfile      = { enabled = true },
    bufdelete    = { enabled = true },
    debug        = { enabled = false },
    dim          = { enabled = true },
    git          = { enabled = true },
    gitbrowse    = { enabled = true },
    indent       = { enabled = true },
    input        = { enabled = true },
    lazygit      = { enabled = true },
    notify       = { enabled = true },
    quickfile    = { enabled = true },
    rename       = { enabled = false },
    scope        = { enabled = true },
    scroll       = { enabled = true },
    statuscolumn = { enabled = true },
    terminal     = { enabled = true },
    toggle       = { enabled = true },
    win          = { enabled = true },
    words        = { enabled = true },
    zen          = { enabled = true },

    -- ── Notifier ─────────────────────────────────────────────
    notifier = {
      enabled = true,
      timeout = 3000,
      style   = "fancy",
    },

    -- ── Styles ───────────────────────────────────────────────
    styles = {
      notification = {
        wo = { wrap = true },
      },
      lazygit = {
        width  = 0,
        height = 0,
      },
    },

    -- ── Picker ───────────────────────────────────────────────
    picker = {
      actions = {
        sidekick_send = function(...)
          return require("sidekick.cli.picker.snacks").send(...)
        end,
      },
      win = {
        input = {
          keys = {
            ["<A-a>"] = { "sidekick_send", mode = { "n", "i" } },
          },
        },
      },
      sources = {
        explorer = { focus = "input" },
      },
      formatters = {
        file = { truncate = 100 },
      },
      layout = {
        preset  = "telescope",
        reverse = false,
        preview = true,
      },
    },

    -- ── Dashboard ────────────────────────────────────────────
    dashboard = {
      preset = {
        header = [[
        ███╗   ██╗██╗   ██╗      ██╗██████╗ ███████╗
        ████╗  ██║██║   ██║      ██║██╔══██╗██╔════╝
        ██╔██╗ ██║██║   ██║█████╗██║██║  ██║█████╗
        ██║╚██╗██║╚██╗ ██╔╝╚════╝██║██║  ██║██╔══╝
        ██║ ╚████║ ╚████╔╝       ██║██████╔╝███████╗
        ╚═╝  ╚═══╝  ╚═══╝        ╚═╝╚═════╝ ╚══════╝]],

        keys = {
          { icon = " ",  key = "e", desc = "New file",      action = ":ene | startinsert" },
          { icon = "ﭯ ", key = "o", desc = "Recent files",  action = ":lua Snacks.dashboard.pick('oldfiles')" },
          -- function() ensures seeker.nvim is loaded lazily on click
          { icon = " ",  key = "f", desc = "Find file",     action = function() vim.cmd("Seeker files") end },
          { icon = " ",  key = "r", desc = "Find word",     action = function() vim.cmd("Seeker grep") end },
          { icon = " ",  key = "g", desc = "Git status",    action = ":lua Snacks.dashboard.pick('git_status')" },
          { icon = " ",  key = "p", desc = "Find project",  action = ":Telescope repo list",
            enabled = package.loaded["telescope"] ~= nil },
          { icon = " ",  key = "m", desc = "Marks",         action = ":HauntList" },
          { icon = " ",  key = "t", desc = "Todo",          action = ":TodoTrouble" },
          { icon = " ",  key = "s", desc = "Plugin config", action = ":e ~/.config/nvim/lua/plugins/init.lua" },
          { icon = " ",  key = "z", desc = "ZSH config",    action = ":e ~/.zshrc" },
          { icon = "󰒲 ", key = "u", desc = "Lazy sync",     action = ":Lazy sync",
            enabled = package.loaded.lazy ~= nil },
          { icon = " ",  key = "q", desc = "Quit",          action = ":qa" },
        },
      },

      sections = {
        { section = "header" },
        { section = "keys",         gap = 1, padding = 1 },
        { section = "recent_files", icon = " ", title = "Recent Files", indent = 2, padding = 1 },
        { section = "projects",     icon = " ", title = "Projects",     indent = 2, padding = 1 },
        { section = "startup",      padding = 1 },

        -- pane 2: git browse shortcut
        {
          pane    = 2,
          icon    = " ",
          desc    = "Browse Repo",
          key     = "b",
          padding = 1,
          action  = function() Snacks.gitbrowse() end,
        },

        -- pane 2: live git terminal widgets
        function()
          local in_git = Snacks.git.get_root() ~= nil
          local cmds = {
            {
              icon   = " ",
              title  = "Git Status",
              cmd    = "git --no-pager diff --stat -B -M -C",
              height = 10,
            },
            {
              icon   = " ",
              title  = "Open Issues",
              cmd    = "gh issue list -L 3",
              key    = "i",
              height = 7,
              action = function() vim.fn.jobstart("gh issue list --web", { detach = true }) end,
            },
            {
              icon   = " ",
              title  = "Open PRs",
              cmd    = "gh pr list -L 3",
              key    = "P",
              height = 7,
              action = function() vim.fn.jobstart("gh pr list --web", { detach = true }) end,
            },
          }
          return vim.tbl_map(function(cmd)
            return vim.tbl_extend("force", {
              pane    = 2,
              section = "terminal",
              enabled = in_git,
              padding = 1,
              ttl     = 5 * 60,
              indent  = 3,
            }, cmd)
          end, cmds)
        end,
      },
    },
  },

  -- ── Keymaps ──────────────────────────────────────────────
  keys = {
    -- Notifications
    { "<leader>un",  function() Snacks.notifier.hide() end,                desc = "Dismiss notifications" },

    -- Buffers
    { "<leader>bd",  function() Snacks.bufdelete() end,                    desc = "Delete buffer" },
    { "<leader>bda", function() Snacks.bufdelete.all() end,                desc = "Delete all buffers" },
    { "<leader>bdo", function() Snacks.bufdelete.other() end,              desc = "Delete other buffers" },

    -- Git
    { "<leader>gg",  function() Snacks.lazygit() end,                      desc = "Lazygit" },
    { "<leader>gb",  function() Snacks.git.blame_line() end,               desc = "Git blame line" },
    { "<leader>gB",  function() Snacks.gitbrowse() end,                    desc = "Git browse" },
    { "<leader>gf",  function() Snacks.lazygit.log_file() end,             desc = "Lazygit file history" },
    { "<leader>gl",  function() Snacks.lazygit.log() end,                  desc = "Lazygit log" },

    -- GitHub PRs
    { "<leader>gpr",  function() Snacks.terminal("gh pr list && echo 'Press enter...'; read") end, desc = "PR list" },
    { "<leader>gprc", function() Snacks.terminal("gh pr create") end,                              desc = "PR create" },
    { "<leader>gprm", function() Snacks.terminal("gh pr ready ; gh pr merge") end,                 desc = "PR merge" },

    -- GitHub Issues
    { "<leader>gil",  function() Snacks.terminal("gh issue list && echo 'Press enter...'; read") end, desc = "Issue list" },
    { "<leader>gio",  function() Snacks.terminal("gh issue create") end,                               desc = "Issue create" },
    { "<leader>gic",  function()
        local n = vim.fn.input("Issue number → ")
        if n ~= "" then Snacks.terminal("gh issue close " .. n) end
      end, desc = "Issue close" },

    -- Terminal
    { "<leader>x",   function() Snacks.terminal() end,                          desc = "Toggle terminal" },
    { "<leader>ld",  function() Snacks.terminal("lazydocker") end,              desc = "Lazydocker" },
    { "<leader>ob",  function() Snacks.terminal("overmind connect backend") end, desc = "Overmind backend" },

    -- Scratch
    { "<leader>.",   function() Snacks.scratch() end,                      desc = "Scratch buffer" },
    { "<leader>S",   function() Snacks.scratch.select() end,               desc = "Select scratch" },

    -- Misc
    { "<F8>",        function() Snacks.zen() end,                          desc = "Zen mode" },
    { "]]",          function() Snacks.words.jump(vim.v.count1) end,       desc = "Next reference" },
    { "[[",          function() Snacks.words.jump(-vim.v.count1) end,      desc = "Prev reference" },

    -- Picker
    { "<leader>b",   function() Snacks.picker.buffers({ layout = { preset = "vscode" } }) end,                        desc = "Buffers" },
    { "<leader>e",   function() Snacks.picker.explorer() end,                                                          desc = "Explorer" },
    { "<leader>fp",  function() Snacks.picker.git_files() end,                                                         desc = "Git files" },
    { "<leader>g",   function() Snacks.picker.git_status() end,                                                        desc = "Git status" },
    { "<leader>l",   function() Snacks.picker.lines() end,                                                             desc = "Buffer lines" },
    { "<leader>rb",  function() Snacks.picker.grep_buffers() end,                                                      desc = "Grep open buffers" },
    { "<leader>#",   function() Snacks.picker.grep_word() end,   mode = { "n", "x" },                                 desc = "Grep word / selection" },
    { "<leader>y",   function() Snacks.picker.registers({ layout = { preset = "vscode" } }) end,                      desc = "Registers" },
    { "<leader>sj",  function() Snacks.picker.jumps({ layout = { preset = "vscode" } }) end,                          desc = "Jumps" },
    { "<leader>p",   function() Snacks.picker.projects() end,                                                          desc = "Projects" },
    { "<leader>z",   function() Snacks.picker.zoxide() end,                                                            desc = "Zoxide" },
    { "<leader>ss",  function() Snacks.picker.lsp_symbols({ layout = { preset = "vscode", preview = "main" } }) end, desc = "LSP symbols" },
    { "<leader>sS",  function() Snacks.picker.lsp_workspace_symbols() end,                                             desc = "LSP workspace symbols" },

    -- GitHub picker
    { "<leader>gi",  function() Snacks.picker.gh_issue() end,                    desc = "GitHub issues (open)" },
    { "<leader>gI",  function() Snacks.picker.gh_issue({ state = "all" }) end,   desc = "GitHub issues (all)" },
    { "<leader>gp",  function() Snacks.picker.gh_pr() end,                       desc = "GitHub PRs (open)" },
    { "<leader>gP",  function() Snacks.picker.gh_pr({ state = "all" }) end,      desc = "GitHub PRs (all)" },

    -- LSP go-to (via picker)
    { "gd",  function() Snacks.picker.lsp_definitions() end,      desc = "Go to definition" },
    { "gD",  function() Snacks.picker.lsp_declarations() end,     desc = "Go to declaration" },
    { "gr",  function() Snacks.picker.lsp_references() end,       nowait = true, desc = "References" },
    { "gI",  function() Snacks.picker.lsp_implementations() end,  desc = "Go to implementation" },
    { "gy",  function() Snacks.picker.lsp_type_definitions() end, desc = "Go to type definition" },
  },

  -- ── Init (VeryLazy toggles) ───────────────────────────────
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern  = "VeryLazy",
      callback = function()
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle.option("background", {
          off  = "light",
          on   = "dark",
          name = "Dark Background",
        }):map("<leader>ub")
        Snacks.toggle.dim():map("<leader>uD")
        Snacks.toggle.zen():map("<leader>uZ")
        Snacks.toggle.scroll():map("<leader>uS")
        Snacks.toggle.indent():map("<leader>uI")
        Snacks.toggle.words():map("<leader>uW")
      end,
    })
  end,
}
