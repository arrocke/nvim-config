local autocmd_group = vim.api.nvim_create_augroup("Format on save", { clear = true })

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    pattern = { "*.js", "*.ts", "*.jsx", "*.tsx", "*.vue", "*.css", "*.scss", "*.html", "*.json", "*.md", "*.rs" },
    callback = function()
        vim.lsp.buf.format({
            async = false,
            filter = function(client)
                return client.name == "null-ls"
            end,
        })
    end,
    group = autocmd_group,
})
