# My Dotfiles
These are my dotfiles for nvim, bash and tmux.

## Requirements
 - Neovim Nightly (0.5+)
 - [Vim-Plug](https://github.com/junegunn/vim-plug)

## Installation
The installation for these relies on symlinks, I shall list the required ones below
 - `~/.config/nvim` -> `nvim`
 - `~/.config/zathura` -> `zathura`
 - `~/.config/neofetch` -> `neofetch`
 - `~/.bashrc` -> `bash/.bashrc`
 - `~/.bash_profile` -> `bash/.bash_profile`
 - `~/.local/share/nvim/site/ftplugin` -> `nvim/ftplugin`
 - `~/.config/coc/ultisnips` -> `nvim/snippets`
 - `~/.tmux.conf` -> `.tmux.conf`

You can create a file `~/.personalbashrc` to add personal bash commands. I have aliases to get around my file system quicker.

For the awesome weather widget create a file `weather_conf.lua` inside `awesome` with the contents
```
city="London"
api_key="abcdefghijklmnopqrstuvwxyz"
```
An api key can be acquired from [openweathermap](https://openweathermap.org/api).
