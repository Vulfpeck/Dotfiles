if status is-interactive
    # Commands to run in interactive sessions can go here
		function fish_user_key_bindings 
			    bind \cl 'tput reset; clear; commandline -f repaint'
		end
end
