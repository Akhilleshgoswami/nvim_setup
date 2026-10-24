-- Cursor-style agent chat: right-docked transcript + rounded composer.
-- Drives `cursor-agent -p --output-format stream-json` instead of the CLI TUI.
-- Implements the cursoragent.nvim terminal-provider interface.

local tokens = require("umbra.tokens")
local window = require("umbra.window")
local icons = require("umbra.icons")

local M = {}

local NS = vim.api.nvim_create_namespace("umbra_cursoragent_chat")
local COMPOSER_H = 8
local MODES = { { id = "agent", label = "Agent" }, { id = "ask", label = "Ask" }, { id = "plan", label = "Plan" } }
-- Matches `cursor-agent models` — Auto is the CLI default.
local MODELS = {
  { id = "auto", label = "Auto" },
  { id = "composer-2.5", label = "Composer" },
  { id = "claude-sonnet-5-thinking-high", label = "Sonnet" },
  { id = "claude-opus-5-thinking-high", label = "Opus" },
  { id = "gpt-5.3-codex", label = "Codex" },
  { id = "cursor-grok-4.6-high-fast", label = "Grok" },
}

local state = {
  chat_buf = nil,
  chat_win = nil,
  composer_buf = nil,
  composer_win = nil,
  focused = false,
  cmd = nil,
  cwd = nil,
  env = nil,
  bin = nil,
  mode_i = 1,
  model_i = 1,
  busy = false,
  job = nil,
  session_id = nil,
  files = {},
  rest = "",
  stream_row = nil,
  stream_text = "",
  ns_placeholder = nil,
}

local function palette()
  local ok, active = pcall(require, "themes.active")
  return ok and active.palette() or nil
end

local function set_hl(group, spec)
  vim.api.nvim_set_hl(0, group, spec)
end

function M.apply_highlights()
  local pal = palette()
  if not pal then
    return
  end
  local bg = pal.bg.panel or pal.bg.float or pal.bg.base
  local composer_bg = pal.bg.overlay or pal.bg.elevated or pal.bg.float or bg
  local fg = pal.fg.base
  local muted = pal.fg.muted
  local faint = pal.fg.faint or muted
  local accent = pal.accent.ember or pal.accent.blue or fg
  local border = pal.border
  local tool = pal.accent.gold or pal.accent.yellow or accent
  set_hl("CursorAgentNormal", { fg = fg, bg = bg })
  set_hl("CursorAgentComposer", { fg = fg, bg = composer_bg })
  set_hl("CursorAgentBorder", { fg = state.focused and accent or border, bg = bg })
  set_hl("CursorAgentComposerBorder", { fg = state.focused and accent or pal.border_bright or border, bg = composer_bg })
  set_hl("CursorAgentTitle", { fg = accent, bg = bg, bold = true })
  set_hl("CursorAgentFooter", { fg = muted, bg = bg })
  set_hl("CursorAgentPlaceholder", { fg = faint, italic = true, bg = composer_bg })
  set_hl("CursorAgentMeta", { fg = faint, bg = bg })
  set_hl("CursorAgentTool", { fg = tool, bg = bg })
  set_hl("CursorAgentToolbar", { fg = muted, bg = composer_bg })
  set_hl("CursorAgentSend", { fg = pal.bg.base, bg = fg, bold = true })
end

local function geometry(cfg)
  local cols, lines = vim.o.columns, vim.o.lines
  local gap = tokens.space.sm
  local ratio = (cfg and cfg.split_width_percentage) or tokens.float.sm.width
  local width = math.max(tokens.panel.md, math.floor(cols * ratio))
  width = math.min(width, cols - gap * 2)
  local status = (vim.o.laststatus == 0) and 0 or 1
  local height = math.max(tokens.panel.sm, lines - gap * 2 - status - vim.o.cmdheight)
  local col = (cfg and cfg.split_side == "left") and gap or (cols - width - gap)
  return { width = width, height = height, row = gap, col = col }
end

local function mode()
  return MODES[state.mode_i]
end

local function model()
  return MODELS[state.model_i]
end

local function mcp_label()
  if state.busy then
    return icons.ui.dot .. " live"
  end
  local ok, agent = pcall(require, "cursoragent")
  if ok and agent.is_connected and agent.is_connected() then
    return icons.ui.dot .. " live"
  end
  return icons.ui.circle .. " idle"
end

local function file_chip()
  local n = 0
  for _ in pairs(state.files) do
    n = n + 1
  end
  if n == 0 then
    return nil
  end
  return " " .. n .. (n == 1 and " File " or " Files ")
