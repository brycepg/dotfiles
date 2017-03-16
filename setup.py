#!/usr/bin/env python

"""
Setup all symlinks to home directory for these dotfiles.

1 Backup files already present.
2 Remove broken symlinks
3 Setup symlink

This file assumes it's in the base directory if dotfiles
"""

from collections import OrderedDict
import filecmp
import os
import subprocess
import sys
import shutil

DOTFILE_DIR = os.path.dirname(os.path.realpath(__file__))

# Change this to configure the symlink mapping
DOTFILE_TO_HOME = (
    ('bashrc', '.bashrc'),
    ('screenrc', '.screenrc'),
    ('zshrc', '.zshrc'),
    ('nvim', '.vim'),
    ('nvim', '.config/nvim'),
    ('nvim/init.vim', '.vimrc'),
    ('bin', 'bin'),
)


def get_bak_path(filepath):
    """Get a backup filepath that does not exist.
    
    Use filepath to generate a path that is filepath.bak
    If it already exists, then generate a path such as filepath.bak1
    and so on.
    """
    ext = ".bak"
    template_new_path = "{}{}".format(filepath, ext)
    counter = 1
    new_path = template_new_path
    while os.path.exists(new_path):
        new_path = "{}{}".format(template_new_path, counter)
        counter += 1
    return new_path


def is_bad_symlink(filepath):
    """Returns True if symlink is relative or the file its
    pointing to does not exist."""
    is_symlink = os.path.islink(filepath)
    if not is_symlink:
        return False
    symlink_dst_exists = os.path.exists(os.readlink(filepath))
    abs_symlink = os.path.isabs(os.readlink(filepath))
    return not (symlink_dst_exists and abs_symlink)


def main(symlink_pair, cur_dir):
    """Evaluate all tuples as symlinks from cur_dir to the home dir."""
    for src, dst in symlink_pair:
        src_full_path = os.path.join(cur_dir, src)
        dst_full_path = os.path.join(os.environ['HOME'], dst)
        if os.path.islink(dst_full_path):
            if is_bad_symlink(dst_full_path):
                print("Broken symlink found at {}. Removing"
                      .format(dst_full_path))
                os.unlink(dst_full_path)
            elif src_full_path == os.readlink(dst_full_path):
                print("{} is already at source".format(src))
                continue
        if os.path.exists(dst_full_path):
            bak_path = get_bak_path(dst_full_path)
            print("Backing up existing file '{}' to '{}'"
                  .format(dst_full_path, bak_path))
            shutil.move(dst_full_path, bak_path)
        print("{} => {}".format(dst_full_path, src_full_path))
        os.symlink(src_full_path, dst_full_path)
    print("Linking is complete.")

if __name__ == "__main__":
    main(DOTFILE_TO_HOME, DOTFILE_DIR)
