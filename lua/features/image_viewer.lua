--- Helpers for viewing image files inside Neovim.

local M = {}

local IMAGE_EXT = {
  png = true,
  jpg = true,
  jpeg = true,
  gif = true,
  webp = true,
  avif = true,
  bmp = true,
  svg = true,
  ico = true,
  tiff = true,
  tif = true,
}

function M.is_image(path)
  path = path or ""
  local ext = path:match("%.([^%.\\/]+)$")
  return ext ~= nil and IMAGE_EXT[ext:lower()] or false
end

function M.detect_backend()
  if os.getenv("KITTY_WINDOW_ID") then
    return "kitty"
  end
  if os.getenv("WEZTERM_EXECUTABLE") or os.getenv("TERM_PROGRAM") == "WezTerm" then
    return "kitty"
  end
  if os.getenv("GHOSTTY_RESOURCES_DIR") then
    return "kitty"
  end
  if vim.fn.executable("ueberzugpp") == 1 or vim.fn.executable("ueberzug") == 1 then
    return "ueberzug"
  end
  return "sixel"
end

function M.resolve_path(path)
  if not path or path == "" then
    return nil
  end
  path = path:gsub("^['\"]", ""):gsub("['\"]$", "")
  if path:match("^https?://") then
    return path
  end
  if path:match("^~") then
    path = vim.fn.expand(path)
  end
  if not path:match("^/") and not path:match("^%a:") then
    local rel = vim.fn.fnamemodify(path, ":p")
    if vim.fn.filereadable(rel) == 1 then
      return rel
    end
    local from_file = vim.fn.expand("%:p:h") .. "/" .. path
    if vim.fn.filereadable(from_file) == 1 then
      return from_file
    end
  end
  path = vim.fn.fnamemodify(path, ":p")
  if vim.fn.filereadable(path) == 1 then
    return path
  end
  return nil
end

function M.path_under_cursor()
  local cfile = vim.fn.expand("<cfile>")
  if M.is_image(cfile) then
    return M.resolve_path(cfile)
  end

  local line = vim.api.nvim_get_current_line()
  local patterns = {
    "![^%]]-%]%(%s*([^%)%s]+)%s*%)", -- markdown
    "src=[\"']([^\"']+)[\"']", -- html
    "image::([^%[]+)", -- asciidoc
  }
  for _, pat in ipairs(patterns) do
    local path = line:match(pat)
    if path and M.is_image(path) then
      return M.resolve_path(path)
    end
  end

  local word = vim.fn.expand("<cword>")
  if M.is_image(word) then
    return M.resolve_path(word)
  end

  return nil
end

function M.check_deps()
  local missing = {}
  if vim.fn.executable("magick") ~= 1 and vim.fn.executable("convert") ~= 1 then
    missing[#missing + 1] = "ImageMagick (brew install imagemagick)"
  end
  return missing
end

function M.preview(path, opts)
  opts = opts or {}
  path = M.resolve_path(path)
  if not path then
    vim.notify("No readable image path found", vim.log.levels.WARN)
    return
  end

  local missing = M.check_deps()
  if #missing > 0 then
    vim.notify("Missing: " .. table.concat(missing, ", "), vim.log.levels.ERROR)
    return
  end

  local api = require("image")
  if not api.is_enabled() then
    api.enable()
  end

  if path:match("^https?://") then
    api.from_url(path, {}, function(img)
      if not img then
        vim.notify("Failed to load image URL", vim.log.levels.ERROR)
        return
      end
      img:render()
    end)
    return
  end

  if opts.float then
    local ui = require("umbra.tokens")
    local width = math.floor(vim.o.columns * 0.78)
    local height = math.floor(vim.o.lines * 0.78)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local buf = vim.api.nvim_create_buf(false, true)
    local win = vim.api.nvim_open_win(buf, true, {
      relative = "editor",
      width = width,
      height = height,
      row = row,
      col = col,
      border = ui.border,
      style = "minimal",
      zindex = 100,
    })
    vim.api.nvim_buf_set_name(buf, "image-preview://" .. vim.fn.fnamemodify(path, ":t"))

    local img = api.from_file(path, {
      window = win,
      buffer = buf,
      with_virtual_padding = false,
      inline = false,
    })

    if not img then
      vim.api.nvim_win_close(win, true)
      vim.notify("Could not render image: " .. path, vim.log.levels.ERROR)
      return
    end

    img:render()

    local function close()
      pcall(function() img:clear() end)
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end

    vim.keymap.set("n", "q", close, { buffer = buf, nowait = true, desc = "Close image preview" })
    vim.keymap.set("n", "<esc>", close, { buffer = buf, nowait = true, desc = "Close image preview" })
    return
  end

  vim.cmd("edit " .. vim.fn.fnameescape(path))
end

function M.preview_cursor()
  M.preview(M.path_under_cursor(), { float = true })
end

function M.preview_file()
  local path = vim.fn.expand("%:p")
  if M.is_image(path) then
    M.preview(path, { float = true })
  else
    vim.notify("Current file is not an image", vim.log.levels.WARN)
  end
end

return M
