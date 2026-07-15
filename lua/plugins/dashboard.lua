-- A minimal, information-rich start screen. No ASCII murals — just the
-- context an engineer wants: project, branch, recent files, startup time.

return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")
    local icons = require("utils.icons")

    local quotes = {
      "Simplicity is the soul of efficiency.",
      "Make it work, make it right, make it fast.",
      "Programs must be written for people to read.",
      "The best code is no code at all.",
      "Talk is cheap. Show me the code.",
      "First, solve the problem. Then, write the code.",
      "Deleted code is debugged code.",
      "Weeks of coding can save you hours of planning.",
      "Perfection is achieved when there is nothing left to take away.",
    }

    -- ── Header: a restrained wordmark ──
    dashboard.section.header.val = {
      "",
      "        ▟▙   U M B R A",
      "       ▝▀▘   a handcrafted neovim environment",
      "",
    }
    dashboard.section.header.opts.hl = "AlphaHeader"

    -- ── Project context line ──
    local function context()
      local cwd = vim.fn.fnamemodify(vim.uv.cwd() or "", ":t")
      local branch = ""
      local out = vim.fn.systemlist("git rev-parse --abbrev-ref HEAD 2>/dev/null")
      if vim.v.shell_error == 0 and out[1] then
        branch = "   " .. icons.git.branch .. " " .. out[1]
      end
      return "  " .. cwd .. branch
    end

    -- ── Recent files (cwd-scoped, existing only) ──
    local function recent_buttons()
      local buttons = {}
      local cwd = (vim.uv.cwd() or "") .. "/"
      local seen, count = {}, 0
      for _, file in ipairs(vim.v.oldfiles or {}) do
        if count >= 5 then break end
        if file:find(cwd, 1, true) == 1 and vim.uv.fs_stat(file) and not seen[file] then
          seen[file] = true
          count = count + 1
          local short = file:sub(#cwd + 1)
          local ico = require("nvim-web-devicons").get_icon(file, vim.fn.fnamemodify(file, ":e"), { default = true })
          local btn = dashboard.button(tostring(count), "  " .. (ico or "") .. "  " .. short, "<cmd>e " .. file .. "<cr>")
          btn.opts.hl = { { "AlphaButtonIcon", 0, 6 } }
          btn.opts.hl_shortcut = "AlphaShortcut"
          buttons[#buttons + 1] = btn
        end
      end
      return buttons
    end

    -- ── Actions ──
    dashboard.section.buttons.val = {
      dashboard.button("f", "󰈞  Find file", "<cmd>Telescope find_files<cr>"),
      dashboard.button("g", "󰊄  Live grep", "<cmd>Telescope live_grep<cr>"),
      dashboard.button("r", "󰋚  Recent files", "<cmd>Telescope oldfiles<cr>"),
      dashboard.button("p", "󰉋  Projects", "<cmd>Telescope projects<cr>"),
      dashboard.button("s", "󰦛  Restore session", "<cmd>SessionRestore<cr>"),
      dashboard.button("n", "󰎔  New file", "<cmd>ene | startinsert<cr>"),
      dashboard.button("c", "  Config", "<cmd>lua require('telescope.builtin').find_files({cwd=vim.fn.stdpath('config')})<cr>"),
      dashboard.button("l", "󰒲  Plugins", "<cmd>Lazy<cr>"),
      dashboard.button("q", "󰩈  Quit", "<cmd>qa<cr>"),
    }
    for _, button in ipairs(dashboard.section.buttons.val) do
      button.opts.hl = "AlphaButtons"
      button.opts.hl_shortcut = "AlphaShortcut"
    end

    local context_section = {
      type = "text",
      val = context,
      opts = { position = "center", hl = "AlphaProject" },
    }
    local recent_header = {
      type = "text",
      val = "recent",
      opts = { position = "center", hl = "AlphaHeaderLabel" },
    }

    dashboard.config.layout = {
      { type = "padding", val = 2 },
      dashboard.section.header,
      { type = "padding", val = 1 },
      context_section,
      { type = "padding", val = 2 },
      dashboard.section.buttons,
      { type = "padding", val = 1 },
      recent_header,
      { type = "padding", val = 1 },
      { type = "group", val = recent_buttons, opts = {} },
      { type = "padding", val = 2 },
      dashboard.section.footer,
    }

    dashboard.section.footer.opts.hl = "AlphaFooter"

    alpha.setup(dashboard.config)

    -- Footer with real startup metrics once the UI is ready.
    vim.api.nvim_create_autocmd("UIEnter", {
      once = true,
      callback = function()
        vim.schedule(function()
          local ok, lazy = pcall(require, "lazy")
          if not ok then return end
          local stats = lazy.stats()
          local ms = math.floor((stats.startuptime or 0) * 100 + 0.5) / 100
          local quote = quotes[(tonumber(os.date("%j")) % #quotes) + 1]
          dashboard.section.footer.val = {
            "",
            ("󰒲  %d plugins   󱐋  %d loaded   %sms"):format(stats.count, stats.loaded, ms),
            "",
            "“" .. quote .. "”",
          }
          pcall(vim.cmd.AlphaRedraw)
        end)
      end,
    })
  end,
}
