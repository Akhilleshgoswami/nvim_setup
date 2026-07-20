---@class UmbraConfig
---@field transparent? boolean Use NONE for editor background
---@field dim_inactive? boolean Mute unfocused windows
---@field italic_comments? boolean Italic @comment and Comment
---@field bold_keywords? boolean Bold @keyword captures
---@field bright_cursorline? boolean Stronger CursorLine background
---@field terminal? boolean Apply ANSI palette to :terminal
---@field plugins? boolean Include third-party plugin highlights
---@field overrides? table<string, vim.api.keyset.highlight> User highlight overrides
---@field palette? table Partial palette overrides (deep-merged into base palette)

local M = {
  transparent = false,
  dim_inactive = false,
  italic_comments = true,
  bold_keywords = false,
  bright_cursorline = false,
  terminal = true,
  plugins = true,
  overrides = {},
  palette = {},
}

---@param opts? UmbraConfig
---@return UmbraConfig
function M.merge(opts)
  return vim.tbl_deep_extend("force", vim.deepcopy(M), opts or {})
end

return M
