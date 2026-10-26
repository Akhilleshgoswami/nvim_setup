-- WezTerm integration.
--
-- 1. Launchers — open WezTerm windows / tabs / splits from Neovim, inheriting
--    the project root or the current file's directory. When Neovim is already
--    running inside WezTerm we drive the running instance via `wezterm cli`
--    (new tab/pane, no second process); otherwise we start a fresh GUI window.
--
-- 2. Theme sync — write ~/.config/wezterm/colors/nvim-sync.lua from the *live*
--    colors of whatever theme is active, so WezTerm matches Neovim exactly
--    (works for every theme, not just named ones). WezTerm watches that file
--    and reloads instantly, so `:Theme` restyles the terminal too.

local M = {}

-- ── Binary discovery (macOS-aware) ───────────────────────────────
local function bin()
  local exe = os.getenv("WEZTERM_EXECUTABLE")
  if exe and exe ~= "" and vim.fn.executable(exe) == 1 then
    return exe
  end
  if vim.fn.executable("wezterm") == 1 then
    return "wezterm"
  end
  local mac = "/Applications/WezTerm.app/Contents/MacOS/wezterm"
  if vim.fn.executable(mac) == 1 then
    return mac
  end
  return nil
end

-- We can talk to a running mux (reuse the instance) when spawned from WezTerm.
local function has_mux()
  return (os.getenv("WEZTERM_UNIX_SOCKET") or "") ~= ""
end

-- ── Directory resolution ─────────────────────────────────────────
local function project_root()
  local ok, root = pcall(function()
    return require("utils").root()
  end)
  return (ok and root) or (vim.uv or vim.loop).cwd()
end

local function file_dir()
  local name = vim.api.nvim_buf_get_name(0)
  if name == "" or name:match("^%w+://") then
    return project_root()
  end
  return vim.fs.dirname(name)
end

-- mode: "tab" | "window" | "vsplit" | "hsplit"
function M.open(mode, cwd)
  local exe = bin()
  if not exe then
    vim.notify("WezTerm not found. Install it or add it to PATH.", vim.log.levels.WARN, { title = "WezTerm" })
    return
  end
  cwd = cwd or project_root()

  local cmd
  if has_mux() then
    if mode == "window" then
      cmd = { exe, "cli", "spawn", "--new-window", "--cwd", cwd }
    elseif mode == "vsplit" then
      cmd = { exe, "cli", "split-pane", "--right", "--cwd", cwd }
    elseif mode == "hsplit" then
      cmd = { exe, "cli", "split-pane", "--bottom", "--cwd", cwd }
    else
      cmd = { exe, "cli", "spawn", "--cwd", cwd }
    end
  else
    -- No mux to reach: start a fresh GUI window in the requested directory.
    cmd = { exe, "start", "--cwd", cwd }
  end

  vim.fn.jobstart(cmd, { detach = true })
end

function M.window_root() M.open("window", project_root()) end
function M.tab_root() M.open("tab", project_root()) end
function M.tab_file_dir() M.open("tab", file_dir()) end
function M.vsplit_file_dir() M.open("vsplit", file_dir()) end
function M.hsplit_file_dir() M.open("hsplit", file_dir()) end

-- ── Theme sync ───────────────────────────────────────────────────
local function config_dir()
  local xdg = vim.env.XDG_CONFIG_HOME
  local base = (xdg and xdg ~= "") and xdg or ((vim.env.HOME or "") .. "/.config")
  return base .. "/wezterm"
end

-- Read a highlight attribute as hex — the shared implementation.
local get = require("umbra.hl").get

-- Prefer Neovim's terminal palette; fall back to a sensible ANSI slot.
local function term_color(i, fallback)
  local v = vim.g["terminal_color_" .. i]
  return (type(v) == "string" and v ~= "") and v or fallback
end

-- Snapshot the active theme into the shape wezterm/colors/nvim-sync.lua expects.
local THEME_BACKGROUNDS = {
  kiln = "#1c1814",
  meridian = "#1b1e23",
  solder = "#1a1815",
  loam = "#242019",
  umbra = "#1A1E27",
  gruvbox = "#282828",
  catppuccin = "#1e1e2e",
  ["catppuccin-mocha"] = "#1e1e2e",
  ["catppuccin-macchiato"] = "#24273a",
  ["catppuccin-frappe"] = "#303446",
  ["catppuccin-latte"] = "#eff1f5",
  tokyonight = "#1a1b26",
  ["tokyonight-night"] = "#1a1b26",
  ["tokyonight-storm"] = "#24283b",
  ["tokyonight-moon"] = "#222436",
  ["tokyonight-day"] = "#e1e2e7",
  kanagawa = "#1f1f28",
  ["kanagawa-wave"] = "#1f1f28",
  ["kanagawa-dragon"] = "#181616",
  ["kanagawa-lotus"] = "#f2ecbc",
  ["rose-pine"] = "#191724",
  ["rose-pine-main"] = "#191724",
  ["rose-pine-moon"] = "#232136",
  ["rose-pine-dawn"] = "#faf4ed",
  everforest = "#2d353b",
  onedark = "#282c34",
  onelight = "#fafafa",
  nightfox = "#192330",
  nordfox = "#2e3440",
  duskfox = "#232136",
  terafox = "#152528",
  carbonfox = "#161616",
  nord = "#2e3440",
  oxocarbon = "#161616",
  luna = "#0f141c",
  ["jetbrains-dark"] = "#191a1c",
  ["jetbrains-light"] = "#ffffff",
  ["jetbrains-white"] = "#ffffff",
  ["jb-dark"] = "#191a1c",
  ["jb-light"] = "#ffffff",
  jb = "#191a1c",
}

