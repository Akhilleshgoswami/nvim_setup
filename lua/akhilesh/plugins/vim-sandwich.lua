
return {


  return {
  "machakann/vim-sandwich",
  event = "VeryLazy",

  config = function()
    vim.cmd([[
      runtime macros/sandwich/keymap/surround.vim

      xmap iss <Plug>(textobj-sandwich-auto-i)
      xmap ass <Plug>(textobj-sandwich-auto-a)

      omap iss <Plug>(textobj-sandwich-auto-i)
      omap ass <Plug>(textobj-sandwich-auto-a)
    ]])

    vim.g["sandwich#recipes"] = vim.list_extend(
      vim.g["sandwich#recipes"] or {},
      {
        {
          buns = { "<%= ", " %>" },
          filetype = { "eruby" },
          input = { "=" },
          nesting = 1,
        },
        {
          buns = { "<% ", " %>" },
          filetype = { "eruby" },
          input = { "-" },
          nesting = 1,
        },
        {
          buns = { "<%# ", " %>" },
          filetype = { "eruby" },
          input = { "#" },
          nesting = 1,
        },
      }
    )
  end,
}
}
