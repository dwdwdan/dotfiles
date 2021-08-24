# Vim aliases
alias v=nvim
alias vim=nvim
alias vf="v \$(fzf-tmux)"

# Git aliases
alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias zshrc="source ~/.zshrc"

# Ls aliases
alias ls="exa --icons --all"
alias ll="exa --icons --long --header --git --across --all --no-user"
alias l="exa --icons --all"
alias lg="ll | grep "

# Other aliases
alias run="screen -d -m"
alias p="sudo pacman"
alias neofetch="clear;neofetch;truecolor-test"
alias startmpd="mpd; run mpDris2; ncmpcpp"
alias q="exit"
alias rm="mv -t ~/.trash/"
