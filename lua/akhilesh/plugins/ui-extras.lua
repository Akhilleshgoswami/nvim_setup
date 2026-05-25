return {
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      filetypes = { "*", "!lazy", "!alpha", "!snacks_dashboard" },
      user_default_options = {
        RGB = true, RRGGBB = true, names = false,
        RRGGBBAA = true, AARRGGBB = true,
        rgb_fn = true, hsl_fn = true,
        css = true, css_fn = true, tailwind = true,
        mode = "background", virtualtext = "■", always_update = true,
      },
    },
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local rd = require("rainbow-delimiters")
      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = rd.strategy["global"],
          vim = rd.strategy["local"],
          commonlisp = rd.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
          tsx = "rainbow-parens",
          jsx = "rainbow-parens",
          html = "rainbow-tags",
          javascript = "rainbow-delimiters-react",
        },
        priority = { [""] = 110, lua = 210 },
        highlight = {
          "RainbowDelimiterRed", "RainbowDelimiterYellow", "RainbowDelimiterBlue",
          "RainbowDelimiterOrange", "RainbowDelimiterGreen", "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }
      local function setup_hl()
        local set = vim.api.nvim_set_hl
        set(0, "RainbowDelimiterRed",    { fg = "#f7768e" })
        set(0, "RainbowDelimiterYellow", { fg = "#e0af68" })
        set(0, "RainbowDelimiterBlue",   { fg = "#7aa2f7" })
        set(0, "RainbowDelimiterOrange", { fg = "#ff9e64" })
        set(0, "RainbowDelimiterGreen",  { fg = "#9ece6a" })
        set(0, "RainbowDelimiterViolet", { fg = "#bb9af7" })
        set(0, "RainbowDelimiterCyan",   { fg = "#7dcfff" })
      end
      setup_hl()
      vim.api.nvim_create_autocmd("ColorScheme", { callback = function() vim.schedule(setup_hl) end })
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "kevinhwang91/promise-async" },
    init = function()
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    keys = {
      { "zR", function() require("ufo").openAllFolds() end, desc = "Open all folds" },
      { "zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds" },
      { "zr", function() require("ufo").openFoldsExceptKinds() end, desc = "Open folds except kinds" },
      { "zp", function() require("ufo").peekFoldedLinesUnderCursor() end, desc = "Peek fold" },
    },
    opts = function()
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = ("  󰁂 %d "):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "UfoFoldedEllipsis" })
        return newVirtText
      end
      return {
        open_fold_hl_timeout = 150,
        close_fold_kinds_for_ft = { default = { "imports", "comment" } },
        preview = {
          win_config = { border = "rounded", winhighlight = "Normal:Folded", winblend = 0 },
          mappings = { scrollU = "<C-u>", scrollD = "<C-d>", jumpTop = "[", jumpBot = "]" },
        },
        provider_selector = function(_, ft, _)
          local ftMap = { vim = "indent", python = { "indent" }, git = "" }
          return ftMap[ft] or { "treesitter", "indent" }
        end,
        fold_virt_text_handler = handler,
      }
    end,
    config = function(_, opts)
      vim.api.nvim_set_hl(0, "UfoFoldedEllipsis", { fg = "#565f89", italic = true })
      vim.api.nvim_set_hl(0, "Folded", { bg = "NONE", fg = "#565f89", italic = true })
      require("ufo").setup(opts)
    end,
  },
}
