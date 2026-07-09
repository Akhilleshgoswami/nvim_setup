return {
  "chrisgrieser/nvim-rip-substitute",

  event = "VeryLazy",

  dependencies = {
    "nvim-lua/plenary.nvim",
  },

  keys = {
    {
      "<leader>srf",

      function()
        require("rip-substitute").sub()
      end,

      mode = { "n", "x" },

      desc = "󰛔 Rip Substitute",
    },

  --   {
  --     "<leader>swr",
  --
  --     function()
  --       require("rip-substitute").sub({
  --         range = {
  --           from = vim.fn.line("."),
  --           to = vim.fn.line("."),
  --         },
  --       })
  --     end,
  --
  --     mode = "n",
  --
  --     desc = "󰱼 Substitute Word",
  --   },
  },

  opts = {
    popupWin = {
      title = " RIP SUBSTITUTE",

      border = "rounded",

      -- TOP RIGHT
      position = {
        row = "2%",
        col = "98%",
      },

      relative = "editor",

      anchor = "NE",

      size = {
        width = "70%",
        height = "30%",
      },
    },

    keymaps = {
      confirm = "<CR>",
      close = "q",

      nextSubstitution = "<C-j>",
      prevSubstitution = "<C-k>",

      toggleFixedStrings = "<C-f>",
      toggleIgnoreCase = "<C-c>",

      openAtRegex101 = "R",
    },

    editingBehavior = {
      autoCaptureGroups = true,
    },

    notificationOnSuccess = true,

    prefill = {
      normal = "cursorWord",
      visual = "selection",
    },

    incrementalPreview = {
      matchCount = true,
    },
  },

  config = function(_, opts)
    require("rip-substitute").setup(opts)

    -- ======================================================
    -- HIGHLIGHTS
    -- ======================================================

    local set = vim.api.nvim_set_hl

    set(0, "RipSubstituteBorder", {
      fg = "#253046",
      bg = "#0d1117",
    })

    set(0, "RipSubstituteNormal", {
      fg = "#c9d1d9",
      bg = "#0d1117",
    })

    set(0, "RipSubstituteTitle", {
      fg = "#090b10",
      bg = "#58a6ff",
      bold = true,
    })

    set(0, "RipSubstituteMatch", {
      fg = "#f2cc60",
      bold = true,
    })

    set(0, "RipSubstituteReplacement", {
      fg = "#7ee787",
      bold = true,
    })
  end,
}

