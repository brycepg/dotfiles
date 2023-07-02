Text editor: neovim
Language support: lua, python
Potential future support: rust, webdev

This git repository contains the dotfiles I reguarly use between computers.

Setup symlinks:

    git clone https://github.com/brycepg/dotfiles.git ~/dotfiles
    python ~/setup.py

Installation on Linux
Install linux dependencies:

    if which apt; then
      package_manager="apt"
    # Check if dnf is installed
    elif which dnf; then
      package_manager="dnf"
    else
      # Which scoop (sadly not platform independent shell)
      echo "Neither apt nor dnf package managers are installed."
      exit 1
    fi
    echo "Using package manager: $package_manager"
    sudo $package_manager install -y ansible
    ansible-playbook -l localhost install-dependencies-linux.yml

Install language servers:

	nvim --headless "+Lazy! sync" +qa
	nvim --headless -c ':LspInstall lua_ls' -c 'qa!'
	nvim --headless -c ':LspInstall vimls' -c 'qa!'

Install dependencies on windows:
================================

 See
 - install-dependencies-windows.ps1
 - windows-notes.txt
