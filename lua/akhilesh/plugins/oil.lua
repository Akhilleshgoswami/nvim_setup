return {
  "stevearc/oil.nvim",

  lazy = false,

  dependencies = {
    { "echasnovski/mini.icons", opts = {} },
  },

  keys = {
    { "-", "<cmd>Oil --float<CR>", desc = "Oil Float" },
    { "<leader>oe", "<cmd>Oil --float<CR>", desc = "Explorer" },
  },

  opts = {

    default_file_explorer = true,
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,

    -- ======================================================
    -- COLUMNS
    -- ======================================================

    columns = {
      {
        "icon",
        default_file = "󰈔",
        directory = "󰉋",
      },
    },

    -- ======================================================
    -- VIEW
    -- ======================================================

    view_options = {
      show_hidden = true,
      natural_order = true,
      is_hidden_file = function(name)
        return vim.startswith(name, ".")
      end,
    },

    -- ======================================================
    -- FLOAT WINDOW
    -- ======================================================

    float = {
      padding = 2,

      max_width = 100,
      max_height = 36,

      border = "rounded",

      win_options = {
        winblend = 8,
      },
    },

    preview = {
      border = "rounded",
      win_options = {
        winblend = 8,
      },
    },

    -- ======================================================
    -- WINDOW OPTIONS
    -- ======================================================

    win_options = {
      signcolumn = "no",
      foldcolumn = "0",

      number = false,
      relativenumber = false,

      cursorline = true,
      cursorcolumn = false,

      wrap = false,
      spell = false,

      list = false,

      winblend = 0,

      colorcolumn = "0",
    },

    -- ======================================================
    -- KEYMAPS
    -- ======================================================

    use_default_keymaps = false,

    keymaps = {
      ["q"] = "actions.close",
      ["<Esc>"] = "actions.close",

      ["<CR>"] = "actions.select",
      ["l"] = "actions.select",

      ["h"] = "actions.parent",

      ["-"] = "actions.parent",

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

      ["gd"] = {
        desc = "Toggle detail view",
        callback = function()
          detail = not detail
          if detail then
            require("oil").set_columns({
              "icon",
              "permissions",
              "size",
              "mtime",
            })
          else
            require("oil").set_columns({ "icon" })
          end
        end,
      },
    },
  },

  config = function(_, opts)
    require("oil").setup(opts)

    -- ======================================================
    -- HIGHLIGHTS
    -- ======================================================

    local set = vim.api.nvim_set_hl

    -- main bg
    set(0, "OilFloat", {
      bg = "#11131a",
    })

    -- border
    set(0, "OilBorder", {
      fg = "#2f334d",
      bg = "#11131a",
    })

    -- directories
    set(0, "OilDir", {
      fg = "#7aa2f7",
      bold = true,
    })

    -- files
    set(0, "OilFile", {
      fg = "#c0caf5",
    })

    -- hidden files
    set(0, "OilHidden", {
      fg = "#565f89",
      italic = true,
    })

    -- permissions/details
    set(0, "OilPermissions", {
      fg = "#7dcfff",
    })

    -- copy
    set(0, "OilCopy", {
      fg = "#e0af68",
    })

    -- move
    set(0, "OilMove", {
      fg = "#7dcfff",
    })

    -- delete
    set(0, "OilDelete", {
      fg = "#f7768e",
    })

    -- change
    set(0, "OilChange", {
      fg = "#bb9af7",
    })

    -- cursorline
    set(0, "CursorLine", {
      bg = "#1a1d2a",
    })

    -- rounded popup harmony
    set(0, "FloatBorder", {
      fg = "#2f334d",
      bg = "#11131a",
    })

    set(0, "NormalFloat", {
      bg = "#11131a",
    })
  end,
}
