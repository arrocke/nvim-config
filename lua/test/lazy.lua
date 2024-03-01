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
	{ 'nvim-telescope/telescope.nvim', tag = '0.1.5', dependencies = { 'nvim-lua/plenary.nvim' } },
	{ "rose-pine/neovim", name = "rose-pine" },
	{"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
	{ "ThePrimeagen/harpoon", branch = "harpoon2", dependencies = { "nvim-lua/plenary.nvim" } },
	{ "mbbill/undotree" },
	{ "tpope/vim-fugitive" }
})
