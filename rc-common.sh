# Enable `fuck` for correcting misspellings
if type thefuck >/dev/null; then
    eval $(thefuck --alias)
fi

# Auto jump
[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh

# Add user bin directory to path
if [ -d ~/.local/bin ]; then
    export PATH="$PATH:$HOME/.local/bin"
fi


agp() {
    # Nice function to recursively search only python files
    # Requires `ag`
    ag -G ".*\.py" "$@"
}

set_editor() {
    # Prefer nvim over vim over vi
    # Alias vim to nvim if available
    editor=""
    if type nvim > /dev/null; then
        editor="nvim"
        alias vim="nvim"
    elif type vim > /dev/null; then
        editor="vim"
    else
        editor="vi"
    fi
    # Git env variable
    export EDITOR=$editor
    # Yaourt env variable
    export VISUAL=$editor
}
set_editor
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

