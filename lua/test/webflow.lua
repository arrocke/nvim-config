local serverMochaSuffix = '_test.ts'
local serverMochaSuffixJs = '_test.js'
local termWindow
vim.keymap.set('n', '<Leader>rt', function()
    local path = vim.api.nvim_buf_get_name(0)
    local currentWin = vim.api.nvim_get_current_win()
    if string.sub(path, -#serverMochaSuffix) == serverMochaSuffix or string.sub(path, -#serverMochaSuffixJs) == serverMochaSuffixJs then
        if termWindow and vim.api.nvim_win_is_valid(termWindow) then
            vim.api.nvim_set_current_win(termWindow)
        else
            vim.cmd("vsplit")
            vim.cmd("wincmd l")
            termWindow = vim.api.nvim_get_current_win()
        end
        vim.cmd("term source .env && ./bin/babel-mocha " .. path)
        vim.api.nvim_set_current_win(currentWin)
    end
end)
