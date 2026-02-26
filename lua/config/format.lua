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
