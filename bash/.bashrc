PROMPT_COMMAND="build_ps1_function"

build_ps1_function(){
	gitForPrompt;
	PS1="\n\[\e[33m\]\u\[\e[00m\]@\[\e[32m\]\h \[\e[00m\]in \[\e[31m\]\w \[\033[36m\] \
	$gitStatement \n \[\e[37m\]\d \t \n \[\e[00m\]--> ";
}

gitForPrompt(){
	branch=$(git symbolic-ref --short HEAD 2>/dev/null);
	if [ -n "$branch" ];
	then
		gitStatement="(ᚠ $branch";
		uncommitted=$(git status --porcelain);
		if [ -n "$uncommitted" ];
		then
			gitStatement+="!";
		fi
		gitStatement+=")";
	else
		gitStatement="";
	fi
}

export PS1;
export GH_EDITOR="nvim"
export EDITOR="nvim"
export VISUAL="nvim"

alias v=nvim
alias vim=nvim
alias dotfiles="cd ~/repos/dotfiles;v"
alias web="cd ~/repos/website;v"
alias q="exit"
alias gs="git status"
alias cls="clear"
alias bashrc="source ~/.bashrc"
alias ls="ls -la"

# cd to selected directory
fd() {
	local dir
	dir=$(find ${1:-.} -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf +m) &&
		cd "$dir"
	}

if [ -f ~/.personal.bashrc ];
then
	source ~/.personal.bashrc;
fi

neofetch

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

. "$HOME/.cargo/env"

# Install Ruby Gems to ~/gems
export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"
