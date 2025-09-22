return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    -- LuaSnip
    {
      "L3MON4D3/LuaSnip",
      build = (function()
        if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
          return
        end
        return "make install_jsregexp"
      end)(),
    },
    "saadparwaiz1/cmp_luasnip",  -- LuaSnip integration for nvim-cmp
    "onsails/lspkind.nvim",      -- LSP kind for iconography
    "hrsh7th/cmp-nvim-lsp",     -- LSP completion source
    "hrsh7th/cmp-path",         -- Path completion source
    "mlaursen/vim-react-snippets",  -- React snippets
    { 
      "tzachar/cmp-tabnine",    -- Tabnine integration
      build = "./install.sh", 
      dependencies = { "hrsh7th/nvim-cmp" } 
    },
    {
      "zbirenbaum/copilot-cmp", -- Copilot integration for nvim-cmp
      event = "InsertEnter",
      config = function()
        require("copilot_cmp").setup()  -- Setup copilot-cmp
      end,
      dependencies = {
        {
          "zbirenbaum/copilot.lua", -- GitHub Copilot plugin
          cmd = "Copilot",  -- Copilot will only load when the Copilot command is called
          config = function()
            require("copilot").setup({
              suggestion = { enabled = true },  -- Enable suggestion popup for Copilot
              panel = { enabled = true },       -- Enable the Copilot panel
            })
          end,
        },
      },
    },
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")
    local tabnine = require("cmp_tabnine.config")

    -- Set up LuaSnip
    luasnip.config.setup({})
    require("vim-react-snippets").lazy_load()

    -- Set up Tabnine
    tabnine:setup({
      max_lines = 1000,
      max_num_results = 20,
      sort = true,
      show_prediction_strength = true,
    })

    -- Set up nvim-cmp
    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)  -- Use LuaSnip for snippets
        end,
      },
      view = { entries = "custom" },
      window = {
        completion = {
          border = "rounded",
          winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
          col_offset = -3,
          side_padding = 1,
          max_width = 80,
          max_height = 15,
        },
        documentation = cmp.config.window.bordered(),
      },
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          local kind = lspkind.cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
          local strings = vim.split(kind.kind, "%s", { trimempty = true })
          kind.kind = " " .. (strings[1] or "") .. " "
          kind.menu = "    (" .. (strings[2] or "") .. ")"
          return kind
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.select_next_item(),
        ["<C-j>"] = cmp.mapping.select_prev_item(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace })
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-Space>"] = cmp.mapping.complete(), -- Trigger completion manually
        ["<C-l>"] = cmp.mapping(function()
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { "i", "s" }),
        ["<C-h>"] = cmp.mapping(function()
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = "copilot" },  -- Add GitHub Copilot to the sources
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "cmp_tabnine" },
        { name = "path" },
        { name = "buffer" },
      }),
    })

    -- Load VSCode snippets for LuaSnip
    require("luasnip.loaders.from_vscode").lazy_load()

    -- Auto update Tabnine status
    vim.cmd([[autocmd User TabnineStatusUpdated lua require'cmp_tabnine'.update_status()]])
  end,
}

