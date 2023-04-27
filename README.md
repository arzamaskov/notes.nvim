# notes.nvim

I really like using Vim for my plain text notes, and VimWiki is usually my go-to plugin for this. However, sometimes I just need a quick way to access my notes without having to go through VimWiki's entire index. That's where notes.nvim comes in!

This plugin lets you instantly display a pop-up window with all your notes and close it just as quickly with the Esc key. And the best part? It automatically reads your VimWiki setup, so there's no complicated installation process or extra configuration needed.

## Requirements

- Neovim versions >= 0.9.0
- Installed plugin VimWiki

## Installation

If you're using [vim-plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'arzamaskov/notes.nvim'
```
Or, if you're using [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use {
    'arzamaskov/notes.nvim'
}
```

## Configuration

Simply call the setup function in your init.lua with your desired settings. Here are the default values:

```lua
require("notes").setup({
    window_style = 'minimal',
    window_border = 'rounded',
    esc_to_quit = true,
    window_title = true,
})

```

- `window_style` can be set to "minimal" or empty string, the default value is "minimal". More details can be found with `:h nvim_open_win`.
- `window_border` can be set to "none", "single", "double", "rounded", "solid", or "shadow". The default value is "rounded". More details can be found with `:h nvim_open_win`.
- `esc_to_quit` can be set to "true" or "false." If set to "true", pressing the `Esc` key will close the pop-up window. The default value is "true".
- `window_title` can be set to "true" or "false". If set to "true", the pop-up window will show the title. The default value is "true".

## Usage

This plugin quickly displays VimWiki notes in a popup window and closes it when the `Esc` key is pressed. Once you install the plugin, the `Notes` command is added, so it is recommended to set a keymapping to this command. `Notes` displays the float window with the VimWiki index file and keeps all functionality of the VimWiki plugin.

It can create new notes in the opened window and edit those ones, all the changes will be saved automatically.
