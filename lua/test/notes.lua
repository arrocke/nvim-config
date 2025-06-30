function scaffold_note()
    local note_title = vim.fn.input("Enter the note title: ")
    if note_title == "" then
        print ("Title cannot be empty")
        return
    end

    -- Create the file from the note name
    local filename = note_title:lower():gsub("%s+", "-") .. '.md'
    vim.cmd("edit " .. filename)

    local uuid = vim.fn.system("uuidgen"):gsub("%s+", "")
    local timestamp = os.date("%Y-%m-%dT%H:%M:%S")

    local frontmatter = {
        "id: " .. uuid,
        "timestamp: " .. timestamp,
        "tags: ",
        "",
        "# " .. note_title
    }
    vim.api.nvim_buf_set_lines(0, 0, 0, false, frontmatter)

    -- Move cursor to after the heading symbol
    local row = #frontmatter
    local col = #frontmatter[row]
    vim.api.nvim_win_set_cursor(0, {row, col})
end

vim.api.nvim_set_keymap(
  'n',
  '<leader>kn',
  [[:lua scaffold_note()<CR>]],
  { noremap = true, silent = true }
)

