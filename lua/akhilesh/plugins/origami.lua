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
        enabled = true,
        padding = 1,
        lineCount = {
          template = " 󰁂 %d ",
        },
      },

      autoFold = {
        enabled = false,
      },
    },

    config = function(_, opts)
      require("origami").setup(opts)

      -- ======================================================
      -- FOLDING
      -- ======================================================

      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

      vim.opt.foldenable = true
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99

      -- ======================================================
      -- NUMBERS
      -- ======================================================

      vim.opt.number = true
      vim.opt.relativenumber = true

      -- REMOVE EXTRA LEFT UI
      vim.opt.signcolumn = "no"
      vim.opt.foldcolumn = "0"
      vim.opt.statuscolumn = ""

      -- ======================================================
      -- CLEAN UI
      -- ======================================================

      vim.opt.cursorline = true
      vim.opt.list = false

      vim.opt.fillchars = {
        fold = " ",
        foldopen = "",
        foldclose = "",
        foldsep = " ",
        eob = " ",
      }

      -- ======================================================
      -- CUSTOM FOLD TEXT
      -- ======================================================

      function _G.custom_foldtext()
        local line = vim.fn.getline(vim.v.foldstart)
        local lines_count = vim.v.foldend - vim.v.foldstart + 1

        return string.format(
          " 󰘖 %s   [%d lines]",
          line:gsub("^%s*", ""),
          lines_count
        )
      end

      vim.opt.foldtext = "v:lua.custom_foldtext()"

      -- ======================================================
      -- HIGHLIGHTS
      -- ======================================================

      vim.api.nvim_set_hl(0, "Folded", {
        fg = "#7aa2f7",
        bg = "NONE",
        italic = true,
      })

      vim.api.nvim_set_hl(0, "LineNr", {
        fg = "#5c6370",
        bg = "NONE",
      })

      vim.api.nvim_set_hl(0, "CursorLineNr", {
        fg = "#e0af68",
        bold = true,
        bg = "NONE",
      })

      vim.api.nvim_set_hl(0, "SignColumn", {
        bg = "NONE",
      })

      vim.api.nvim_set_hl(0, "FoldColumn", {
        bg = "NONE",
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

      vim.keymap.set("n", "<leader>ft", "za", {
        remap = true,
        desc = "Toggle fold",
      })
    end,
  },
}
