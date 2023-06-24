This git repository contains the dotfiles I reguarly use between computers.

For me, typical usage is to clone this repo, and then set symlinks to desired rcfiles::

    git clone https://github.com/brycepg/dotfiles.git ~/dotfiles
    python ~/setup.py

.zshrc and .bashrc assume that the dotfiles are located at ~/dotfiles

vim/neovim
==========

My `dotfiles/nvim/init.vim` rcfile is compatible with both vim and neovim

.. Note::

    Install ctags package and run `ctags -R` against directory for function lookup.

for vim::

    ln -T -s ~/dotfiles/nvim/init.vim ~/.vimrc
    ln -s ~/dotfiles/nvim ~/.vim

for neovim::

    ln -s ~/dotfiles/nvim ~/.config/


screen
======

I've changed the control key to Ctrl-b since Ctrl-a is used to go to the start of the line in readline.

::

    ln -s ~/dotfiles/screenrc ~/.screenrc


Windows
#######

vim
===

Use `mklink <https://technet.microsoft.com/en-us/library/cc753194(v=ws.11).aspx>`_ to set up symbol links from an administrative command prompt::

    mklink /D %userprofile%\vimfiles %userprofile%\dotfiles\nvim
    mklink  %userprofile%\_vimrc %userprofile%\dotfiles\nvim\init.vim
