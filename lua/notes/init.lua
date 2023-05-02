local M = {}

M.config = {}

local default_config = {
    window_style = 'minimal',
    window_border = 'rounded',
    esc_to_quit = true,
    window_title = true,
    window_width = 75,
    window_height = 75,
}

local vimwiki_list = vim.api.nvim_get_var("vimwiki_list")

local function get_file_path(vimwiki_config)
    local extension = vimwiki_config[1].ext
    local file_name = vimwiki_config[1].index
    local path = vim.fn.expand(vimwiki_config[1].path)

    return path .. file_name .. extension
end

local function check_vimwiki_config(t, keys)
    for _, key in ipairs(keys) do
        if t[key] == nil or t[key] == "" then
            return false
        end
    end
    return true
end

local function check_dependencies(conf)
    if conf == nil then
        error('Please, install the VimWiki plugin: https://github.com/vimwiki/vimwiki#installation')
    end

    local required_keys = { 'ext', 'index', 'path' }
    if check_vimwiki_config(conf[1], required_keys) == false then
        error('Something wrong with your VimWiki config')
    end

    return true
end

local function is_window_sizes_valid(sizes)
    if sizes.window_width <= 0 or sizes.window_width >= 100 then
        return false
    end

    if sizes.window_height <= 0 or sizes.window_height >= 100 then
        return false
    end

    return true
end

local function open_window()
    local file_path = get_file_path(vimwiki_list)
    local ui = vim.api.nvim_list_uis()[1]
    local width = math.floor((ui.width * 0.5) + 0.5)
    local height = math.floor((ui.height * 0.5) + 0.5)

    if is_window_sizes_valid(M.config) then
        width = math.floor((ui.width * M.config.window_width / 100) + 0.5)
        height = math.floor((ui.height * M.config.window_height / 100) + 0.5)
    end

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

    local win_id = vim.api.nvim_open_win(buf, true, opts)

    vim.cmd('edit ' .. file_path)
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')

    if M.config.esc_to_quit then
        vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', '<cmd>wq<CR>', { noremap = true, silent = false })
    end

    return win_id
end

M.setup = function(config)
    M.config = vim.tbl_deep_extend('force', default_config, config or {})

    vim.api.nvim_create_user_command('Notes', function(opts)
        if check_dependencies(vimwiki_list) then
            local win_id = open_window()
            vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
                callback = function()
                    local buf = vim.api.nvim_get_current_buf()
                    local buf_data = vim.fn.getbufinfo(buf)
                    for _, value in pairs(buf_data) do
                        if win_id == value.windows[1] then
                            vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', '<cmd>wq<CR>', { noremap = true, silent = false })
                        end
                    end
                end
            })
        end
    end, {})
end

return M
