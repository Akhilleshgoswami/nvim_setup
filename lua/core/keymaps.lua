-- Global, plugin-agnostic keymaps. Plugin keys live with their specs.
-- Leader = Space. Descriptions feed which-key.

local map = vim.keymap.set

-- ── Essentials ───────────────────────────────────────────────────
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
map("n", "<leader>nh", "<cmd>nohlsearch<cr>", { desc = "Clear highlights" })
map({ "n", "i", "x", "s" }, "<C-s>", "<cmd>write<cr><esc>", { desc = "Save file" })
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Save file" })
map("n", "<leader>W", "<cmd>wall<cr>", { desc = "Save all" })
map("n", "<leader>Q", "<cmd>qa<cr>", { desc = "Quit all" })
map("n", "Q", "<nop>")
-- (Window close lives at <leader>sx; <leader>c is the code group.)

-- ── Movement & editing niceties ─────────────────────────────────
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map("n", "n", "nzzzv", { desc = "Next match (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev match (centered)" })
map("n", "J", "mzJ`z", { desc = "Join line (keep cursor)" })

-- Keep selection when indenting; move visual blocks.
map("x", "<", "<gv", { desc = "Indent left" })
map("x", ">", ">gv", { desc = "Indent right" })
map("x", "J", ":m '>+1<cr>gv=gv", { desc = "Move selection down", silent = true })
map("x", "K", ":m '<-2<cr>gv=gv", { desc = "Move selection up", silent = true })

-- Register-friendly clipboard.
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
map("n", "<leader>Y", [["+Y]], { desc = "Yank line to clipboard" })
-- Visual-only so normal-mode <leader>d stays free for the debug group.
map("x", "<leader>d", [["_d]], { desc = "Delete without yank" })
map("x", "<leader>p", [["_dP]], { desc = "Paste keeping register" })

-- ── Windows & splits ────────────────────────────────────────────
-- (Left/right/up/down window movement is handled by vim-tmux-navigator.)
map("n", "<leader>sv", "<C-w>v", { desc = "Split vertical" })
map("n", "<leader>ss", "<C-w>s", { desc = "Split horizontal" })
map("n", "<leader>se", "<C-w>=", { desc = "Equalize splits" })
map("n", "<leader>sx", "<cmd>close<cr>", { desc = "Close split" })
map("n", "<leader>sm", function() require("utils").toggle_maximize() end, { desc = "Maximize split (toggle)" })
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Grow height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Shrink height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Shrink width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Grow width" })

-- ── Buffers ─────────────────────────────────────────────────────
map("n", "<leader>bd", function() require("utils").bufremove() end, { desc = "Delete buffer" })
map("n", "<leader>bo", function() require("utils").delete_other_buffers() end, { desc = "Delete other buffers" })
map("n", "<leader>bn", "<cmd>enew<cr>", { desc = "New buffer" })

-- ── Quickfix & location lists ───────────────────────────────────
map("n", "]q", "<cmd>cnext<cr>zz", { desc = "Next quickfix" })
map("n", "[q", "<cmd>cprev<cr>zz", { desc = "Prev quickfix" })
map("n", "]l", "<cmd>lnext<cr>zz", { desc = "Next loclist" })
map("n", "[l", "<cmd>lprev<cr>zz", { desc = "Prev loclist" })

-- ── WezTerm (external terminal — primary terminal workflow) ─────
-- Reuses a running WezTerm instance (new tab/pane) when Neovim is launched
-- from it; otherwise opens a fresh GUI window. Directory is inherited.
local function wez(fn)
  return function() require("features.wezterm")[fn]() end
end
map("n", "<leader>tw", wez("window_root"), { desc = "WezTerm: new window (project root)" })
map("n", "<leader>tp", wez("tab_root"), { desc = "WezTerm: new tab (project root)" })
map("n", "<leader>td", wez("tab_file_dir"), { desc = "WezTerm: new tab (file's dir)" })
map("n", "<leader>t\\", wez("vsplit_file_dir"), { desc = "WezTerm: split right (file's dir)" })
map("n", "<leader>t-", wez("hsplit_file_dir"), { desc = "WezTerm: split down (file's dir)" })

-- ── Workflow ────────────────────────────────────────────────────
-- (Note: <C-f> is left to neoscroll for animated page-down; the old
-- tmux-sessionizer binding was removed now that WezTerm is the primary term.)
map("n", "<leader>ur", function() require("utils").reload() end, { desc = "Reload Umbra config" })
map("n", "<leader>uM", function() require("umbra.motion").toggle() end, { desc = "Reduce motion (toggle)" })
map("n", "<leader>X", "<cmd>!chmod +x %<cr>", { desc = "Make file executable", silent = true })
map("n", "<leader>P", "<cmd>Telescope commands<cr>", { desc = "Command palette" })

-- ── Health & performance ────────────────────────────────────────
vim.api.nvim_create_user_command("UmbraHealth", function()
  require("features.health").show()
end, { desc = "Umbra health / performance report" })
map("n", "<leader>uh", "<cmd>UmbraHealth<cr>", { desc = "Health / performance" })
map("n", "<leader>up", "<cmd>Lazy profile<cr>", { desc = "Plugin profile" })
