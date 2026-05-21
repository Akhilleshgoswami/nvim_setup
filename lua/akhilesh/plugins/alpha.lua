-- lua/akhilesh/plugins/dropbar.lua

return {
  {
    "Bekaboo/dropbar.nvim",
    -- dropbar requires nvim 0.10+
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      general = {
        enable = function(buf, win, _)
          -- Enable dropbar for normal buffers only
          return vim.api.nvim_buf_is_valid(buf)
            and vim.api.nvim_win_is_valid(win)
            and vim.wo[win].winbar == ""
            and vim.bo[buf].bt == ""
            and (
              vim.bo[buf].ft == "markdown"
              or (
                buf ~= vim.api.nvim_get_current_buf()
                or (
                  vim.fn.win_gettype(win) == ""
                  and vim.wo[win].diff == false
                )
              )
            )
        end,
        attach_events = {
          "OptionSet",
          "BufWinEnter",
          "BufWritePost",
        },
        -- update when cursor moves (show current context)
        update_events = {
          win = {
            "CursorMoved",
            "CursorMovedI",
            "WinEnter",
            "WinResized",
          },
          buf = {
            "BufModifiedSet",
            "FileChangedShellPost",
            "TextChanged",
            "ModeChanged",
          },
          global = {
            "DirChanged",
            "VimResized",
          },
        },
      },

      icons = {
        enable = true,
        kinds = {
          use_devicons = true,   -- use nvim-web-devicons for file icons
        },
        ui = {
          bar = {
            separator = "  ",  -- between breadcrumb segments (nv-ide uses arrow style)
            extends   = "…",
          },
          menu = {
            separator  = " ",
            indicator  = " ",
          },
        },
      },

      bar = {
        -- tokyonight-night compatible highlights
        sources = function(buf, _)
          local sources = require("dropbar.sources")
          local utils   = require("dropbar.utils")
          if vim.bo[buf].ft == "markdown" then
            return {
              sources.path,
              utils.source.fallback({
                sources.treesitter,
                sources.markdown,
                sources.lsp,
              }),
            }
          end
          if vim.bo[buf].buftype == "terminal" then
            return { sources.terminal }
          end
          return {
            sources.path,
            utils.source.fallback({
              sources.lsp,
              sources.treesitter,
            }),
          }
        end,
        padding    = { left = 1, right = 1 },
        pick       = { pivots = "abcdefghijklmnopqrstuvwxyz" },
        truncate   = true,
      },

      menu = {
        -- Quick-pick with letters
        quick_navigation = true,
        entry = {
          padding = { left = 1, right = 1 },
        },
        -- Close menu on these events
        win_configs = {
          border  = "rounded",
          style   = "minimal",
          zindex  = 60,
        },
        keymaps = {
          ["<MouseMove>"]   = function() require("dropbar.api").get_current_dropbar_menu():update_hover_hl() end,
          ["<LeftMouse>"]   = function() require("dropbar.api").get_current_dropbar_menu():click_on(unpack(vim.fn.getmousepos())) end,
          ["q"]             = function() require("dropbar.api").get_current_dropbar_menu():close() end,
          ["<Esc>"]         = function() require("dropbar.api").get_current_dropbar_menu():close() end,
          ["<CR>"]          = function()
            local menu = require("dropbar.api").get_current_dropbar_menu()
            if not menu then return end
            local cursor = vim.api.nvim_win_get_cursor(menu.win)
            local component = menu.entries[cursor[1]]:first_clickable(0)
            if component then menu:click_on(component, nil, 1, "l") end
          end,
          ["i"] = function()
            local menu = require("dropbar.api").get_current_dropbar_menu()
            if not menu then return end
            local cursor = vim.api.nvim_win_get_cursor(menu.win)
            local component = menu.entries[cursor[1]]:first_clickable(0)
            if component then menu:click_on(component, nil, 1, "l") end
          end,
          ["<MouseMove>"] = function()
            local menu = require("dropbar.api").get_current_dropbar_menu()
            if not menu then return end
            menu:update_hover_hl()
          end,
        },
      },
    },
    keys = {
      { "<leader>;", function() require("dropbar.api").pick() end, desc = "Breadcrumbs Pick" },
    },
  },
}
