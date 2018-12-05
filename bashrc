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


# Add Bash autocompletion if available
[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion


# Source file that contains directives that are common to both zshrc and bashrc
dotfiles_path=$(dirname $(readlink -f ${BASH_SOURCE[0]}))
common_source="$dotfiles_path/rc-common.sh"
if [ -e "$common_source" ]; then
    . "$common_source"
fi

alias ls='ls --color=auto'

# Set PS1 if set to default bash ps1
set_ps1() {
    GIT=""
    if [ -e /etc/bash_completion.d/git-prompt ]; then
        source /etc/bash_completion.d/git-prompt
        GIT="\e[0;32m\$(__git_ps1)\e[m"
    fi
    PS1='\u@\h \W\$'"$GIT "
}
set_ps1

# Unlimited history
HISTSIZE= HISTFILESIZE= 

# Change history file location because some programs truncate it
export HISTIFLE=~/.bash_external_history

# Immediately append history to file
shopt -s histappend

export PROMPT_COMMAND="${PROMPT_COMMAND}${PROMPT_COMMAND:+;}history -a; history -n"

# Get IP address from hostname using Python
# Args:
#   $1 - hostname
# Returns:
#   The ip address
ipfromhostname() {
    local hostname="$1"
    if [ -z "$hostname" ]; then
        >&2 echo 'Must supply hostname as an argument'
        return 1
    fi
    local python_exists=$(type python 2>/dev/null)
    if [ -z "$python_exists" ]; then
        >&2 echo Requires python
        return 1
    fi
    python -c "import socket; print(socket.gethostbyname(\"$hostname\"))" 2>/dev/null
    local ret="$?"
    if [[ "$ret" != 0 ]]; then
        >&2 echo Hostname not found
        return 1
    fi
}


# Add a local rc file for configurations specific to this machine
# XXX needs to be at end
[[ -f ~/.bashrc.local ]] && . ~/.bashrc.local
