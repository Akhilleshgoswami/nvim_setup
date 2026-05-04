return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup({
      options = {
        theme = 'zenburn',
        section_separators = { left = '', right = '' },
        component_separators = { left = '│', right = '│' },
        globalstatus = true,
        icons_enabled = true,
        disabled_filetypes = { 'NvimTree', 'neo-tree' },
      },
      sections = {
        lualine_a = {
          { 'mode', icon = '' },
        },
        lualine_b = {
          { 'branch', icon = '' },
          { 'diff', symbols = { added = '+', modified = '~', removed = '-' } },
        },
        lualine_c = {
          {
            'filename',
            path = 1, -- relative
            symbols = { modified = ' ●', readonly = ' 🔒', unnamed = '[No Name]' },
          },
        },
        lualine_x = {
          {
            'diagnostics',
            sources = { 'nvim_diagnostic' },
            symbols = { error = ' ', warn = ' ', info = ' ', hint = '󰌵 ' },
          },
          'encoding',
          'fileformat',
          'filetype',
        },
        lualine_y = {
          { 'progress' },
        },
        lualine_z = {
          { 'location', icon = '' },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { 'nvim-tree', 'fzf', 'quickfix' },
    })
  end,
}

