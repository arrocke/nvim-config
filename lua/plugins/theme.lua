return {
	{
        "rose-pine/neovim",
        name = "rose-pine",
	    config = function ()
	        vim.cmd("colorscheme rose-pine")
	    end,
    },
	{
        "nvim-treesitter/nvim-treesitter",
        dependencies = { 'nvim-treesitter/nvim-treesitter-context' },
        build = ":TSUpdate",
        config = function ()
            require('nvim-treesitter.configs').setup {
              sync_install = false,
              auto_install = true,
              ensure_installed = {
                  "bash",
                  "html",
                  "css",
                  "javascript",
                  "typescript",
                  "go",
                  "c",
                  "lua",
                  "vim",
                  "vimdoc",
                  "sql",
                  "templ"
              },

              highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
              },
            }

            vim.filetype.add({
                extension = {
                    templ = "templ",
                },
            })

            require('treesitter-context').setup({
              multiline_threshold = 1
            })

            vim.keymap.set("n", "[c", function()
              require("treesitter-context").go_to_context(vim.v.count1)
            end, { silent = true })
        end,
    },
}
