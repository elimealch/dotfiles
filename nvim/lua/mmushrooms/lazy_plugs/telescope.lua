return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { 'plenary' },
    name = 'telescope',
    priority = 1000,
    config = function()
        require('telescope').setup({
            file_ignore_patterns = { 'node%_modules/.*' },
        })

        local builtin = require('telescope.builtin')

    end,
}
