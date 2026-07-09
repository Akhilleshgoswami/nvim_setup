return {
  "stevearc/oil.nvim",
  lazy = false,
  priority = 900,

  dependencies = {
    { "echasnovski/mini.icons", opts = {} },
  },

  keys = {
    {
      "<leader>oe",
      function()
        require("oil").open_float()
      end,
      desc = "Oil float explorer",
    },
  },

  opts = {
    default_file_explorer = true,
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,

    columns = {
      {
        "icon",
        default_file = "󰈔",
        directory = "󰉋",
      },
    },

    view_options = {
      show_hidden = true,
      natural_order = true,
      is_hidden_file = function(name)
        return vim.startswith(name, ".")
      end,
    },

    float = {
      padding = 2,
      max_width = 0.85,
      max_height = 0.85,
      border = "rounded",
      win_options = {
        winblend = 0,
      },
    },

    preview_win = {
      update_on_cursor_moved = false,
      preview_method = "fast_scratch",
      win_options = {
        winblend = 0,
      },
    },

    confirmation = {
      border = "rounded",
      win_options = {
        winblend = 0,
      },
    },

    win_options = {
      signcolumn = "no",
      foldcolumn = "0",
      number = false,
      relativenumber = false,
      cursorline = true,
      wrap = false,
      list = false,
      winblend = 0,
    },

    use_default_keymaps = false,

    keymaps = {
      ["q"] = "actions.close",
      ["<Esc>"] = "actions.close",
      ["<CR>"] = "actions.select",
      ["l"] = "actions.select",
      ["h"] = "actions.parent",
      ["-"] = "actions.parent",
      ["<C-v>"] = { "actions.select", opts = { vertical = true } },
      ["<C-s>"] = { "actions.select", opts = { horizontal = true } },
      ["."] = "actions.toggle_hidden",
      ["<C-r>"] = "actions.refresh",
      ["<C-p>"] = "actions.preview",
      ["gd"] = {
        desc = "Toggle detail view",
        callback = function()
          vim.g._oil_detail = not vim.g._oil_detail
          if vim.g._oil_detail then
            require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
          else
            require("oil").set_columns({ "icon" })
          end
        end,
      },
    },
  },

  config = function(_, opts)
    require("oil").setup(opts)

    local function set_hl()
      local ok, ui = pcall(require, "akhilesh.ui")
      local c = ok and ui.colors() or {
        bg_float = "#16161e",
        border = "#2f334d",
        blue = "#7aa2f7",
        fg = "#cdd6f4",
        fg_muted = "#565f89",
        cyan = "#7dcfff",
        yellow = "#e0af68",
        red = "#f7768e",
        purple = "#bb9af7",
        bg_muted = "#1f2335",
      }
      local set = vim.api.nvim_set_hl
      set(0, "OilFloat", { bg = c.bg_float })
      set(0, "OilBorder", { fg = c.border, bg = c.bg_float })
      set(0, "OilDir", { fg = c.blue, bold = true })
      set(0, "OilFile", { fg = c.fg })
      set(0, "OilHidden", { fg = c.fg_muted, italic = true })
      set(0, "OilPermissions", { fg = c.cyan })
      set(0, "OilCopy", { fg = c.yellow })
      set(0, "OilMove", { fg = c.cyan })
      set(0, "OilDelete", { fg = c.red })
      set(0, "OilChange", { fg = c.purple })
      set(0, "NormalFloat", { bg = c.bg_float })
      set(0, "FloatBorder", { fg = c.border, bg = c.bg_float })
      set(0, "CursorLine", { bg = c.bg_muted })
    end

    set_hl()
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.schedule(set_hl)
      end,
    })
  end,
}
