local function patch_treesitter_ft_to_lang()
  local ok, parsers = pcall(require, "nvim-treesitter.parsers")
  if ok and not parsers.ft_to_lang then
    parsers.ft_to_lang = function(ft)
      if vim.treesitter.ft_to_lang then
        return vim.treesitter.ft_to_lang(ft)
      end
      local ok2, lang = pcall(vim.treesitter.language.get_lang, ft)
      return ok2 and lang or ft
    end
  end
end

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,
  priority = 1000,
  init = patch_treesitter_ft_to_lang,
  opts = function()
    patch_treesitter_ft_to_lang()
    local base = require "nvchad.configs.treesitter"
    return vim.tbl_deep_extend("force", base, {
      ensure_installed = {
        "bash", "c", "diff", "html", "lua", "go", "vim", "vimdoc",
        "javascript", "typescript", "tsx", "javascriptreact", "move",
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
    })
  end,
}