end

local function valid(kind)
  local buf, win = state[kind .. "_buf"], state[kind .. "_win"]
  return buf and vim.api.nvim_buf_is_valid(buf) and win and vim.api.nvim_win_is_valid(win)
end

local function valid_buf(kind)
  local buf = state[kind .. "_buf"]
  return buf and vim.api.nvim_buf_is_valid(buf)
end

local function style_win(win, kind)
  local wo = vim.wo[win]
  wo.number = false
  wo.relativenumber = false
  wo.signcolumn = "no"
  wo.foldcolumn = "0"
  wo.statuscolumn = ""
  wo.cursorline = false
  wo.scrolloff = kind == "chat" and tokens.space.xs or 0
  wo.sidescrolloff = tokens.space.xs
  wo.winblend = tokens.opacity.float
  wo.wrap = true
  wo.linebreak = true
  wo.conceallevel = kind == "chat" and 2 or 0
  if kind == "chat" then
    wo.winbar = ""
    wo.winhighlight = table.concat({
      "Normal:CursorAgentNormal",
      "NormalNC:CursorAgentNormal",
      "FloatBorder:CursorAgentBorder",
      "FloatTitle:CursorAgentTitle",
      "FloatFooter:CursorAgentFooter",
      "EndOfBuffer:CursorAgentNormal",
    }, ",")
  else
    wo.winhighlight = table.concat({
      "Normal:CursorAgentComposer",
      "NormalNC:CursorAgentComposer",
      "FloatBorder:CursorAgentComposerBorder",
      "FloatTitle:CursorAgentToolbar",
      "WinBar:CursorAgentToolbar",
      "EndOfBuffer:CursorAgentComposer",
    }, ",")
  end
end

local function composer_winbar()
  local chev = icons.ui.fold_open
  return table.concat({
    "%#CursorAgentToolbar#  ",
    icons.ui.infinity,
    " ",
    mode().label,
    " ",
    chev,
    "   ",
    model().label,
    " ",
    chev,
    "%=",
    state.busy and (icons.ui.dot .. "  ") or "",
    icons.ui.paperclip,
    "   ",
    "%#CursorAgentSend# ",
    icons.ui.send,
    " %#CursorAgentToolbar#",
  })
end

local function chat_opts(cfg)
  local g = geometry(cfg)
  local chat_h = math.max(tokens.panel.sm, g.height - COMPOSER_H - 1)
  local title = window.title(icons.ui.agent .. "  " .. mode().label)
  local footer = " " .. mcp_label() .. "   hide <C-,>  ·  q "
  local opts = window.float({
    width = g.width,
    height = chat_h,
    row = g.row,
    col = g.col,
    zindex = tokens.zindex.panel,
    title = { { title, "CursorAgentTitle" } },
    footer = { { footer, "CursorAgentFooter" } },
    footer_pos = "right",
  })
  return opts, g, chat_h
end

local function composer_opts(cfg)
  local g = geometry(cfg)
  local chat_h = math.max(tokens.panel.sm, g.height - COMPOSER_H - 1)
  local chip = file_chip()
  local opts = window.float({
    width = g.width,
    height = COMPOSER_H,
    row = g.row + chat_h + 1,
    col = g.col,
    zindex = tokens.zindex.panel,
    title = chip and { { chip, "CursorAgentToolbar" } } or "",
    title_pos = "left",
  })
  return opts
end

local function hide()
  for _, kind in ipairs({ "chat", "composer" }) do
    local win = state[kind .. "_win"]
    if win and vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, false)
    end
    state[kind .. "_win"] = nil
  end
  state.focused = false
end

local function scroll_chat()
  if not valid("chat") then
    return
  end
  local last = vim.api.nvim_buf_line_count(state.chat_buf)
  pcall(vim.api.nvim_win_set_cursor, state.chat_win, { last, 0 })
end

local function with_chat_mod(fn)
  if not valid_buf("chat") then
    return
  end
  local buf = state.chat_buf
  vim.bo[buf].modifiable = true
  fn(buf)
  vim.bo[buf].modifiable = false
end

local function pad(text)
  local lines = {}
  for line in vim.gsplit(text or "", "\n", { plain = true }) do
    lines[#lines + 1] = "  " .. line
  end
  if #lines == 0 then
    lines[1] = "  "
  end
  return lines
end

local function append_lines(lines, hl_group)
  with_chat_mod(function(buf)
    local start = vim.api.nvim_buf_line_count(buf)
    if start == 1 and vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] == "" then
      start = 0
    end
    vim.api.nvim_buf_set_lines(buf, start, -1, false, lines)
    if hl_group then
      for i = start, start + #lines - 1 do
        vim.api.nvim_buf_add_highlight(buf, NS, hl_group, i, 0, -1)
      end
    end
  end)
  scroll_chat()
