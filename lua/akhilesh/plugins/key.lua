return {
  {
    "NStefan002/screenkey.nvim",
    lazy = false,

    config = function()
      local screenkey = require("screenkey")

      screenkey.setup({
        clear_after = 3,
      })

      screenkey.toggle()
    end,
  },
}
