return {
  "gbprod/substitute.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local substitute = require("substitute")
    substitute.setup()

    local keymap = vim.keymap
    -- Remapped from s/S to avoid conflict with flash.nvim (user keymaps unchanged)
    keymap.set("n", "<leader>sr", substitute.operator, { desc = "Substitute with motion" })
    keymap.set("n", "<leader>sl", substitute.line, { desc = "Substitute line" })
    keymap.set("n", "<leader>sS", substitute.eol, { desc = "Substitute to end of line" })
    keymap.set("x", "<leader>sr", substitute.visual, { desc = "Substitute in visual mode" })
  end,
}
