require("akhilesh.core.options")
require("akhilesh.core.hjkl")
require("akhilesh.core.notes")
require("akhilesh.core.keymaps")
require("akhilesh.core.scratch")

local theme = require("akhilesh.core.theme")

-- 🎨 fuzzy picker (VSCode Cmd+K T)
vim.keymap.set("n", "<leader>cs", function()
  theme.pick()
end, { desc = "Colorscheme Picker (VSCode style)" })

-- ⚡ instant switch
vim.keymap.set("n", "<leader>ct", function()
  theme.next()
end, { desc = "Next Theme" })

-- 🧠 auto day/night
vim.keymap.set("n", "<leader>ca", function()
  theme.auto()
end, { desc = "Auto Theme (Day/Night)" })

