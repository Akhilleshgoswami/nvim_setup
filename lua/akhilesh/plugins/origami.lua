return {
  {
    "chrisgrieser/nvim-origami",
    event = "VeryLazy",

    opts = {
      foldKeymaps = {
        setup = false,
      },

      pauseFoldsOnSearch = true,

      foldtext = {
        enabled = false,
      },

      autoFold = {
        enabled = false,
      },
    },

    config = function(_, opts)
      require("origami").setup(opts)

      -- ======================================================
      -- FOLD SETTINGS
      -- ======================================================

      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

      vim.opt.foldenable = true
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
      vim.opt.foldnestmax = 5

      -- ======================================================
      -- CLEAN LEFT SIDE
      -- only absolute + relative numbers
      -- ======================================================

      vim.opt.number = true
      vim.opt.relativenumber = true

      -- remove ALL extra columns
      vim.opt.signcolumn = "no"
      vim.opt.foldcolumn = "0"
      vim.opt.numberwidth = 4
      vim.opt.statuscolumn = ""

      -- ======================================================
      -- MODERN UI
      -- ======================================================

      vim.opt.cursorline = true
      vim.opt.list = false
      vim.opt.cmdheight = 0
      vim.opt.laststatus = 3

      vim.opt.fillchars = {
        fold = " ",
        foldopen = "",
        foldclose = "",
        foldsep = " ",
        diff = "╱",
        eob = " ",
      }

      -- ======================================================
      -- BEAUTIFUL FOLD TEXT
      -- ======================================================

      function _G.custom_foldtext()
        local line = vim.fn.getline(vim.v.foldstart)
        local lines_count = vim.v.foldend - vim.v.foldstart + 1
        local win_width = vim.api.nvim_win_get_width(0)

        -- clean line
        line = line:gsub("^%s*", "")
        line = line:gsub("{", "")
        line = line:gsub("}", "")

        local icon = "󰘖 "
        local suffix = string.format("   %d lines ", lines_count)

        local available =
          win_width
          - vim.fn.strdisplaywidth(suffix)
          - vim.fn.strdisplaywidth(icon)
          - 10

        if vim.fn.strdisplaywidth(line) > available then
          line = vim.fn.strcharpart(line, 0, available) .. "…"
        end

        local padding = string.rep(
          " ",
          math.max(
            1,
            win_width
              - vim.fn.strdisplaywidth(line)
              - vim.fn.strdisplaywidth(suffix)
              - 10
          )
        )

        return icon .. line .. padding .. suffix
      end

      vim.opt.foldtext = "v:lua.custom_foldtext()"

      -- ======================================================
      -- HIGHLIGHTS
      -- ======================================================

      vim.api.nvim_set_hl(0, "Folded", {
        fg = "#7dcfff",
        bg = "NONE",
        italic = true,
        bold = false,
      })

      vim.api.nvim_set_hl(0, "LineNr", {
        fg = "#565f89",
        bg = "NONE",
      })

      vim.api.nvim_set_hl(0, "CursorLineNr", {
        fg = "#e0af68",
        bold = true,
        bg = "NONE",
      })

      vim.api.nvim_set_hl(0, "CursorLine", {
        bg = "#1a1b26",
      })

      vim.api.nvim_set_hl(0, "SignColumn", {
        bg = "NONE",
      })

      vim.api.nvim_set_hl(0, "FoldColumn", {
        bg = "NONE",
      })

      vim.api.nvim_set_hl(0, "NormalFloat", {
        bg = "#16161e",
      })

      vim.api.nvim_set_hl(0, "FloatBorder", {
        fg = "#3b4261",
        bg = "#16161e",
      })

      -- ======================================================
      -- SMOOTH FOLD OPEN/CLOSE
      -- ======================================================

      vim.opt.foldopen:append({
        "block",
        "mark",
        "percent",
        "quickfix",
        "search",
        "tag",
        "undo",
      })

      -- ======================================================
      -- KEYMAPS
      -- ======================================================

      vim.keymap.set("n", "zR", function()
        require("origami").openAllFolds()
      end, { desc = "Open all folds" })

      vim.keymap.set("n", "zM", function()
        require("origami").closeAllFolds()
      end, { desc = "Close all folds" })

      vim.keymap.set("n", "<leader>fo", "zo", {
        remap = true,
        desc = "Open fold",
      })

      vim.keymap.set("n", "<leader>fc", "zc", {
        remap = true,
        desc = "Close fold",
      })

      vim.keymap.set("n", "<leader>t", "za", {
        remap = true,
        desc = "Toggle fold",
      })

      -- peek folded lines
      vim.keymap.set("n", "zp", function()
        local winid = require("origami").peekFoldedLinesUnderCursor()

        if not winid then
          vim.lsp.buf.hover()
        end
      end, { desc = "Peek fold" })
    end,
  },
}
