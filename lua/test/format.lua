local autocmd_group = vim.api.nvim_create_augroup("Format on save", { clear = true })

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    pattern = { "*.js", "*.ts", "*.jsx", "*.tsx", "*.vue", "*.css", "*.scss", "*.html", "*.json", "*.md" },
    desc = "Auto-format with Prettier after saving",
    callback = function()
        local fileName = vim.api.nvim_buf_get_name(0)
        vim.cmd(":silent !npx prettier " .. fileName .. " --write --log-level silent")
    end,
    group = autocmd_group,
})
