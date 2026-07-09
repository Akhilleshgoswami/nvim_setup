return {
  "mmsaki/forgefmt.nvim",
  ft = { "solidity", "sol" },
  config = function()
    require("forgefmt").setup({
      auto_format = true,
    })
  end,
}
