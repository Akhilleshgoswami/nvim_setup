-- Breadcrumb winbar — dropbar.nvim

return {
  "Bekaboo/dropbar.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "nvim-telescope/telescope-fzf-native.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  opts = function()
    local excluded_ft = {
      "alpha", "dashboard", "nvdash", "starter", "lazy", "mason",
      "help", "toggleterm", "qf", "snacks_dashboard", "edgy", "oil",
    }

    -- Return only safe overrides; dropbar merges these onto its defaults.
    -- Do NOT set icons.kinds.file_icon / dir_icon to booleans — dropbar's
    -- configs.eval() returns non-callable values verbatim, which breaks cat().
    return {
      icons = {
        ui = {
          bar = {
            separator = "  ›  ",
            extends = "…",
          },
          menu = {
            separator = " ",
            indicator = " ",
          },
        },
      },
      bar = {
        enable = function(buf, win)
          if vim.bo[buf].buftype ~= "" then
            return false
          end
          if vim.api.nvim_win_get_config(win).relative ~= "" then
            return false
          end
          return not vim.tbl_contains(excluded_ft, vim.bo[buf].filetype)
        end,
        padding = { left = 2, right = 1 },
        pick = { pivots = "abcdefghijklmnopqrstuvwxyz" },
        truncate = true,
        sources = function(buf, _)
          local sources = require("dropbar.sources")
          local utils = require("dropbar.utils")
          if vim.bo[buf].ft == "markdown" then
            return { sources.path, sources.markdown }
          end
          return {
            sources.path,
            utils.source.fallback({ sources.lsp, sources.treesitter }),
          }
        end,
      },
      menu = {
        quick_navigation = true,
        win_configs = {
          border = "rounded",
          style = "minimal",
          winblend = 8,
          col = 1,
        },
      },
    }
  end,
  config = function(_, opts)
    -- Guard against stale lazy merges that set kinds.* to booleans
    if opts.icons and opts.icons.kinds then
      for key, value in pairs(opts.icons.kinds) do
        if key == "file_icon" or key == "dir_icon" or key == "folder_icon" then
          if not vim.is_callable(value) and type(value) ~= "string" then
            opts.icons.kinds[key] = nil
          end
        end
      end
    end

    require("dropbar").setup(opts)

    local dropbar_api = require("dropbar.api")

    local function set_hl()
      local ok, ui = pcall(require, "akhilesh.ui")
      if not ok then
        return
      end
      local c = ui.colors()
      local set = vim.api.nvim_set_hl
      set(0, "DropBarIconUISeparator", { fg = c.fg_muted, bg = "NONE" })
      set(0, "DropBarFileName", { fg = c.fg, bg = "NONE" })
      set(0, "DropBarFileNameModified", { fg = c.yellow, bg = "NONE", italic = true })
      set(0, "DropBarMenuCurrentContext", { bg = c.bg_muted, bold = true })
      set(0, "DropBarIconUIPickPivot", { fg = c.pink, bold = true, bg = "NONE" })
      set(0, "DropBarKindFunction", { fg = c.blue, bg = "NONE" })
      set(0, "DropBarKindMethod", { fg = c.blue, bg = "NONE" })
      set(0, "DropBarKindClass", { fg = c.purple, bg = "NONE" })
      set(0, "DropBarKindVariable", { fg = c.cyan, bg = "NONE" })
      set(0, "DropBarKindString", { fg = c.green, bg = "NONE" })
      set(0, "DropBarKindFolder", { fg = c.yellow, bg = "NONE" })
      set(0, "DropBarMenuNormalFloat", { bg = c.bg_float, fg = c.fg })
      set(0, "DropBarMenuFloatBorder", { bg = c.bg_float, fg = c.border })
      set(0, "DropBarMenuHoverEntry", { bg = c.bg_muted, fg = c.cyan, bold = true })
    end

    set_hl()
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.schedule(set_hl)
      end,
    })

    vim.keymap.set("n", "<leader>;", dropbar_api.pick, { desc = "Breadcrumbs pick", silent = true })
    vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Context start", silent = true })
    vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Next context", silent = true })
  end,
}
