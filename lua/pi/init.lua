local M = {}

local state = {
  buf = nil,
  win = nil,
  chan = nil,
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
    local chan = vim.fn.jobstart("pi", {
      term = true,
      on_exit = function()
        if vim.api.nvim_buf_is_valid(buf) then
          vim.api.nvim_buf_delete(buf, { force = true })
        end
        state.buf = nil
        state.win = nil
        state.chan = nil
      end,
    })
    vim.api.nvim_create_autocmd("BufEnter", {
      buffer = buf,
      callback = function() vim.cmd("startinsert") end,
    })

    state.buf = buf
    state.chan = chan
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

function M.focus()
  if not win_valid() then
    open()
  else
    vim.api.nvim_set_current_win(state.win)
  end
end

function M.send_selection()
  local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
  local is_new = not buf_valid()

  -- getpos("v") is the visual anchor and getpos(".") is the cursor;
  -- both are valid while visual mode is still active (before scheduling).
  local anchor = vim.fn.getpos("v")
  local cursor = vim.fn.getpos(".")
  local start_line = math.min(anchor[2], cursor[2])
  local end_line = math.max(anchor[2], cursor[2])
  local text = path .. ":" .. start_line .. "-" .. end_line

  vim.schedule(function()
    if not win_valid() then
      open()
    else
      vim.api.nvim_set_current_win(state.win)
      vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes("<C-\\><C-n>i", true, false, true),
        "n",
        false
      )
    end

    local function do_send()
      if state.chan then
        vim.fn.chansend(state.chan, "\27[200~" .. text .. "\27[201~")
      end
    end

    -- A brand-new pi process needs a moment to render its input prompt
    -- before it can accept paste input.
    if is_new then
      vim.defer_fn(do_send, 200)
    else
      do_send()
    end
  end)
end

vim.keymap.set("n", "<leader>pf", M.focus, { desc = "Focus pi terminal" })
vim.keymap.set({ "n", "t" }, "<leader>pt", M.toggle, { desc = "Toggle pi terminal" })
vim.keymap.set("x", "<leader>py", M.send_selection, { desc = "Send selection to pi" })

-- Navigate out of terminals to other windows
for _, key in ipairs({ "w", "h", "j", "k", "l" }) do
  vim.keymap.set("t", "<C-w>" .. key, "<C-\\><C-n><C-w>" .. key)
end

return M
