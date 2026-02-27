return {
    {
        "neovim/nvim-lspconfig",
        tag = "2.6.0",
        config = function()
            vim.lsp.config('lua_ls', {
                settings = {
                    Lua = {
                        runtime = {
                            version = 'LuaJIT'
                        },
                        diagnostics = {
                            globals = {'vim'},
                        },
                        workspace = {
                           library = {
                               vim.env.VIMRUNTIME,
                           },
                        },
                    },
                },
            })
            vim.lsp.enable({
                'lua_ls'
            })

            -- note: diagnostics are not exclusive to lsp servers
            -- so these can be global keybindings
            vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
            vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
            vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')

            vim.api.nvim_create_autocmd('LspAttach', {
                desc = 'LSP actions',
                callback = function(event)
                    local opts = { buffer = event.buf }

                    -- these will be buffer-local keybindings
                    -- because they only work if you have an active language server
                    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
                    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
                    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
                    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
                    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
                    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
                    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
                    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
                    vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
                    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
                end
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
    {
        'nvimtools/none-ls.nvim',
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local null_ls = require("null-ls")
            local sources = {}

            -- Check for local Prettier
            local prettier_path = vim.fn.getcwd() .. "/node_modules/.bin/prettier"
            if vim.fn.filereadable(prettier_path) == 1 then
                table.insert(sources, null_ls.builtins.formatting.prettier)
            end

            null_ls.setup({
                sources = sources,
            })

            local autocmd_group = vim.api.nvim_create_augroup("Format on save", { clear = true })

            local function is_null_ls_available()
                for _, client in ipairs(vim.lsp.get_clients()) do
                    if client.name == "null-ls" then
                        return true
                    end
                end
                return false
            end

            vim.api.nvim_create_autocmd({ "BufWritePost" }, {
                pattern = { "*.js", "*.ts", "*.jsx", "*.tsx", "*.vue", "*.css", "*.scss", "*.html", "*.json", "*.md", "*.rs" },
                callback = function()
                    if not is_null_ls_available() then
                        return
                    end

                    vim.lsp.buf.format({
                        async = false,
                        name = "null-ls"
                    })
                end,
                group = autocmd_group,
            })
        end,
    },
}
