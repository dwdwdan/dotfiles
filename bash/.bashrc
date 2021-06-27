export GH_EDITOR="nvim"
export EDITOR="nvim"
export VISUAL="nvim"
export PATH="~/.local/bin:$PATH"

alias v=nvim
alias vim=nvim
alias dotfiles="cd ~/repos/dotfiles"
alias web="cd ~/repos/website"
alias q="exit"
alias gs="git status"
alias cls="clear"
alias bashrc="source ~/.bashrc"
alias ls="ls -la"
alias rweb="cd ~/repos/website; bundle exec jekyll serve --livereload"
alias run="screen -d -m"


neofetch

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# Install Ruby Gems to ~/gems
export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"

eval "$(starship init bash)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/dan/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/dan/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/dan/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/dan/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# command to activate correct conda environment
function Conda() {
    if [ -e ".conda" ]; then
        ENV=$(head -n 1 .conda)

        # Check to see if already activated to avoid redundant activating
        if [[ $PATH == *"$ENV"* ]]; then
            echo "Conda env '$ENV' already activated."
        else
            conda activate $ENV
        fi
    fi
}
