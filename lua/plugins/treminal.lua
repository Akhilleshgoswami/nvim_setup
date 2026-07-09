   -- Lazy
-- ============================================================
--  lua/akhilesh/plugins/termim.lua
--  Modern + Theme Adaptive + Clean Terminal UI
-- ============================================================

return {
  "2kabhishek/termim.nvim",

  cmd = {
    "Fterm",
    "FTerm",
    "Sterm",
    "STerm",
    "Vterm",
    "VTerm",
  },

  config = function()

    -- ========================================================
    -- THEME COLORS
    -- ========================================================

    local function hl(name, attr)
      local ok, h = pcall(vim.api.nvim_get_hl, 0, {
        name = name,
        link = false,
      })

      if not ok or not h[attr] then
        return nil
      end

      return string.format("#%06x", h[attr])
    end

    local colors = {
      bg      = hl("Normal", "bg") or "#111111",
      fg      = hl("Normal", "fg") or "#cdd6f4",

      blue    = hl("Function", "fg") or "#7aa2f7",
      green   = hl("String", "fg") or "#9ece6a",
      red     = hl("DiagnosticError", "fg") or "#f7768e",
      yellow  = hl("Type", "fg") or "#e0af68",
      purple  = hl("Statement", "fg") or "#bb9af7",
      cyan    = hl("Keyword", "fg") or "#7dcfff",

      comment = hl("Comment", "fg") or "#565f89",
    }

    -- ========================================================
    -- HIGHLIGHTS
    -- ========================================================

    local function set_hl()
      local set = vim.api.nvim_set_hl

      set(0, "FloatBorder", {
        fg = colors.comment,
        bg = colors.bg,
      })

      set(0, "NormalFloat", {
        fg = colors.fg,
        bg = colors.bg,
      })

      set(0, "TermCursor", {
        fg = colors.bg,
        bg = colors.blue,
      })

      set(0, "TermCursorNC", {
        fg = colors.bg,
        bg = colors.comment,
      })
    end

    set_hl()

    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.schedule(set_hl)
      end,
    })

    -- ========================================================
    -- TERMINAL UI
    -- ========================================================

    vim.api.nvim_create_autocmd("TermOpen", {
      callback = function()

        -- clean terminal
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false

        vim.opt_local.signcolumn = "no"
        vim.opt_local.foldcolumn = "0"

        vim.opt_local.cursorline = false

        vim.opt_local.list = false

        vim.opt_local.winbar = ""

        -- smooth scrolling
        vim.opt_local.scrolloff = 0

        -- start insert automatically
        vim.cmd("startinsert")

        -- hide annoying status stuff
        vim.opt_local.statuscolumn = ""

        -- terminal keymaps
        local opts = {
          buffer = true,
          silent = true,
        }

        vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], opts)

        vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
      end,
    })

    -- ========================================================
    -- FLOATING WINDOW STYLE
    -- ========================================================

    vim.o.winborder = "rounded"

    -- ========================================================
    -- KEYMAPS
    -- ========================================================

    vim.keymap.set(
      "n",
      "<leader>tf",
      "<cmd>Fterm<CR>",
      { desc = "Floating terminal" }
    )

    vim.keymap.set(
      "n",
      "<leader>th",
      "<cmd>Sterm<CR>",
      { desc = "Horizontal terminal" }
    )

    vim.keymap.set(
      "n",
      "<leader>tv",
      "<cmd>Vterm<CR>",
      { desc = "Vertical terminal" }
    )

    -- ========================================================
    -- EXTRA GEEK FEEL
    -- ========================================================

    vim.api.nvim_create_autocmd("TermEnter", {
      callback = function()
        vim.cmd("setlocal nocursorline")
      end,
    })

    vim.api.nvim_create_autocmd("TermLeave", {
      callback = function()
        vim.cmd("setlocal cursorline")
      end,
    })
  end,
}
