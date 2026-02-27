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

vim.g.mapleader = " "
require("lazy").setup({ 
    {import = "plugins"},
    {
      'nvimtools/none-ls.nvim',
      dependencies = { "nvim-lua/plenary.nvim" },
      opts = function()
        local null_ls = require("null-ls")
        local sources = {}

        -- Check for local Prettier
        local prettier_path = vim.fn.getcwd() .. "/node_modules/.bin/prettier"
        if vim.fn.filereadable(prettier_path) == 1 then
          table.insert(sources, null_ls.builtins.formatting.prettier)
        end

        return {
          sources = sources,
        }
      end,
    },
})
