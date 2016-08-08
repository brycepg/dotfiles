# pip install virtualfish
# vf create p3k
# link z-fish dorectory into .config/fish
source $HOME/.config/fish/z-fish/z.fish

# Local bin in path
set -gx PATH $PATH $HOME/bin
set -gx PATH $PATH /usr/local/bin
# Anaconda Python3 in path
set -gx PATH $HOME/anaconda3/bin $PATH

# xclipc -- use clipboard by default
if which xclip > /dev/null
    alias xclipc "xclip -select clipboard"
else
    echo "xclip is not installed"
end

# Neovim as default editor for git, etc
if which nvim > /dev/null
    set -x EDITOR nvim
else
    echo "nvim is not installed"
end

if which python > /dev/null
    eval (python -m virtualfish)
    # Default virtualenv
    vf activate p3k
else
    echo "python is not installed"
end

if which thefuck > /dev/null
    eval (thefuck --alias | tr '\n' ';')
else
    echo "thefuck not installed"
end
