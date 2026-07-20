-- Performance & health report — a quick, at-a-glance snapshot of what's
-- loaded and how the editor is doing. Opened with :UmbraHealth (<leader>uh).
-- For a full per-plugin flamegraph use :Lazy profile (<leader>up).

local window = require("umbra.window")

local M = {}

local function open_float(lines, title)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].filetype = "umbra-health"
  vim.bo[buf].bufhidden = "wipe"

  local width = 40
  for _, l in ipairs(lines) do
    width = math.max(width, vim.fn.strdisplaywidth(l))
  end
  width = math.min(width + 4, vim.o.columns - 8)
  local height = math.min(#lines, vim.o.lines - 6)

  -- One float factory owns border, title alignment, opacity and close keys.
  window.open(buf, {
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2 - 1),
    col = math.floor((vim.o.columns - width) / 2),
    title = window.title(title or "Umbra Health"),
  })
  return buf
end

local function section(lines, title)
  lines[#lines + 1] = ""
  lines[#lines + 1] = "  " .. title
end

local function row(lines, label, value)
  lines[#lines + 1] = ("    %-18s %s"):format(label, value)
end

function M.report()
  local lines = { "" }

  -- ── Startup ──
  section(lines, "󱐋 Startup")
  local ok_lazy, lazy = pcall(require, "lazy")
  if ok_lazy then
    local stats = lazy.stats()
    row(lines, "startup", ("%.1f ms"):format(stats.startuptime or 0))
    row(lines, "plugins", ("%d total · %d loaded"):format(stats.count, stats.loaded))
  end
  row(lines, "lua memory", ("%.1f MB"):format(collectgarbage("count") / 1024))

  -- ── Slowest loaded plugins (best-effort) ──
  if ok_lazy then
    local timed = {}
    for _, p in ipairs(lazy.plugins()) do
      local t = p._ and p._.loaded and p._.loaded.time
      if type(t) == "number" and t > 0 then
        timed[#timed + 1] = { name = p.name, ms = t / 1e6 }
      end
    end
    table.sort(timed, function(a, b) return a.ms > b.ms end)
    if #timed > 0 then
      section(lines, " Slowest plugins (:Lazy profile for detail)")
      for i = 1, math.min(6, #timed) do
        row(lines, timed[i].name, ("%.1f ms"):format(timed[i].ms))
      end
    end
  end

  -- ── LSP ──
  section(lines, " LSP")
  local clients = vim.lsp.get_clients()
  if #clients == 0 then
    row(lines, "clients", "none active")
  else
    local names = {}
    for _, c in ipairs(clients) do
      names[#names + 1] = c.name
    end
    table.sort(names)
    row(lines, "active", table.concat(names, ", "))
  end

  -- ── Treesitter ──
  section(lines, " Treesitter")
  local parsers = vim.api.nvim_get_runtime_file("parser/*.so", true)
  row(lines, "parsers", tostring(#parsers) .. " installed")
  local ok_ts = pcall(vim.treesitter.get_parser, 0)
  row(lines, "current buffer", ok_ts and "active" or "no parser")

  -- ── Formatter ──
  section(lines, "󰉼 Formatter (conform)")
  local ok_conform, conform = pcall(require, "conform")
  if ok_conform then
    local fmts = conform.list_formatters(0)
    local names = {}
    for _, f in ipairs(fmts) do
      names[#names + 1] = f.name .. (f.available and "" or " (missing)")
    end
    row(lines, "for this buffer", #names > 0 and table.concat(names, ", ") or "none")
    row(lines, "format on save", (vim.g.autoformat ~= false) and "on" or "off")
  end

  -- ── Git ──
  section(lines, " Git")
  local branch = vim.fn.systemlist("git rev-parse --abbrev-ref HEAD 2>/dev/null")[1]
  if branch and vim.v.shell_error == 0 then
    row(lines, "branch", branch)
    local dirty = vim.fn.systemlist("git status --porcelain 2>/dev/null")
    row(lines, "working tree", (#dirty == 0) and "clean" or (#dirty .. " changed"))
  else
    row(lines, "repo", "not a git repository")
  end

  -- ── DAP ──
  if package.loaded["dap"] then
    section(lines, " Debug")
    local session = require("dap").session()
    row(lines, "session", session and "active" or "idle")
  end

  lines[#lines + 1] = ""
  lines[#lines + 1] = "    press q or <esc> to close"
  lines[#lines + 1] = ""
  return lines
end

function M.show()
  open_float(M.report(), "Umbra Health")
end

return M
