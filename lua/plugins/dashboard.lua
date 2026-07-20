-- A minimal, information-rich start screen. No ASCII murals — just the context
-- an engineer wants at a glance: project, branch, working-tree state, recent
-- files, plugin health, startup time, and one quiet line to think on.

local icons = require("umbra.icons")
local ui = require("umbra.tokens")

return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

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

    -- Branch + working-tree state in a single git call (kept off the hot path:
    -- the dashboard only renders when Neovim opens with no file arguments).
    local function git_info()
      local out = vim.fn.systemlist("git status --porcelain=v1 --branch 2>/dev/null")
      if vim.v.shell_error ~= 0 or not out[1] then
        return nil, 0
      end
      local branch = out[1]:match("^## ([^%.%s]+)") or out[1]:match("^## (%S+)")
      return branch, math.max(0, #out - 1)
    end

    -- ── Project context line: name · branch · clean/N changed ──
    local function context()
      local cwd = vim.fn.fnamemodify(vim.uv.cwd() or "", ":t")
      local parts = { cwd }
      local branch, changes = git_info()
      if branch then
        parts[#parts + 1] = icons.git.branch .. " " .. branch
        parts[#parts + 1] = changes == 0 and (icons.ui.dot .. " clean")
          or (icons.git.modified .. " " .. changes .. " changed")
      end
      return "  " .. table.concat(parts, "     ")
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
          local btn = dashboard.button(tostring(count), "  " .. (ico or "") .. "  " .. short, function()
            require("features.intelligence").preload()
            vim.cmd("edit " .. vim.fn.fnameescape(file))
          end)
          btn.opts.hl = { { "AlphaButtonIcon", 0, 6 } }
          btn.opts.hl_shortcut = "AlphaShortcut"
          buttons[#buttons + 1] = btn
        end
      end
      return buttons
    end

    -- ── Actions ──
    dashboard.section.buttons.val = {
      dashboard.button("f", "󰈞  Find file", function() require("telescope.builtin").find_files({ hidden = true }) end),
      dashboard.button("g", "󰊄  Live grep", function() require("telescope.builtin").live_grep() end),
      dashboard.button("r", "󰋚  Recent files", function() require("telescope.builtin").oldfiles() end),
      dashboard.button("p", "󰉋  Projects", function()
        pcall(require("telescope").extensions.projects.projects, {})
      end),
      dashboard.button("s", "󰦛  Restore session", "<cmd>SessionRestore<cr>"),
      dashboard.button("n", "󰎔  New file", "<cmd>ene | startinsert<cr>"),
      dashboard.button("c", "  Config", function()
        require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config"), hidden = true })
      end),
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

    -- Token-driven vertical rhythm — no arbitrary padding.
    dashboard.config.layout = {
      { type = "padding", val = ui.space.sm },
      dashboard.section.header,
      { type = "padding", val = ui.space.xs },
      context_section,
      { type = "padding", val = ui.space.sm },
      dashboard.section.buttons,
      { type = "padding", val = ui.space.xs },
      recent_header,
      { type = "padding", val = ui.space.xs },
      { type = "group", val = recent_buttons, opts = {} },
      { type = "padding", val = ui.space.sm },
      dashboard.section.footer,
    }

    dashboard.section.footer.opts.hl = "AlphaFooter"

    alpha.setup(dashboard.config)

    -- Footer carries live status: plugins, load, startup ms, pending updates,
    -- and (resolved asynchronously so it never delays startup) the repo's TODO
    -- count, closing with the quote of the day.
    vim.api.nvim_create_autocmd("UIEnter", {
      once = true,
      callback = function()
        vim.schedule(function()
          local ok, lazy = pcall(require, "lazy")
          if not ok then
            return
          end
          local stats = lazy.stats()
          local ms = math.floor((stats.startuptime or 0) * 100 + 0.5) / 100
          local updates = 0
          pcall(function()
            updates = tonumber(require("lazy.status").updates()) or 0
          end)
          local quote = quotes[(tonumber(os.date("%j")) % #quotes) + 1]

          local dot = icons.ui.dot
          local function render(todos)
            local line = ("%s %d plugins    %s %d loaded    %s %sms"):format(dot, stats.count, dot, stats.loaded, dot, ms)
            if updates > 0 then
              line = line .. ("    %s %d updates"):format(icons.git.branch, updates)
            end
            if todos and todos > 0 then
              line = line .. ("    %s %d TODO"):format(icons.ui.bookmark, todos)
            end
            dashboard.section.footer.val = { "", line, "", "\u{201c}" .. quote .. "\u{201d}" }
            pcall(vim.cmd.AlphaRedraw)
          end
          render(nil)

          if vim.fn.executable("rg") == 1 and vim.uv.cwd() then
            vim.system(
              { "rg", "--no-messages", "--count-matches", "-e", "TODO", "-e", "FIXME", "-e", "HACK", vim.uv.cwd() },
              { text = true },
              function(res)
                local n = 0
                for num in (res.stdout or ""):gmatch(":(%d+)") do
                  n = n + (tonumber(num) or 0)
                end
                vim.schedule(function()
                  render(n)
                end)
              end
            )
          end
        end)
      end,
    })
  end,
}
