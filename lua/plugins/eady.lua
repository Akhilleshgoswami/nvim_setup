return {
  "folke/edgy.nvim",
  event = "VeryLazy",
  opts = {
    animate = { enabled = false },
    wo = {
      winbar = true,
      winfixwidth = true,
      winfixheight = false,
      winhighlight = "WinBar:EdgyWinBar,Normal:EdgyNormal",
    },
    options = {
      left = { size = 38 },
      bottom = { size = 12 },
    },

    left = {
      {
        ft = "snacks_explorer",
        title = " Explorer ",
        size = { width = 38 },
      },
      {
        ft = "snacks_picker_list",
        title = " Explorer ",
        size = { width = 38 },
      },
      {
        ft = "oil",
        title = " Files ",
        size = { width = 38 },
        filter = function(buf)
          return vim.bo[buf].buftype == "acwrite"
        end,
      },
    },

    right = {},

    bottom = {
      {
        ft = "snacks_terminal",
        size = { height = 0.35 },
        title = "%{b:snacks_terminal.id}: %{b:term_title}",
        filter = function(_buf, win)
          return vim.w[win].snacks_win
            and vim.w[win].snacks_win.position == "bottom"
            and vim.w[win].snacks_win.relative == "editor"
        end,
      },
      { ft = "qf", title = "QUICKFIX", size = { height = 0.25 } },
      {
        ft = "help",
        title = "HELP",
        size = { height = 20 },
        filter = function(buf)
          return vim.bo[buf].buftype == "help"
        end,
      },
      {
        ft = "noice",
        title = "MESSAGES",
        size = { height = 0.25 },
        filter = function(_buf, win)
          return vim.api.nvim_win_get_config(win).relative == ""
        end,
      },
      { ft = "lazy", title = "LAZY", size = { height = 0.4 } },
    },
  },
  config = function(_, opts)
    require("edgy").setup(opts)

    local function set_hl()
      local ok, ui = pcall(require, "akhilesh.ui")
      if not ok then
        return
      end
      local c = ui.colors()
      vim.api.nvim_set_hl(0, "EdgyWinBar", { bg = c.bg_dark, fg = c.blue, bold = true })
      vim.api.nvim_set_hl(0, "EdgyNormal", { bg = c.bg_dark, fg = c.fg })
      vim.api.nvim_set_hl(0, "EdgyBorder", { fg = c.border, bg = c.bg_dark })
    end

    set_hl()
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.schedule(set_hl)
      end,
    })
  end,
}
