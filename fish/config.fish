source $HOME/.config/fish/z-fish/z.fish

# Local bin in path
set -gx PATH $PATH $HOME/bin
# Anaconda Python3 in path
set -gx PATH $HOME/anaconda3/bin $PATH 

# xclipc -- use clipboard by default
alias xclipc "xclip -select clipboard"

# Neovim as default editor for git, etc
set -x EDITOR nvim

eval (python -m virtualfish)
