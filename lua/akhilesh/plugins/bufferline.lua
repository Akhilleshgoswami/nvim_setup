return {
  "akinsho/bufferline.nvim",
  version = "*",
  event = "VeryLazy",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local ui = require("akhilesh.ui")

    ---Delete a buffer without E937 when it is shown in multiple windows.
    local function safe_bufdelete(buf)
      Snacks.bufdelete({ buf = buf })
    end

    vim.api.nvim_create_user_command("BufferPrevious", function()
      vim.cmd("BufferLineCyclePrev")
    end, {})
    vim.api.nvim_create_user_command("BufferNext", function()
      vim.cmd("BufferLineCycleNext")
    end, {})
    vim.api.nvim_create_user_command("BufferClose", function()
      safe_bufdelete(vim.api.nvim_get_current_buf())
    end, {})

    local function set_hl()
      local c = ui.colors()
      local set = vim.api.nvim_set_hl
      set(0, "BufferLineFill", { bg = c.bg_dark })
      set(0, "BufferLineBackground", { fg = c.fg_muted, bg = c.bg_dark })
      set(0, "BufferLineBufferVisible", { fg = c.fg_muted, bg = c.bg_dark })
      set(0, "BufferLineBufferSelected", { fg = c.blue, bg = c.bg_muted, bold = true, italic = true })
      set(0, "BufferLineIndicatorSelected", { fg = c.blue, bg = c.bg_muted })
      set(0, "BufferLineSeparator", { fg = c.bg_dark, bg = c.bg_dark })
      set(0, "BufferLineSeparatorSelected", { fg = c.bg_muted, bg = c.bg_muted })
      set(0, "BufferLineModified", { fg = c.yellow })
      set(0, "BufferLineModifiedSelected", { fg = c.yellow, bold = true })
      set(0, "BufferLineDiagnosticError", { fg = c.red })
      set(0, "BufferLineDiagnosticWarning", { fg = c.yellow })
      set(0, "BufferLineDiagnosticInfo", { fg = c.cyan })
      set(0, "BufferLineDiagnosticHint", { fg = c.green })
      set(0, "BufferLineCloseButton", { fg = c.fg_muted })
      set(0, "BufferLineCloseButtonSelected", { fg = c.red })
    end

    set_hl()
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.schedule(set_hl)
      end,
    })

    require("bufferline").setup({
      options = {
        mode = "buffers",
        separator_style = "thin",
        diagnostics = "nvim_lsp",
        always_show_bufferline = true,
        show_buffer_close_icons = true,
        show_close_icon = false,
        color_icons = true,
        tab_size = 20,
        max_name_length = 24,
        close_command = safe_bufdelete,
        right_mouse_command = safe_bufdelete,
        middle_mouse_command = safe_bufdelete,
        offsets = {
          {
            filetype = "snacks_explorer",
            text = "  Explorer",
            highlight = "Directory",
            separator = true,
          },
          {
            filetype = "snacks_picker_list",
            text = "  Explorer",
            highlight = "Directory",
            separator = true,
          },
          {
            filetype = "oil",
            text = "  Files",
            highlight = "Directory",
            separator = true,
          },
        },
      },
    })
  end,
}
