local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = 'mmushrooms.lazy_plugs',
    change_detection = { notify = false },
    --{
    --    "folke/trouble.nvim",
    --    dependencies = { "nvim-tree/nvim-web-devicons" },
    --    opts = {
    --        -- your configuration comes here
    --        -- or leave it empty to use the default settings
    --        -- refer to the configuration section below
    --    },
    --},
    --{
    --    'nvim-treesitter/nvim-treesitter',
    --    build = ':TSUpdate',
    --},
    --{
    --    'ThePrimeagen/harpoon',
    --    branch = "harpoon2",
    --    dependencies = { "nvim-lua/plenary.nvim" },
    --},
    ----'tpope/vim-fugitive',
    --'nvim-treesitter/nvim-treesitter-context',
    --'eandrju/cellular-automaton.nvim',
    ---- For manage the Language Servers from neovim
    --'williamboman/mason.nvim',
    --'williamboman/mason-lspconfig.nvim',
    --{
    --    'VonHeikemen/lsp-zero.nvim',
    --    branch = 'v3.x'
    --},
    ---- LSP support
    --'neovim/nvim-lspconfig',
    ---- Autocompletion
    --'hrsh7th/cmp-nvim-lsp',
    --'hrsh7th/nvim-cmp',
    --'L3MON4D3/LuaSnip',
})
