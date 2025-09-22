return{
  "lukas-reineke/indent-blankline.nvim",
  opts = {
    indent = {
      char = '▏',
    },
  },
  config = function(_, opts)

    vim.tbl_extend("force", opts, {
      -- options that for some reason you couldn't add in the opts field table
    })

    require("ibl").setup(opts)
  end,
}
