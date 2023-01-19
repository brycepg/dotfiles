# Auto jump
[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh

# Add user bin directory to path
add_user_local_bin() {
    if [ -d ~/.local/bin ]; then
        export PATH="$PATH:$HOME/.local/bin"
    fi
}
add_user_local_bin


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

fingerprint() {
    pubkeypath="$1"
    ssh-keygen -E md5 -lf "$pubkeypath" | awk '{ print $2 }' | cut -c 5-
}