end

local function start_stream_block()
  with_chat_mod(function(buf)
    local count = vim.api.nvim_buf_line_count(buf)
    local empty = count == 1 and vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] == ""
    if not empty then
      vim.api.nvim_buf_set_lines(buf, count, count, false, { "" })
      count = count + 1
    end
    state.stream_row = empty and 0 or count
    state.stream_text = ""
    vim.api.nvim_buf_set_lines(buf, state.stream_row, state.stream_row, false, { "  " })
    vim.api.nvim_buf_set_extmark(buf, NS, state.stream_row, 0, {
      virt_text = { { "now", "CursorAgentMeta" } },
      virt_text_pos = "right_align",
    })
  end)
end

local function write_stream()
  if not state.stream_row then
    start_stream_block()
  end
  with_chat_mod(function(buf)
    local lines = pad(state.stream_text)
    vim.api.nvim_buf_set_lines(buf, state.stream_row, -1, false, lines)
  end)
  scroll_chat()
end

local function composer_text()
  if not valid_buf("composer") then
    return ""
  end
  local lines = vim.api.nvim_buf_get_lines(state.composer_buf, 0, -1, false)
  return vim.trim(table.concat(lines, "\n"))
end

local function set_placeholder()
  if not valid_buf("composer") then
    return
  end
  vim.api.nvim_buf_clear_namespace(state.composer_buf, NS, 0, -1)
  if composer_text() ~= "" then
    return
  end
  vim.api.nvim_buf_set_extmark(state.composer_buf, NS, 0, 0, {
    virt_text = { { "Plan, search, build anything", "CursorAgentPlaceholder" } },
    virt_text_pos = "overlay",
  })
end

local function refresh_chrome()
  if valid("chat") then
    local cfg = {
      split_side = vim.w[state.chat_win].cursoragent_side,
      split_width_percentage = vim.w[state.chat_win].cursoragent_width,
    }
    pcall(vim.api.nvim_win_set_config, state.chat_win, (chat_opts(cfg)))
    style_win(state.chat_win, "chat")
  end
  if valid("composer") then
    local cfg = {
      split_side = vim.w[state.chat_win] and vim.w[state.chat_win].cursoragent_side,
      split_width_percentage = vim.w[state.chat_win] and vim.w[state.chat_win].cursoragent_width,
    }
    pcall(vim.api.nvim_win_set_config, state.composer_win, composer_opts(cfg))
    style_win(state.composer_win, "composer")
    vim.wo[state.composer_win].winbar = composer_winbar()
  end
end

local function tool_label(tc)
  if type(tc) ~= "table" then
    return "tool"
  end
  if tc.readToolCall then
    return "Read " .. vim.fn.fnamemodify(tc.readToolCall.args and tc.readToolCall.args.path or "file", ":t")
  end
  if tc.writeToolCall then
    local path = tc.writeToolCall.args and tc.writeToolCall.args.path
    if path then
      state.files[path] = true
    end
    return "Edit " .. vim.fn.fnamemodify(path or "file", ":t")
  end
  if tc["function"] then
    return tc["function"].name or "tool"
  end
  local name = next(tc)
  return (name and name:gsub("ToolCall$", "")) or "tool"
end

local function handle_event(line)
  local ok, ev = pcall(vim.json.decode, line)
  if not ok or type(ev) ~= "table" then
    return
  end
  if ev.session_id then
    state.session_id = ev.session_id
  end
  if ev.type == "assistant" then
    -- Deltas have timestamp_ms and no model_call_id. Other assistant
    -- events are duplicate flushes (before a tool or at end of turn).
    local is_delta = ev.timestamp_ms ~= nil and ev.model_call_id == nil
    local is_full = ev.timestamp_ms == nil and ev.model_call_id == nil
    if ev.model_call_id or (is_full and state.stream_text ~= "") then
      return
    end
    local text = ""
    local content = ev.message and ev.message.content
    if type(content) == "table" then
      for _, part in ipairs(content) do
        if type(part) == "table" and part.text then
          text = text .. part.text
        end
      end
    end
    if text == "" then
      return
    end
    if is_delta then
      state.stream_text = state.stream_text .. text
    else
      state.stream_text = text
    end
    write_stream()
  elseif ev.type == "tool_call" and ev.subtype == "started" then
    state.stream_row = nil
    state.stream_text = ""
    append_lines({ "  " .. icons.ui.chevron_right .. " " .. tool_label(ev.tool_call) }, "CursorAgentTool")
  elseif ev.type == "result" then
    if (not state.stream_text or state.stream_text == "") and type(ev.result) == "string" and ev.result ~= "" then
      state.stream_text = ev.result
      write_stream()
    end
  end
