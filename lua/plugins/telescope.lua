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
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  cmd = "Telescope",
  keys = {
    { "<leader>ft", "<cmd>Telescope colorscheme<CR>", desc = "Colorscheme (Telescope)" },
    { "<leader>fj", "<cmd>Telescope todo<CR>", desc = "Todo comments (Telescope)" },
  },
  dependencies = {
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
    "folke/todo-comments.nvim",
  },
  opts = function()
    local nvchad = require "nvchad.configs.telescope"
    return vim.tbl_deep_extend("force", nvchad, {
      defaults = {
        preview = {
          treesitter = false,
        },
      },
    })
  end,
  config = function(_, opts)
    patch_treesitter_ft_to_lang()

    local telescope = require "telescope"
    telescope.setup(opts)

    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "ui-select")
    pcall(telescope.load_extension, "file_browser")
    pcall(telescope.load_extension, "todo-comments")
  end,
}