local function get_theme_bg(name)
  local bg = get("Normal", "bg")
  if bg and bg ~= "" and bg:lower() ~= "none" then
    return bg
  end
  local lname = (name or ""):lower()
  if THEME_BACKGROUNDS[lname] then
    return THEME_BACKGROUNDS[lname]
  end
  for prefix, color in pairs(THEME_BACKGROUNDS) do
    if lname:find("^" .. prefix) then
      return color
    end
  end
  local ok, active = pcall(function() return require("themes.active").palette() end)
  if ok and active and active.bg and active.bg.base then
    return active.bg.base
  end
  return get("NormalFloat", "bg") or get("Pmenu", "bg") or "#101216"
end

local function snapshot()
  local name = vim.g.colors_name or "umbra"
  local fg = get("Normal", "fg") or "#c6cad4"
  local bg = get_theme_bg(name)

  local ansi_fallback = { "#191c23", "#eb6f82", "#9bd09e", "#e6c58c", "#7fa7f0", "#b39df3", "#5fd1be", "#c6cad4" }
  local bright_fallback = { "#565d6d", "#ef8496", "#aad9ac", "#edcf9e", "#96b8f4", "#c3b0f6", "#7cd9c9", "#e4e7ee" }

  local ansi, brights = {}, {}
  for i = 0, 7 do
    ansi[i + 1] = term_color(i, ansi_fallback[i + 1])
  end
  for i = 8, 15 do
    brights[i - 7] = term_color(i, bright_fallback[i - 7])
  end

  local tab_active_bg = get("CursorLine", "bg") or get("StatusLine", "bg") or bg
  local accent_fg = get("Function", "fg") or "#7fa7f0"

  return {
    theme = vim.g.colors_name or "umbra",
    colors = {
      foreground = fg,
      background = bg,
      cursor_bg = get("Cursor", "bg") or accent_fg,
      cursor_fg = get("Cursor", "fg") or bg,
      cursor_border = get("Cursor", "bg") or accent_fg,
      selection_bg = get("Visual", "bg") or "#293040",
      selection_fg = get("Visual", "fg") or fg,
      split = get("WinSeparator", "fg") or tab_active_bg,
      ansi = ansi,
      brights = brights,
    },
    ui = {
      tab_bg = get("StatusLine", "bg") or bg,
      tab_active_bg = tab_active_bg,
      tab_active_fg = fg,
      tab_inactive_fg = get("Comment", "fg") or "#6b7280",
      tab_hover_bg = get("PmenuSel", "bg") or tab_active_bg,
      accent = accent_fg,
      status_fg = accent_fg,
    },
  }
end

-- Serialize a flat/simple table to a Lua literal (strings + string arrays).
local function serialize(tbl, indent)
  indent = indent or "  "
  local parts = {}
  for _, key in ipairs({ "theme" }) do
    if tbl[key] then
      parts[#parts + 1] = string.format('%s%s = %q,', indent, key, tbl[key])
    end
  end
  for _, section in ipairs({ "colors", "ui" }) do
    local t = tbl[section]
    if t then
      parts[#parts + 1] = string.format("%s%s = {", indent, section)
      for k, v in pairs(t) do
        if type(v) == "table" then
          local items = {}
          for _, item in ipairs(v) do
            items[#items + 1] = string.format("%q", item)
          end
          parts[#parts + 1] = string.format("%s  %s = { %s },", indent, k, table.concat(items, ", "))
        else
          parts[#parts + 1] = string.format("%s  %s = %q,", indent, k, v)
        end
      end
      parts[#parts + 1] = string.format("%s},", indent)
    end
  end
  return "return {\n" .. table.concat(parts, "\n") .. "\n}\n"
end

-- Write the sync file now (no-op if WezTerm isn't configured on this machine).
function M.sync_theme()
  local dir = config_dir()
  if vim.fn.isdirectory(dir) == 0 then
    return
  end
  local colors_dir = dir .. "/colors"
  vim.fn.mkdir(colors_dir, "p")
  local snap = snapshot()
  local body = "-- Auto-generated by Neovim (features/wezterm.lua). Do not edit.\n"
    .. serialize(snap)
  local f = io.open(colors_dir .. "/nvim-sync.lua", "w")
  if f then
    f:write(body)
    f:close()
  end

  -- Touch ~/.config/wezterm/wezterm.lua so WezTerm reloads immediately
  local main_config = dir .. "/wezterm.lua"
  local f_touch = io.open(main_config, "a")
  if f_touch then
    f_touch:close()
  end
  pcall(function()
    (vim.uv or vim.loop).fs_utime(main_config, os.time(), os.time(), function() end)
  end)

  -- Send instant OSC escape sequences to active terminal
  pcall(function()
    local bg = snap.colors.background
    local fg = snap.colors.foreground
    local cur = snap.colors.cursor_bg
    if bg and bg ~= "" then
      io.stdout:write(string.format("\027]11;%s\007", bg))
    end
    if fg and fg ~= "" then
      io.stdout:write(string.format("\027]10;%s\007", fg))
    end
    if cur and cur ~= "" then
      io.stdout:write(string.format("\027]12;%s\007", cur))
    end
    io.stdout:flush()
  end)
end

-- Debounced variant: theme previews (Telescope) fire ColorScheme rapidly, so
-- we coalesce writes to avoid thrashing the file / WezTerm reloads.
local timer
function M.sync_theme_debounced()
  if timer then
    timer:stop()
    if not timer:is_closing() then
      timer:close()
    end
  end
  timer = (vim.uv or vim.loop).new_timer()
  timer:start(160, 0, vim.schedule_wrap(function()
    M.sync_theme()
    if timer then
      timer:stop()
      if not timer:is_closing() then
        timer:close()
      end
      timer = nil
    end
  end))
end

return M
