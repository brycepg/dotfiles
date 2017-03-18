# Do not source if not interactive
[[ $- != *i* ]] && return

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi


# Display terminal colors
colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}


# Add a local rc file for configurations specific to this machine
[[ -f ~/.bashrc.local ]] && . ~/.bashrc.local

# Add Bash autocompletion if available
[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion


# Source file that contains directives that are common to both zshrc and bashrc
dotfiles_path=$(dirname $(readlink -f ${BASH_SOURCE[0]}))
common_source="$dotfiles_path/rc-common.sh"
if [ -e "$common_source" ]; then
    . "$common_source"
fi

alias ls='ls --color=auto'
