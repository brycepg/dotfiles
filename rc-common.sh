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

set_editor() {
    # Prefer nvim over vim over vi
    # Alias vim to nvim if available
    editor=""
    if type nvim &> /dev/null; then
        editor="nvim"
        alias vim="nvim"
    elif type vim &> /dev/null; then
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
alias gss='git status -s'
alias gst='git stash'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gp='git pull'
alias glg='git log --graph --oneline --decorate --all'
alias gld='git log --pretty=format:"%h %ad %s" --date=short --all'

# Wrap command to notify user upon finish
endnotify() {
    if ! $(command-exists notify-send); then
        echo "You need to install notify-send to use this function"
        exit 1
    fi
    start=$(date +%s)
    "$@"
    notify-send --expire-time 999999999 "Notification" "command \"$(echo $@)\" took $(($(date +%s) - start)) seconds to finish"
}

# Notify when already running process finishes
curnotify() {
    pid="$1"
    if ! $(command-exists notify-send); then
        echo "You need to install notify-send to use this function"
        exit 1
    fi
    args="$(ps -o cmd "$pid" | tail -n 1)"
    start_date_formatted="$(ps -o lstart "$pid" | tail -n 1)"
    start="$(date --date="$start_date_formatted" +%s)"
    echo "pid start: " $start_date_formatted
    echo "cur date: $(date +%s)"
    tail --pid="$pid" -f /dev/null
    notify-send --expire-time 999999999 "Notification" "command \"$(echo ${args})\" took $(($(date +%s) - ${start})) seconds to finish"
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
