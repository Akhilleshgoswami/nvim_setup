return {
  -- =========================================================
  -- COLORIZER
  -- =========================================================
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },

    opts = {
      filetypes = {
        "*",
        "!lazy",
        "!alpha",
        "!snacks_dashboard",
      },

      user_default_options = {
        RGB = true,
        RRGGBB = true,
        names = false,
        RRGGBBAA = true,
        AARRGGBB = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        tailwind = true,

        -- cleaner vscode-like color blocks
        mode = "background",

        virtualtext = "󱓻",

        always_update = true,
      },
    },
  },

  -- =========================================================
  -- RAINBOW DELIMITERS
  -- =========================================================
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufReadPost", "BufNewFile" },

    config = function()
      local rd = require("rainbow-delimiters")

      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = rd.strategy["global"],
          vim = rd.strategy["local"],
        },

        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
          javascript = "rainbow-delimiters-react",
          jsx = "rainbow-parens",
          tsx = "rainbow-parens",
          html = "rainbow-tags",
        },

        priority = {
          [""] = 110,
          lua = 210,
        },

        highlight = {
          "RainbowDelimiter1",
          "RainbowDelimiter2",
          "RainbowDelimiter3",
          "RainbowDelimiter4",
          "RainbowDelimiter5",
          "RainbowDelimiter6",
          "RainbowDelimiter7",
        },
      }

      local function setup_hl()
        local set = vim.api.nvim_set_hl

        -- subtle modern colors
        set(0, "RainbowDelimiter1", { fg = "#7aa2f7" })
        set(0, "RainbowDelimiter2", { fg = "#9ece6a" })
        set(0, "RainbowDelimiter3", { fg = "#e0af68" })
        set(0, "RainbowDelimiter4", { fg = "#bb9af7" })
        set(0, "RainbowDelimiter5", { fg = "#7dcfff" })
        set(0, "RainbowDelimiter6", { fg = "#ff9e64" })
        set(0, "RainbowDelimiter7", { fg = "#f7768e" })
      end

      setup_hl()

      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          vim.schedule(setup_hl)
        end,
      })
    end,
  },

  -- =========================================================
  -- UFO FOLDING
  -- =========================================================
  {
    "kevinhwang91/nvim-ufo",
    event = { "BufReadPost", "BufNewFile" },

    dependencies = {
      "kevinhwang91/promise-async",
    },

    init = function()
      -- folds
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      -- CLEAN LEFT SIDE
      vim.o.foldcolumn = "0"

      -- ONLY numbers
      vim.o.number = true
      vim.o.relativenumber = true

      vim.o.signcolumn = "no"
      vim.o.statuscolumn = ""
    end,

    keys = {
      {
        "zR",
        function()
          require("ufo").openAllFolds()
        end,
        desc = "Open all folds",
      },

      {
        "zM",
        function()
          require("ufo").closeAllFolds()
        end,
        desc = "Close all folds",
      },

      {
        "zr",
        function()
          require("ufo").openFoldsExceptKinds()
        end,
        desc = "Open folds except kinds",
      },

      {
        "zp",
        function()
          local winid = require("ufo").peekFoldedLinesUnderCursor()

          if not winid then
            vim.lsp.buf.hover()
          end
        end,
        desc = "Peek fold",
      },
    },

    opts = function()
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}

        local suffix = ("  󰁂 %d lines "):format(endLnum - lnum)
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

            table.insert(newVirtText, {
              chunkText,
              chunk[2],
            })

            chunkWidth = vim.fn.strdisplaywidth(chunkText)

            if curWidth + chunkWidth < targetWidth then
              suffix =
                suffix
                .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end

            break
          end

          curWidth = curWidth + chunkWidth
        end

        table.insert(newVirtText, {
          suffix,
          "UfoFoldedEllipsis",
        })

        return newVirtText
      end

      return {
        open_fold_hl_timeout = 150,

        close_fold_kinds_for_ft = {
          default = {
            "imports",
            "comment",
          },
        },

        preview = {
          win_config = {
            border = "rounded",
            winblend = 0,

            winhighlight =
              "Normal:NormalFloat,FloatBorder:FloatBorder",
          },

          mappings = {
            scrollU = "<C-u>",
            scrollD = "<C-d>",
            jumpTop = "[",
            jumpBot = "]",
          },
        },

        provider_selector = function(_, ft)
          local ftMap = {
            vim = "indent",
            python = { "indent" },
            git = "",
          }

          return ftMap[ft] or {
            "treesitter",
            "indent",
          }
        end,

        fold_virt_text_handler = handler,
      }
    end,

    config = function(_, opts)
      local set = vim.api.nvim_set_hl

      -- folded text
      set(0, "Folded", {
        fg = "#565f89",
        bg = "NONE",
        italic = true,
      })

      set(0, "UfoFoldedEllipsis", {
        fg = "#7aa2f7",
        bg = "NONE",
        italic = true,
      })

      -- clean numbers
      set(0, "LineNr", {
        fg = "#414868",
        bg = "NONE",
      })

      set(0, "CursorLineNr", {
        fg = "#7aa2f7",
        bold = true,
        bg = "NONE",
      })

      set(0, "CursorLine", {
        bg = "#16161e",
      })

      set(0, "SignColumn", {
        bg = "NONE",
      })

      set(0, "FoldColumn", {
        bg = "NONE",
      })

      set(0, "NormalFloat", {
        bg = "#16161e",
      })

      set(0, "FloatBorder", {
        fg = "#2f334d",
        bg = "#16161e",
      })

      require("ufo").setup(opts)
    end,
  },
}

