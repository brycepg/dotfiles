# Binaries from rust package manager including bob-nvim
export PATH="$PATH:$HOME/.cargo/bin"

# Auto jump
if [[ $- = *i* ]]; then
    [[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh
fi

if [ -d ~/.local/bin ]; then
    export PATH="$PATH:$HOME/.local/bin"
fi

yn_get_prompt() {
    # rename_file_and_text
    while true
    do
        read -p "y/n? " answer
        case $answer in
            [yY]* )
                echo true
                break;;
            [nN]* )
                echo false
                break;;
        esac
    done
}
rename_file_and_text() {
    oldfile=$1
    newfile=$2
    mv -u $oldfile $newfile && \
        grep -rl $oldfile . | \
        xargs sed -i "s/$oldfile/$newfile/g"
    #filepath=$(basename $1)
    #
    #dirpath=$(dirname $1)
    #mv $1 $2
    #mv_ret=$?
    #if [[ $mv_ret != 0 ]]; then
    #    read -p  Mv failed, continue? [yn/]
    #    exit $mv_ret
    #fi
    #echo test
    # sed -i -e "s/$1/$2/g" 
}

agp() {
    # Nice function to recursively search only python files
    # Requires `ag`
    ag -G ".*\.py" "$@"
}

pysed() {
    # Apply sed function to all python files in current directory
    sed -i -e "$@" $(find -name "*.py")
}

pysedsr() {
    if [[ "$#" == "0" ]]; then
        echo 'search for $1 and replace with $2'
        echo 'for all python files in the current directory'
        echo '$3' for sed arguments
        return 1
    fi
    pysed "s/$1/$2/${3:-}"
}


set_editor() {
    # Prefer nvim over vim over vi
    # Alias vim to nvim if available
    editor=""
    if type vim &> /dev/null; then
        editor="vim"
    else
        editor="vi"
    fi
    # Git env variable
    export EDITOR=$editor
    # Yaourt env variable
    export VISUAL=$editor
}
# Git alias
untracked() {
    # Get a list of untracked files
    output=$(git status --porcelain) 2>/dev/null
    if [[ "$?" == 128 ]]; then
        echo "Not a git directory"
    else
        echo "$output" | grep -i '^??' | tr -d '^?? '
    fi
}
set_editor

# -----------
# Git Aliases
# -----------
alias gstn='git status -uno -s'
alias gsts='git status -s'
alias gsta='git stash'
alias gs='git status -s'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gp='git pull'
alias glg='git log --graph --oneline --decorate --all'
alias gld='git log --pretty=format:"%h %ad %s" --date=short --all'
alias gb='git branch'
alias gc='git checkout'
alias gr='git remote'

# Wrap command to notify user upon finish
endnotify() {
    if ! command-exists notify-send; then
        echo "You need to install notify-send to use this function"
        exit 1
    fi
    start=$(date +%s)
    "$@"
    notify-send -u critical --expire-time 999999999 "Notification" "command \"$(echo $@)\" took $(($(date +%s) - start)) seconds to finish"
}

# Notify when already running process finishes
curnotify() {
    pid="$1"
    if ! command-exists notify-send; then
        echo "You need to install notify-send to use this function"
        exit 1
    fi
    args="$(ps -o cmd "$pid" | tail -n 1)"
    start_date_formatted="$(ps -o lstart "$pid" | tail -n 1)"
    start="$(date --date="$start_date_formatted" +%s)"
    echo "pid start: " $start_date_formatted
    echo "cur date: $(date +%s)"
    tail --pid="$pid" -f /dev/null
    notify-send -u critical --expire-time 999999999 "Notification" "command \"$(echo ${args})\" took $(($(date +%s) - ${start})) seconds to finish"
}

# Check if command exists
command-exists() {
    bin="$1"
    type "$bin" > /dev/null;
    echo $?
}


# Copy into clipboard
function clip() {
    xclip -selection clipboard "$@"
}

# Git aliases
alias d='git diff'
alias psh='git push'
alias pl='git pull'
alias s='git status'
# Status without untracked files
alias stu='git status -uno'

# Send text via ISP SMS interface
# For set up see
# https://coderwall.com/p/ez1x2w/send-mail-like-a-boss
# Set up
# NOTIFIER_USER
# NOTIFIER_PASS
# PHONE_NUMBER_EMAIL
# environment variables elsewhere
function txtme() {
    echo | mailx -v -s "$1" -S smtp-use-starttls -S ssl-verify=ignore -S smtp-auth=login -S smtp=smtp://smtp.gmail.com:587 -S from="$NOTIFIER_USER" -S smtp-auth-user=$NOTIFIER_USER -S smtp-auth-password=$NOTIFIER_PASS -S ssl-verify=ignore -S nss-config-dir=~/.certs $PHONE_NUMBER_EMAIL > /tmp/mailsend.txt 2>&1
    if [[ $? == 0 ]]; then
        echo TXT mail sent
    else
        echo FAILURE
    fi
}

# Autoset perl stuff for findability
PATH="/home/user/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/user/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/user/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/user/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/user/perl5"; export PERL_MM_OPT;

# Install npm packages user local
export NPM_PACKAGES="$HOME/.npm-packages"

# Tell our environment about user-installed node tools
export PATH="$PATH:$NPM_PACKAGES/bin"

# Unset manpath so we can inherit from /etc/manpath via the `manpath` command
unset MANPATH  # delete if you already modified MANPATH elsewhere in your configuration
MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

# Tell Node about these packages
export NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"

# Path for ruby gem packages
export PATH="$PATH:$HOME/bin"

fingerprint() {
    pubkeypath="$1"
    ssh-keygen -E md5 -lf "$pubkeypath" | awk '{ print $2 }' | cut -c 5-
}

pypackage() {
    package_name="$1"
    # Get the first location of a package
    python -c """import $package_name
print($package_name.__path__[0])
    """
}

gpt() {
    # Concatenate all arguments so I don't need to use quotes
    sgpt "$*"
}

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
