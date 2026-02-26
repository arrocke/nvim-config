return {
    {
	    "neovim/nvim-lspconfig",
        tag = "2.6.0",
        config = function()
            vim.lsp.enable({
                'lua_ls'
            })
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        tag = "v0.0.2",
        opts = function()
            local cmp = require('cmp')
            return {
                sources = {
                    {name = 'nvim_lsp'},
                },
                mapping = cmp.mapping.preset.insert({
                    ['<CR>'] = cmp.mapping.confirm({select = false}),
                    ['<C-Space>'] = cmp.mapping.complete(),
                }),
                snippet = {
                    expand = function(args)
                      require('luasnip').lsp_expand(args.body)
                    end,
                },
            }
        end,
        config = function()
            vim.lsp.config('*', {
                capabilities = require('cmp_nvim_lsp').default_capabilities()
            })
        end,
        dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip" },
    },
}
