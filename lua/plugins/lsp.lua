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
        "saghen/blink.cmp",
        tag = "v1.9.1",
        opts = {
            keymap = { preset = 'super-tab' },
            fuzzy = { implementation = "lua" }
        },
    },
}
