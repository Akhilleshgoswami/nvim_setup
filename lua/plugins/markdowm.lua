local function setup_highlights()
  local function hl(name, attr)
    local ok, h = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
    if not ok or not h[attr] then
      return nil
    end
    return string.format("#%06x", h[attr])
  end

  local colors = {
    bg = hl("Normal", "bg") or "#111111",
    fg = hl("Normal", "fg") or "#cdd6f4",
    blue = hl("Function", "fg") or "#7aa2f7",
    green = hl("String", "fg") or "#9ece6a",
    yellow = hl("Type", "fg") or "#e0af68",
    red = hl("DiagnosticError", "fg") or "#f7768e",
    cyan = hl("Keyword", "fg") or "#7dcfff",
    purple = hl("Statement", "fg") or "#bb9af7",
    comment = hl("Comment", "fg") or "#565f89",
  }

  local set = vim.api.nvim_set_hl

  set(0, "RenderMarkdownH1", { fg = colors.blue, bold = true })
  set(0, "RenderMarkdownH2", { fg = colors.green, bold = true })
  set(0, "RenderMarkdownH3", { fg = colors.yellow, bold = true })
  set(0, "RenderMarkdownH4", { fg = colors.purple, bold = true })
  set(0, "RenderMarkdownH5", { fg = colors.cyan, bold = true })
  set(0, "RenderMarkdownH6", { fg = colors.red, bold = true })

  for _, g in ipairs({ "H1Bg", "H2Bg", "H3Bg", "H4Bg", "H5Bg", "H6Bg" }) do
    set(0, "RenderMarkdown" .. g, { bg = "NONE" })
  end

  set(0, "RenderMarkdownCode", { bg = colors.bg })
  set(0, "RenderMarkdownCodeInline", { fg = colors.green, bg = "NONE" })
  set(0, "RenderMarkdownChecked", { fg = colors.green, bold = true })
  set(0, "RenderMarkdownUnchecked", { fg = colors.comment })
  set(0, "RenderMarkdownTodo", { fg = colors.yellow, bold = true })
end

return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-mini/mini.nvim",
  },
  opts = {
    enabled = true,
    render_modes = true,
    anti_conceal = { enabled = true },
    heading = {
      enabled = true,
      sign = false,
      position = "inline",
      icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
      width = "block",
      left_pad = 1,
      right_pad = 1,
      backgrounds = {
        "RenderMarkdownH1Bg",
        "RenderMarkdownH2Bg",
        "RenderMarkdownH3Bg",
        "RenderMarkdownH4Bg",
        "RenderMarkdownH5Bg",
        "RenderMarkdownH6Bg",
      },
      foregrounds = {
        "RenderMarkdownH1",
        "RenderMarkdownH2",
        "RenderMarkdownH3",
        "RenderMarkdownH4",
        "RenderMarkdownH5",
        "RenderMarkdownH6",
      },
    },
    code = {
      enabled = true,
      sign = false,
      width = "block",
      right_pad = 2,
      left_pad = 2,
      border = "thin",
      above = "▄",
      below = "▀",
      highlight = "RenderMarkdownCode",
      highlight_inline = "RenderMarkdownCodeInline",
    },
    quote = { enabled = true, icon = "▋", repeat_linebreak = false },
    bullet = { enabled = true, icons = { "●", "○", "◆", "◇" } },
    checkbox = {
      enabled = true,
      position = "inline",
      unchecked = { icon = "󰄱 ", highlight = "RenderMarkdownUnchecked" },
      checked = { icon = "󰱒 ", highlight = "RenderMarkdownChecked" },
      custom = {
        todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo" },
      },
    },
    pipe_table = { enabled = true, preset = "round" },
    link = { enabled = true, hyperlink = "󰌹 ", image = "󰥶 ", email = "󰀓 " },
    latex = { enabled = true },
  },
  config = function(_, opts)
    setup_highlights()
    require("render-markdown").setup(opts)

    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.schedule(function()
          setup_highlights()
          require("render-markdown").setup(opts)
        end)
      end,
    })
  end,
}
