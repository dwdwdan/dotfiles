dotfiles(){
	# Set Session Name
	SESSION="dotfiles"
	SESSIONEXISTS=$(tmux list-sessions | grep $SESSION)

	# Only create tmux session if it doesn't already exist
	if [ "$SESSIONEXISTS" = "" ]
	then
		# Start New Session with our name
		tmux new-session -d -s $SESSION

		 # Name first Pane and start zsh
		 tmux rename-window -t 0 'Main'
		 tmux send-keys -t 'Main' 'cd ~/repos/dotfiles' C-m 'clear' C-m

	fi

	# Attach Session, on the Main window
	tmux attach-session -t $SESSION:0
# Adapted from http://ryan.himmelwright.net/post/scripting-tmux-workspaces/
}

web(){
	# Set Session Name
	SESSION="website"
	SESSIONEXISTS=$(tmux list-sessions | grep $SESSION)

	# Only create tmux session if it doesn't already exist
	if [ "$SESSIONEXISTS" = "" ]
	then
		# Start New Session with our name
		tmux new-session -d -s $SESSION

		 # Name first Pane and start zsh
		 tmux rename-window -t 0 'Main'
		 tmux send-keys -t 'Main' 'cd ~/repos/website' C-m 'clear' C-m

		 tmux new-window -t $SESSION:1 -n 'Jekyll Server'
		 tmux send-keys -t 'Jekyll Server' 'cd ~/repos/website; bundle exec jekyll serve --livereload' C-m
	fi

	# Attach Session, on the Main window
	tmux attach-session -t $SESSION:0
# Adapted from http://ryan.himmelwright.net/post/scripting-tmux-workspaces/
}
