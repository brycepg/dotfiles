# Check dotfiles ~/dotfiles/rc-common.sh if not found in here

# Source file that contains directives that are common to both zshrc and bashrc
dotfiles_path=$(dirname $(readlink -f ${BASH_SOURCE[0]}))
common_source="$dotfiles_path/rc-common.sh"
if [ -e "$common_source" ]; then
    . "$common_source"
fi

# Add lua packages to path
if which luarocks>/dev/null; then
    eval $(luarocks path)
fi


# Do not source below if not interactive
[[ $- != *i* ]] && return

# ------------------- Interactive shell configuration ---------------------------
# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi



# Add Bash autocompletion if available
[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion


alias vimrc='nvim ~/dotfiles/nvim/vimrc.vim'
alias nvimrc='nvim ~/dotfiles/nvim/init.lua'
alias bashrc='nvim ~/.bashrc'
alias vim='nvim'
alias ls='ls --color=auto'

ptest() {
    nvim --headless -c "PlenaryBustedFile $1"
}

alias luatest=ptest

# Set PS1 if set to default bash ps1
set_ps1() {
    if [ -e /etc/bash_completion.d/git-prompt ]; then
        source /etc/bash_completion.d/git-prompt
    fi
    PS1='\u@\h \W\$ '
}
set_ps1

# Unlimited history
HISTSIZE= HISTFILESIZE=

# Change history file location because some programs truncate it
export HISTFILE=~/.bash_external_history

# Immediately append history to file
shopt -s histappend

export PROMPT_COMMAND="${PROMPT_COMMAND}${PROMPT_COMMAND:+;}history -a; history -n"

# Add a local rc file for configurations specific to this machine
# XXX needs to be at end
[[ -f ~/.bashrc.local ]] && . ~/.bashrc.local


# Autocomplete tab select for interactive
if [[ $- = *i* ]]; then
    bind '"\t":menu-complete'
    bind "set show-all-if-ambiguous on"
    bind "set completion-ignore-case on"
    bind "set menu-complete-display-prefix on"
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

pdroid() {
    ansible-playbook -l odroid -i inventory.yml $@
}

sb() {
    source ~/.bashrc
}

if [ -e /home/bryce/.cargo/bin ]; then
    export PATH="$PATH:/home/bryce/.cargo/bin"
fi
