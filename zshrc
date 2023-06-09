# Source file that contains directives that are common to both zshrc and bashrc
dotfile_path=$(dirname $(readlink -f ${(%):-%N}))
common_source="${dotfile_path}/rc-common.sh"
if [ -e $common_source ]; then
    . "$common_source"
else
    echo common source $common_source not found
fi

local_rc_path=$HOME/.zshrc.local
if [ -f $local_rc_path ]; then
    . $local_rc_path
fi


# ----------------- End of non-interactive configuration ---------------------
if [[ $- != *i* ]]; then
    return
else
# ----------------- Start of interactive configuration -----------------------

function check_last_exit_code() {
  # Provides exit code in comand prompt
  local LAST_EXIT_CODE=$?
  if [[ $LAST_EXIT_CODE -ne 0 ]]; then
    local EXIT_CODE_PROMPT=''
    EXIT_CODE_PROMPT+="%{$fg[red]%}[%{$reset_color%}"
    EXIT_CODE_PROMPT+="%{$fg_bold[red]%}$LAST_EXIT_CODE%{$reset_color%}"
    EXIT_CODE_PROMPT+="%{$fg[red]%}]%{$reset_color%}"
    echo "$EXIT_CODE_PROMPT"
  fi
}

# Path to your oh-my-zsh installation.
# Prefer local installation over system installation if available
system_ohmyzsh_path="/usr/share/oh-my-zsh/"
local_ohmyzsh_path="$HOME/.oh-my-zsh/"
if [ -d "$local_ohmyzsh_path" ]; then
    export ZSH="$local_ohmyzsh_path"
elif [ -d "$system_ohmyzsh_path" ]; then
    export ZSH="$system_ohmyzsh_path"
fi


# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git, zsh-syntax-highlighting, zsh-history-substring-search, z)

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

if [ -e $ZSH/oh-my-zsh.sh ]; then
    source $ZSH/oh-my-zsh.sh
    PROMPT='$(check_last_exit_code)'$PROMPT
    PROMPT="$USER $PROMPT"
fi

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# put https://github.com/zsh-users/zsh-history-substring-search 
# into ~/.oh-my-zsh/plugins
# Add a local rc file for configurations specific to this machine

# History
unsetopt share_history
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
HISTSIZE=10000000
SAVEHIST=10000000
