return {

    '2kabhishek/seeker.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    cmd = { 'Seeker' },
    keys = {
        { '<leader>fa', ':Seeker files<CR>', desc = 'Seek Files' },
        { '<leader>gf', ':Seeker git_files<CR>', desc = 'Seek Git Files' },
        { '<leader>fg', ':Seeker grep<CR>', desc = 'Seek Grep' },
        { '<leader>fw', ':Seeker grep_word<CR>', desc = 'Seek Grep Word' },
    },
    opts = {
        picker_provider = 'telescope',
    },
}

