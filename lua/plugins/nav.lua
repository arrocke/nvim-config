return {
	{
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function ()
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
            vim.keymap.set('n', '<C-p>', builtin.git_files, {})
            vim.keymap.set('n', '<leader>ps', function()
                builtin.grep_string({ search = vim.fn.input("Grep > ") });
            end)
            vim.keymap.set('n', '<leader>psl', builtin.live_grep, {})
            vim.keymap.set('n', '<leader>pr', builtin.resume, {})
        end,
    },
	{
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function ()
            local harpoon = require("harpoon")
            local extensions = require("harpoon.extensions")

            harpoon:setup()
            harpoon:extend(extensions.builtins.command_on_nav("UfoEnableFold"))

            vim.keymap.set("n", "<leader>a", function() harpoon:list():append() end)
            vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

            vim.keymap.set("n", "<C-j>", function() harpoon:list():select(1) end)
            vim.keymap.set("n", "<C-k>", function() harpoon:list():select(2) end)
            vim.keymap.set("n", "<C-l>", function() harpoon:list():select(3) end)
            vim.keymap.set("n", "<C-;>", function() harpoon:list():select(4) end)
        end,
    },
	{
        "tpope/vim-fugitive",
        config = function ()
            vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
        end
    },
	{
        "mbbill/undotree",
        config = function ()
            vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
        end
    },
    {
      'nvim-mini/mini.diff',
      version = false,
      config = function()
        require("mini.diff").setup({
          source = require("mini.diff").gen_source.git(),
        })
      end,
    },
}
