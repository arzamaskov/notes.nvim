local M = {}

M.config = {}

local default_config = {
    window_style = 'minimal',
    window_border = 'rounded',
    esc_to_quit = true,
    window_title = true,
}

local vimwiki_list = vim.api.nvim_get_var("vimwiki_list")

local function get_file_path(vimwiki_config)
    local extension = vimwiki_config[1].ext
    local file_name = vimwiki_config[1].index
    local path = vim.fn.expand(vimwiki_config[1].path)

    return path .. file_name .. extension
end

local function open_window()
    local file_path = get_file_path(vimwiki_list)
    local ui = vim.api.nvim_list_uis()[1]
    local width = math.floor((ui.width * 0.5) + 0.5)
    local height = math.floor((ui.height * 0.5) + 0.5)

    local buf = vim.api.nvim_create_buf(false, true)

    local opts = {
        relative = 'editor',
        width = width,
        height = height,
        col = math.floor(ui.width / 2 - width / 2),
        row = math.floor(ui.height / 2 - height / 2),
        focusable = true,
        anchor = 'NW',
        style = M.config.window_style,
        border = M.config.window_border
    }

    local title = "VimWiki"
    if M.config.window_title then
        opts.title = title
        if M.config.esc_to_quit then
            opts.title = opts.title .. " - press 'Esc' to quit"
        end
        opts.title_pos = "center"
    end

    local win = vim.api.nvim_open_win(buf, true, opts)

    vim.cmd('edit ' .. file_path)
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')

    if M.config.esc_to_quit and win then
        vim.keymap.set('n', '<Esc>', function()
            if vim.api.nvim_win_is_valid(win) then
                vim.cmd('quit')
            end
        end)
    end
end

M.setup = function(config)
    M.config = vim.tbl_deep_extend('force', default_config, config or {})

    vim.api.nvim_create_user_command('Notes', function(opts)
        if check_dependencies(vimwiki_list) then
            open_window()
        end
    end, {
        nargs = '?',
        complete = function(ArgLead, CmdLine, CursorPos)
            return { 'global', 'manage' }
        end
    })
end

return M
