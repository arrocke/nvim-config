local M = {}

local state = {
  buf = nil,
  win = nil,
}

local function win_width()
  return math.floor(vim.o.columns / 3)
end

local function buf_valid()
  return state.buf ~= nil and vim.api.nvim_buf_is_valid(state.buf)
end

local function win_valid()
  return state.win ~= nil and vim.api.nvim_win_is_valid(state.win)
end

local function open()
  vim.cmd("botright vsplit")
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_width(win, win_width())

  -- Disable visual clutter in the terminal pane
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].signcolumn = "no"

  if buf_valid() then
    vim.api.nvim_win_set_buf(win, state.buf)
  else
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(win, buf)
    vim.fn.jobstart("pi", {
      term = true,
      on_exit = function()
        if vim.api.nvim_buf_is_valid(buf) then
          vim.api.nvim_buf_delete(buf, { force = true })
        end
        state.buf = nil
        state.win = nil
      end,
    })
    state.buf = buf
  end

  state.win = win
  vim.cmd("startinsert")
end

local function hide()
  if win_valid() then
    vim.api.nvim_win_hide(state.win)
    state.win = nil
  end
end

function M.toggle()
  if win_valid() then
    hide()
  else
    open()
  end
end

vim.keymap.set({ "n", "t" }, "<leader>pt", M.toggle, { desc = "Toggle pi terminal" })

return M
