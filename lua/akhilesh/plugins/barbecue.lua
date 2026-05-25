return {
  "Bekaboo/dropbar.nvim",

  event = {
    "BufReadPre",
    "BufNewFile",
  },

  dependencies = {
    "nvim-telescope/telescope-fzf-native.nvim",
    "nvim-tree/nvim-web-devicons",
  },

  config = function()
    local dropbar_api = require("dropbar.api")

    require("dropbar").setup({
      general = {
        enable = function(buf, win)
          local ft = vim.bo[buf].filetype
          local bt = vim.bo[buf].buftype

          if bt ~= "" then
            return false
          end

          local excluded = {
            "alpha",
            "dashboard",
            "starter",
            "lazy",
            "mason",
            "help",
            "toggleterm",
            "neo-tree",
            "NvimTree",
            "Trouble",
            "oil",
            "qf",
            "snacks_dashboard",
            "edgy",
          }

          return not vim.tbl_contains(excluded, ft)
        end,
      },

      icons = {
        enable = true,
        ui = {
          bar = {
            separator = "  ",
          },
        },
      },

      bar = {
        padding = {
          left = 1,
          right = 1,
        },

        sources = function(buf, _)
          local sources = require("dropbar.sources")
          local utils = require("dropbar.utils")

          if vim.bo[buf].ft == "markdown" then
            return {
              sources.path,
              sources.markdown,
            }
          end

          return {
            sources.path,
            utils.source.fallback({
              sources.lsp,
              sources.treesitter,
            }),
          }
        end,
      },
    })

    vim.keymap.set("n", "<leader>;", dropbar_api.pick, {
      desc = "Dropbar pick",
    })

    vim.keymap.set("n", "[;", dropbar_api.goto_context_start, {
      desc = "Context start",
    })

    vim.keymap.set("n", "];", dropbar_api.select_next_context, {
      desc = "Next context",
    })
  end,
}
