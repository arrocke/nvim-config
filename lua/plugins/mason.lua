return {
    "mason-org/mason.nvim",
    enabled = vim.fn.isdirectory("/etc/nixos") == 0,
    config = function()
        require("mason").setup()
        vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH
    end,
}
