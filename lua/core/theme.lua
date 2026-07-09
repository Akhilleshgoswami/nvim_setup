local M = {}

-- NvChad base46 themes (via nvchad.themes)
local base46_themes = {
  "onedark",
  "catppuccin",
  "gruvbox",
  "rosepine",
  "nord",
  "chadracula",
  "bearded-arc",
  "decay",
  "doom-chad",
}

-- Authentic external colorschemes (not base46 approximations)
local external_themes = {
  tokyonight = function()
    require("tokyonight").load({ style = "night" })
  end,
}

local function refresh_nvchad_ui()
  vim.schedule(function()
    pcall(function()
      dofile(vim.g.base46_cache .. "statusline")
    end)
    pcall(function()
      dofile(vim.g.base46_cache .. "tabufline")
    end)
    pcall(function()
      dofile(vim.g.base46_cache .. "devicons")
    end)
  end)
end

function M.apply(theme)
  if not theme then
    return
  end

  if external_themes[theme] then
    external_themes[theme]()
    vim.g.current_theme = theme
    refresh_nvchad_ui()
    return
  end

  local ok, nvthemes = pcall(require, "nvchad.themes")
  if ok and nvthemes.set then
    nvthemes.set(theme)
  else
    vim.g.base46_theme = theme
    pcall(function()
      require("base46").load_all_highlights()
    end)
  end

  vim.g.current_theme = theme
end

function M.pick()
  local ok, nvthemes = pcall(require, "nvchad.themes")
  if ok and nvthemes.open then
    nvthemes.open()
    return
  end

  local ok_ts, telescope = pcall(require, "telescope.builtin")
  if ok_ts then
    telescope.colorscheme({
      enable_preview = true,
      attach_mappings = function(_, map)
        local actions = require("telescope.actions")
        map("i", "<CR>", function(prompt_bufnr)
          local selection = require("telescope.actions.state").get_selected_entry()
          actions.close(prompt_bufnr)
          if selection and selection.value then
            M.apply(selection.value)
          end
        end)
        return true
      end,
    })
  end
end

function M.auto()
  local hour = tonumber(os.date("%H"))
  if hour >= 7 and hour < 18 then
    M.apply("catppuccin")
  else
    M.apply("tokyonight")
  end
end

function M.next()
  local cycle = vim.list_extend({ "tokyonight" }, base46_themes)
  local current = vim.g.current_theme or cycle[1]
  local index = 1

  for i, t in ipairs(cycle) do
    if t == current then
      index = i + 1
      break
    end
  end

  if index > #cycle then
    index = 1
  end

  M.apply(cycle[index])
end

function M.setup_startup()
  local chadrc = require("chadrc")
  local theme = chadrc.base46 and chadrc.base46.theme
  if theme then
    M.apply(theme)
  end
end

function M.setup_keymaps()
  vim.keymap.set("n", "<leader>cs", function()
    M.pick()
  end, { desc = "Colorscheme Picker" })

  vim.keymap.set("n", "<leader>ct", function()
    M.next()
  end, { desc = "Next Theme" })

  vim.keymap.set("n", "<leader>ca", function()
    M.auto()
  end, { desc = "Auto Theme (Day/Night)" })
end

return M
