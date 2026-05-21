-- lua/akhilesh/core/notes.lua

vim.api.nvim_create_autocmd("User", {
  pattern  = "VeryLazy",
  once     = true,
  callback = function()

    local function new_note()
      Snacks.input({ prompt = "Note name: " }, function(name)
        if not name or name == "" then return end
        name = name:gsub("%s+", "-"):lower()
        local dir  = vim.fn.expand("~/Notes")
        local path = dir .. "/" .. name .. ".md"
        vim.fn.mkdir(dir, "p")
        if vim.fn.filereadable(path) == 1 then
          vim.notify("Note exists, opening: " .. name, vim.log.levels.INFO)
        end
        vim.cmd("e " .. vim.fn.fnameescape(path))
      end)
    end

    vim.keymap.set("n", "<leader>nn", new_note, { desc = "New note" })
    vim.keymap.set("n", "<leader>nf", function()
      Snacks.picker.files({ cwd = "~/Notes" })
    end, { desc = "Find note" })

  end,
})
