PROMPT_COMMAND="build_ps1_function"

build_ps1_function(){
	gitForPrompt;
	PS1="\n\[\e[33m\]\u\[\e[00m\]@\[\e[32m\]\h \[\e[00m\]in \[\e[31m\]\w \[\033[36m\]$branchStatement \n \[\e[37m\]\d \t \n \[\e[00m\]--> ";
}

gitForPrompt(){
	branch=$(git symbolic-ref --short HEAD 2>/dev/null);
	if [ -n "$branch" ];
	then
		branchStatement="(ᚠ $branch)";
	else
		branchStatement="";
	fi
}


export PS1;

alias vim=nvim
alias vimrc="cd ~/dotfiles;vim ."
alias q="exit"

# cd to selected directory
fd() {
	local dir
	dir=$(find ${1:-.} -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf +m) &&
		cd "$dir"
	}
