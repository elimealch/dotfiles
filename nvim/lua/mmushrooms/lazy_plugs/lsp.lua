--[[
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)

-- here you can setup the language servers 
require('lspconfig').clangd.setup({})
require('lspconfig').cmake.setup({})
require('lspconfig').rust_analyzer.setup({
    settings = {
        ['rust-analyzer'] = {
            diagnostics = {
                enable = false,
            }
        }
    }
})
--]]

return {
    -- LSP support
    'neovim/nvim-lspconfig',
    dependencies = {
        -- Language Servers management from neovim
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        -- Autocompletion
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/nvim-cmp',
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip',
        'j-hui/fidget.nvim',
    },
    config = function()
        local cmp = require('cmp')
        local cmplsp = require('cmp_nvim_lsp')
        local capabilities = vim.tbl_deep_extend(
            'force',
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmplsp.default_capabilities()
        )

        require('fidget').setup()
        require('mason').setup()
        require('mason-lspconfig').setup({
            ensure_installed = {
                'clangd',
                'rust_analyzer',
                'lua_ls',
            },

            handlers = {
                -- Default handler (will be called for each
                -- server that doesn't have a dedicated handler).
                function(server_name)
                    require('lspconfig')[server_name].setup({
                        capabilities = capabilities,
                    })
                end,

                ['lua_ls'] = function()
                    local lspconfig = require('lspconfig')
                    lspconfig.lua_ls.setup({
                        capcabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = {
                                    version = 'LuaJIT',
                                    --path = vim.split(package.path, ';'),
                                },
                                diagnostics = {
                                    globals = {
                                        'vim', 'it', 'describe',
                                        'before_each', 'after_each',
                                        'awesome',
                                    }
                                }
                                --workspace = {

                            }
                        },
                        --root_dir = function(fname)
                        --    local util = require("lspconfig.util")
                        --    local root = util.root_pattern(fname
                    })
                end,
            }
        })

        cmp.setup({
            snippet = {
                -- REQUIRED - you must specify a snippet engine
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },

            mapping = cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            }),

            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
        })

        -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline({ '/', '?' }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = 'buffer' }
            }
        })

        -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = 'path' }
            }, {
                { name = 'cmdline' }
            })
        })
        -- Setup language servers.
        --local lspconfig = require('lspconfig')
        --lspconfig.pyright.setup({})
        --lspconfig.rust_analyzer.setup({
            --    -- Server-specific settings. See `:help lspconfig-setup`
            --    settings = {
                --        ['rust-analyzer'] = {},
                --    },
                --})
                --lspconfig.clangd.setup({})
                --lspconfig.cmake.setup({})

                -- Global mappings.
                -- See `:help vim.diagnostic.*` for documentation on any of the below functions
                --vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
                --vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
                --vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
                --vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
            end,
}
