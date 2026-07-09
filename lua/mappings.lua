-- NvChad defaults load first; user mappings below override conflicts.
require "nvchad.mappings"

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ============================================================
-- Core keymaps (preserved from akhilesh.core.keymaps)
-- ============================================================

map("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
map("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
map("n", "<leader>pv", vim.cmd.Ex)

map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")
map("n", "J", "mzJ`z")

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "<leader>zig", "<cmd>LspRestart<cr>")

map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<leader>bd", "<cmd>bd<CR>", { desc = "Delete buffer" })
map("n", "<leader>c", "<cmd>q<CR>", { desc = "Close window" })

map("x", "<leader>p", [["_dP]])
map({ "n", "v" }, "<leader>y", [["+y]])
map("n", "<leader>Y", [["+Y]])
map({ "n", "v" }, "<leader>d", [["_d]])

map("n", "Q", "<nop>")
map("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
map("n", "<leader>f", vim.lsp.buf.format, { desc = "LSP format" })

map("n", "<C-k>", "<cmd>cnext<CR>zz")
map("n", "<C-j>", "<cmd>cprev<CR>zz")
map("n", "<leader>k", "<cmd>lnext<CR>zz")
map("n", "<leader>j", "<cmd>lprev<CR>zz")

map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
map("n", "<leader>vpp", "<cmd>e ~/.dotfiles/nvim/.config/nvim/lua/theprimeagen/packer.lua<CR>")
map("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>")

map("n", "<leader><leader>", function()
  vim.cmd("so")
end)

map("n", "<leader>t", "<cmd>Sterm<CR>")

map("n", "-", function()
  require("oil").open_float()
end, { desc = "Open parent directory" })

map("n", "<leader>gd", ":DiffviewOpen<CR>", { desc = "Open Git Diff" })
map("n", "<leader>gc", ":DiffviewClose<CR>", { desc = "Close Git Diff" })
map("n", "<leader>q", ":DiffviewToggleFiles<CR>", { desc = "Toggle file git diff" })

-- ============================================================
-- NvChad tabufline bridge (preserves Tab / Shift-Tab / Shift-C)
-- ============================================================

vim.api.nvim_create_user_command("BufferPrevious", function()
  require("nvchad.tabufline").prev()
end, {})

vim.api.nvim_create_user_command("BufferNext", function()
  require("nvchad.tabufline").next()
end, {})

vim.api.nvim_create_user_command("BufferClose", function()
  require("nvchad.tabufline").close_buffer()
end, {})

map("n", "<Tab>", "<Cmd>BufferPrevious<CR>", opts)
map("n", "<S-Tab>", "<Cmd>BufferNext<CR>", opts)
map("n", "<S-C>", "<Cmd>BufferClose<CR>", opts)

-- Harpoon highlights
vim.cmd("highlight! HarpoonInactive guibg=NONE guifg=#63698c")
vim.cmd("highlight! HarpoonActive guibg=NONE guifg=white")
vim.cmd("highlight! HarpoonNumberActive guibg=NONE guifg=#7aa2f7")
vim.cmd("highlight! HarpoonNumberInactive guibg=NONE guifg=#7aa2f7")
vim.cmd("highlight! TabLineFill guibg=NONE guifg=white")

-- ============================================================
-- Override NvChad mappings that conflict with preserved workflow
-- ============================================================

map("n", "<leader>e", function()
  require("snacks").explorer({ layout = { preset = "sidebar", preview = false } })
end, { desc = "Explorer sidebar" })

-- <leader>ff / <leader>fb / <leader>fo use NvChad Telescope (from nvchad.mappings)
-- Snacks pickers remain on <leader>sf, <leader>fg, <leader>fr, etc.

map("n", "<leader>bd", function()
  require("snacks").bufdelete()
end, { desc = "Delete buffer" })