end

local function consume_stdout(data)
  if not data then
    return
  end
  data[1] = state.rest .. (data[1] or "")
  state.rest = ""
  if data[#data] ~= "" then
    state.rest = data[#data]
    data[#data] = nil
  else
    data[#data] = nil
  end
  for _, line in ipairs(data) do
    if line ~= "" then
      handle_event(line)
    end
  end
end

local function finish_job(code, stderr)
  state.busy = false
  state.job = nil
  state.stream_row = nil
  if code ~= 0 and stderr and stderr ~= "" then
    append_lines(pad(vim.trim(stderr)), "CursorAgentMeta")
  end
  refresh_chrome()
end

local function send()
  if state.busy then
    return
  end
  local prompt = composer_text()
  if prompt == "" then
    return
  end
  vim.api.nvim_buf_set_lines(state.composer_buf, 0, -1, false, { "" })
  set_placeholder()

  append_lines({ "" })
  append_lines(pad(prompt), "CursorAgentMeta")

  local bin = state.bin or "cursor-agent"
  local argv = {
    bin,
    "-p",
    "--output-format",
    "stream-json",
    "--stream-partial-output",
    "--trust",
  }
  if mode().id == "ask" or mode().id == "plan" then
    argv[#argv + 1] = "--mode=" .. mode().id
  else
    -- Agent mode: auto-approve tools (same as Cursor Auto agent).
    argv[#argv + 1] = "--force"
    argv[#argv + 1] = "--auto-review"
  end
  argv[#argv + 1] = "--model"
  argv[#argv + 1] = model().id
  if state.session_id then
    argv[#argv + 1] = "--resume"
    argv[#argv + 1] = state.session_id
  end
  argv[#argv + 1] = prompt

  state.busy = true
  state.rest = ""
  state.stream_text = ""
  state.stream_row = nil
  refresh_chrome()
  start_stream_block()

  local stderr = {}
  state.job = vim.fn.jobstart(argv, {
    cwd = state.cwd or vim.fn.getcwd(),
    env = vim.tbl_extend("force", vim.fn.environ(), state.env or {}),
    stdout_buffered = false,
    stderr_buffered = false,
    on_stdout = function(_, data)
      vim.schedule(function()
        consume_stdout(data)
      end)
    end,
    on_stderr = function(_, data)
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then
            stderr[#stderr + 1] = line
          end
        end
      end
    end,
    on_exit = function(_, code)
      vim.schedule(function()
        finish_job(code, table.concat(stderr, "\n"))
      end)
    end,
  })
  if not state.job or state.job <= 0 then
    finish_job(1, "Failed to start Cursor Agent CLI")
  end
end

local function cycle_mode()
  state.mode_i = (state.mode_i % #MODES) + 1
  refresh_chrome()
end

local function cycle_model()
  state.model_i = (state.model_i % #MODELS) + 1
  refresh_chrome()
end

local function bind_keys()
  local chat, composer = state.chat_buf, state.composer_buf
  local hide_opts = { silent = true, nowait = true, desc = "Hide Cursor Agent" }
  for _, buf in ipairs({ chat, composer }) do
    vim.keymap.set("n", "q", hide, vim.tbl_extend("force", hide_opts, { buffer = buf }))
    vim.keymap.set("n", "<Esc>", hide, vim.tbl_extend("force", hide_opts, { buffer = buf }))
  end
  local c = { buffer = composer, silent = true }
  vim.keymap.set("i", "<CR>", function()
    send()
  end, vim.tbl_extend("force", c, { desc = "Send" }))
  vim.keymap.set("i", "<C-j>", "<CR>", vim.tbl_extend("force", c, { desc = "Composer newline" }))
  vim.keymap.set({ "n", "i" }, "<Tab>", function()
    cycle_mode()
  end, vim.tbl_extend("force", c, { desc = "Cycle agent mode" }))
  vim.keymap.set({ "n", "i" }, "<C-e>", function()
    cycle_model()
  end, vim.tbl_extend("force", c, { desc = "Cycle model" }))
  vim.keymap.set("n", "<CR>", send, vim.tbl_extend("force", c, { desc = "Send" }))
  vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    buffer = composer,
    callback = set_placeholder,
  })
end

local function ensure_bufs()
  if not valid_buf("chat") then
    state.chat_buf = vim.api.nvim_create_buf(false, true)
    vim.bo[state.chat_buf].bufhidden = "hide"
    vim.bo[state.chat_buf].buflisted = false
    vim.bo[state.chat_buf].filetype = "cursoragent_chat"
    vim.bo[state.chat_buf].modifiable = false
  end
  if not valid_buf("composer") then
    state.composer_buf = vim.api.nvim_create_buf(false, true)
    vim.bo[state.composer_buf].bufhidden = "hide"
    vim.bo[state.composer_buf].buflisted = false
    vim.bo[state.composer_buf].filetype = "cursoragent_composer"
    bind_keys()
  end
end

local function on_win_events()
  local group = vim.api.nvim_create_augroup("umbra_cursoragent_win", { clear = true })
  vim.api.nvim_create_autocmd({ "WinEnter", "WinLeave" }, {
    group = group,
    callback = function()
      local cur = vim.api.nvim_get_current_win()
      state.focused = cur == state.chat_win or cur == state.composer_win
      M.apply_highlights()
    end,
  })
end

local function show_windows(cfg, focus)
  ensure_bufs()
  M.apply_highlights()
  local chat_o, _g = chat_opts(cfg)
  if valid("chat") then
    pcall(vim.api.nvim_win_set_config, state.chat_win, chat_o)
  else
    state.chat_win = vim.api.nvim_open_win(state.chat_buf, false, chat_o)
  end
  vim.w[state.chat_win].cursoragent_side = cfg and cfg.split_side or "right"
  vim.w[state.chat_win].cursoragent_width = cfg and cfg.split_width_percentage
  style_win(state.chat_win, "chat")

  local comp_o = composer_opts(cfg)
  if valid("composer") then
    pcall(vim.api.nvim_win_set_config, state.composer_win, comp_o)
  else
    state.composer_win = vim.api.nvim_open_win(state.composer_buf, focus ~= false, comp_o)
  end
  style_win(state.composer_win, "composer")
  vim.wo[state.composer_win].winbar = composer_winbar()
  set_placeholder()
  on_win_events()
  state.focused = focus ~= false
  if focus ~= false then
    vim.api.nvim_set_current_win(state.composer_win)
    vim.cmd("startinsert")
  end
end

local function parse_cmd(cmd)
  cmd = cmd or ""
  local parts = vim.split(cmd, " ", { trimempty = true })
  state.bin = parts[1]
  if cmd:find("--mode=ask", 1, true) then
    state.mode_i = 2
  elseif cmd:find("--mode=plan", 1, true) then
    state.mode_i = 3
  else
    state.mode_i = 1
  end
end

local function visible()
  return valid("chat") or valid("composer")
end

function M.setup(_cfg)
  M.apply_highlights()
  local group = vim.api.nvim_create_augroup("umbra_cursoragent_ui", { clear = true })
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = function()
      M.apply_highlights()
      if visible() then
        refresh_chrome()
      end
    end,
  })
  vim.api.nvim_create_autocmd("VimResized", {
    group = group,
    callback = function()
      if visible() then
        refresh_chrome()
      end
    end,
  })
end

function M.open(cmd, env, cfg, focus)
  state.cmd = cmd
  state.env = env
  state.cwd = cfg and cfg.cwd
  parse_cmd(cmd)
  if visible() then
    refresh_chrome()
    if focus ~= false and valid("composer") then
      vim.api.nvim_set_current_win(state.composer_win)
      vim.cmd("startinsert")
    end
    return true
  end
  show_windows(cfg, focus)
  return true
end

function M.close()
  hide()
end

function M.simple_toggle(cmd, env, cfg)
  if visible() then
    hide()
    return
  end
  M.open(cmd, env, cfg, true)
end

function M.focus_toggle(cmd, env, cfg)
  if visible() then
    if vim.api.nvim_get_current_win() == state.composer_win or vim.api.nvim_get_current_win() == state.chat_win then
      hide()
    elseif valid("composer") then
      vim.api.nvim_set_current_win(state.composer_win)
      vim.cmd("startinsert")
    end
    return
  end
  M.open(cmd, env, cfg, true)
end

function M.ensure_visible()
  if valid_buf("chat") then
    show_windows({ split_side = "right" }, false)
  end
end

function M.get_active_bufnr()
  if valid_buf("composer") then
    return state.composer_buf
  end
  return nil
end

function M.is_available()
  return true
end

return M
