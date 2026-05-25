return {
  "stevearc/oil.nvim",

  lazy = false,

  dependencies = {
    { "echasnovski/mini.icons", opts = {} },
  },

  keys = {
    { "-", "<cmd>Oil<CR>", desc = "Oil" },
    { "<leader>e", "<cmd>Oil --float<CR>", desc = "Explorer" },
  },

  opts = {

    default_file_explorer = true,
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,

    -- ======================================================
    -- UI
    -- ======================================================

    columns = {
      { "icon" },
      -- remove size/date clutter
    },

    win_options = {
      signcolumn = "no",
      foldcolumn = "0",
      number = false,
      relativenumber = false,
      cursorcolumn = false,
      wrap = false,
      winblend = 0,
    },

    view_options = {
      show_hidden = true,
      natural_order = true,
    },

    float = {
      padding = 3,
      max_width = 90,
      max_height = 35,
      border = "rounded",
    },

    preview = {
      border = "rounded",
    },

    -- ======================================================
    -- KEYMAPS
    -- ======================================================

    keymaps = {
      ["q"] = "actions.close",
      ["<Esc>"] = "actions.close",

      ["<CR>"] = "actions.select",
      ["l"] = "actions.select",

      ["h"] = "actions.parent",

      ["<C-v>"] = {
        "actions.select",
        opts = { vertical = true },
      },

      ["<C-s>"] = {
        "actions.select",
        opts = { horizontal = true },
      },

      ["."] = "actions.toggle_hidden",

      ["<C-r>"] = "actions.refresh",
    },

    use_default_keymaps = false,
  },

  config = function(_, opts)
    require("oil").setup(opts)

    -- ======================================================
    -- THEME
    -- ======================================================

    vim.api.nvim_set_hl(0, "OilDir", {
      fg = "#7aa2f7",
      bold = true,
    })

    vim.api.nvim_set_hl(0, "OilFile", {
      fg = "#c0caf5",
    })

    vim.api.nvim_set_hl(0, "OilHidden", {
      fg = "#565f89",
    })

    vim.api.nvim_set_hl(0, "OilCopy", {
      fg = "#e0af68",
    })

    vim.api.nvim_set_hl(0, "OilMove", {
      fg = "#7dcfff",
    })

    vim.api.nvim_set_hl(0, "OilChange", {
      fg = "#bb9af7",
    })

    vim.api.nvim_set_hl(0, "OilDelete", {
      fg = "#f7768e",
    })

    -- transparent background
    vim.api.nvim_set_hl(0, "OilFloat", {
      bg = "NONE",
    })

    vim.api.nvim_set_hl(0, "OilBorder", {
      fg = "#3b4261",
      bg = "NONE",
    })
  end,
}
