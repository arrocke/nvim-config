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
            require("nvim-treesitter").install({
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
                "templ",
            })

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
