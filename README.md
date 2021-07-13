# My Dotfiles
These are my dotfiles for nvim, bash and tmux.

## Requirements
 - Neovim 0.5
 - zsh
 - fzf
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
 - `~/.zshrc` -> `.zshrc`

For the awesome weather widget create a file `weather_conf.lua` inside `awesome` with the contents
```
city="123456"
api_key="abcdefghijklmnopqrstuvwxyz"
```
The city code can be found by finding the city on [openweathermap](https://openweathermap.org) and taking the last part of the address.
An api key can be acquired from [openweathermap](https://openweathermap.org/api).
