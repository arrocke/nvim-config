local function ensure_trailing_slash(path)
    return path:sub(-1) == "/" and path or (path .. "/")
end

local function get_relative_path(path)
    local cwd = vim.fn.getcwd()
    cwd = cwd:gsub("[/\\]+$", "") -- remove trailing slashes
    return path:gsub("^" .. vim.pesc(cwd) .. "[/\\]?", "")
end

function scaffold_note()
    local note_title = vim.fn.input("Enter the note title: ")
    if note_title == "" then
        print ("Title cannot be empty")
        return
    end

    local note_path = vim.fn.input("Enter the path to store the note: ")
    vim.fn.mkdir(note_path, "p")

    -- Create the file from the note name
    local filename = ensure_trailing_slash(note_path) .. note_title:lower():gsub("%s+", "-") .. '.md'
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

function save_note() 
    local filepath = vim.api.nvim_buf_get_name(0)

    if filepath == "" then
        vim.notify("No changes to save") 
        return
    end

    if vim.bo.modified then
        vim.cmd("write")
    end

    local function run(cmd)
        local handle = io.popen(cmd .. " 2>&1")
        local result = handle:read("*a")
        handle:close()
        return result
    end

    if run("git status --porcelain") == "" then
        vim.notify("No changes to save") 
        return
    end

    local relative_filepath = get_relative_path(filepath)

    run("git pull")
    run("git add " .. vim.fn.shellescape(filepath))
    run("git commit -m " .. vim.fn.shellescape("Update " .. get_relative_path(relative_filepath)))
    run("git push")

    vim.notify("Saved: " .. relative_filepath) 
end

vim.api.nvim_set_keymap(
  'n',
  '<leader>kn',
  [[:lua scaffold_note()<CR>]],
  { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
  'n',
  '<leader>ks',
  [[:lua save_note()<CR>]],
  { noremap = true, silent = true }
)
