local M = {}

local config = {
    window_style = 'minimal',
    window_border = 'rounded',
    q_to_quit = true,
    window_title = true,
}

local function open_window()
    local ui = vim.api.nvim_list_uis()[1]
    local width = math.floor((ui.width * 0.5) + 0.5)
    local height = math.floor((ui.height * 0.5) + 0.5)

    -- Create the scratch buffer displayed in the floating window
    local buf = vim.api.nvim_create_buf(false, true)

    local lines = { 'Hello' }
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    -- Set mappings in the buffer to close the window easily
    local closingKeys = { '<Esc>', '<CR>', '<Leader>' }
    for _, closingKey in ipairs(closingKeys) do
        vim.api.nvim_buf_set_keymap(buf, 'n', closingKey, ':close<CR>',
            { silent = true, nowait = true, noremap = true })
    end

    -- Create the floating window
    local opts = {
        relative = 'editor',
        width = width,
        height = height,
        col = math.floor(ui.width / 2 - width / 2),
        row = math.floor(ui.height / 2 - height / 2),
        focusable = true,
        anchor = 'NW',
        style = config.window_style,
        border = config.window_border
    }
    local win = vim.api.nvim_open_win(buf, true, opts)

    -- Change highlighting
    vim.api.nvim_win_set_option(win, 'winhl', 'Normal:ErrorFloat')
end

open_window()
return M
