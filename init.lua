-- init.lua
if vim.treesitter.ft_to_lang == nil then
  vim.treesitter.ft_to_lang = function(ft)
    local ok, lang = pcall(vim.treesitter.language.get_lang, ft)
    return ok and lang or ft
  end
end


require("akhilesh.core")
require("akhilesh.lazy")

