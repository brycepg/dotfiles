#!/usr/bin/env python

"""
Setup all symlinks to home directory for these dotfiles.

1 Backup files already present.
2 Remove broken symlinks
3 Setup symlink

This file assumes it's in the base directory if dotfiles
"""

from itertools import count
from os.path import exists, join, islink, isabs, dirname, realpath, expanduser
import os
from os import unlink, readlink, symlink
import shutil
from typing import (  # noqa: F401
    Tuple, Callable, Iterable, Optional, TypeVar)

DOTFILE_DIR = dirname(realpath(__file__))
T = TypeVar('T')

# Change this to configure the symlink mapping
# File or directory in dotfiles => path relative to home directory
# path in home directory will point to file/dir in dotfiles
DOTFILE_TO_HOME = (
    ('nvim', '.vim'),
    ('nvim', '.config/nvim'),
    # bin get's hijacked by other scripts
    ('bin', 'executables'),
    ('ipython_config.py', '.ipython/profile_default/ipython_config.py'),
)

if os.name != "nt":
    DOTFILE_TO_HOME = DOTFILE_TO_HOME + (
        ('bashrc', '.bashrc'),
        ('screenrc', '.screenrc'),
        ('zshrc', '.zshrc'),
        # GUI config for neovim
        ('nvim/ginit.vim', "AppData/Local/nvim/ginit.vim"),
    )

if os.name == "nt":
    DOTFILE_TO_HOME = DOTFILE_TO_HOME + (('nvim', 'vimfiles'),)
    DOTFILE_TO_HOME = DOTFILE_TO_HOME + (('nvim', 'AppData/Local/nvim'),)
    DOTFILE_TO_HOME = DOTFILE_TO_HOME + (
        ('Microsoft.PowerShell_profile.ps1',
         'Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1'),
    )


def main(symlink_pair, cur_dir):
    # type: (Tuple[Tuple[str, str], ...], str) -> None
    """Evaluate tuple pairs as symlinks from home pointing to the dotfiles.

    Args:
        symlink_pair: A tuple of tuple pairs containing relative paths.
            The first entry of a tuple contains a path relative to the
            dotfile location, and the second entry contains a path relative
            to the home directory. The location at the home directory will
            be symlinked to point to the location in the dotfile directory
        cur_dir: An absolute directory path which points to the
            location of the dotfiles..
        """
    for src, dst in symlink_pair:
        src_full_path = join(cur_dir, src)
        home = expanduser("~")
        dst_full_path = join(home, dst)
        link_pair(src_full_path, dst_full_path)
    print("Linking is complete.")


def link_pair(src, dst):
    # type: (str, str) -> None
    """Point src path to dst path if possible."""
    should_continue = handle_symlink_case(dst, src)
    if not should_continue:
        return
    if not identical_symlink_exists(dst, src):
        handle_file_backup(dst, src)
        create_parent_destination_directory(dst)
        print("{} => {}".format(dst, src))
        symlink(src, dst)


def identical_symlink_exists(dst, src):
    # tupe: (str, src) -> None
    if not exists(dst):
        return
    link_path = os.path.realpath(os.readlink(dst)).replace("\\\\?\\", "")
    src_path = os.path.realpath(src)
    ret = os.path.islink(dst) and link_path == src_path
    if ret:
        print(f"Found established symlink for {dst}")
    return ret


def create_parent_destination_directory(path):
    # type: (str) -> None
    """Create parent destination directory if it doesn't exists.

    Example:
        ~/.config
    """
    parent_path_dir = os.path.dirname(path)
    if not os.path.exists(parent_path_dir):
        if not os.path.exists(parent_path_dir):
            create_parent_destination_directory(parent_path_dir)
        print("Creating Parent Destination Directory '{}'"
              .format(parent_path_dir))
        os.mkdir(parent_path_dir)


def handle_symlink_case(dst, src):
    # type: (str, str) -> bool
    """Handle checking for symlinks at the destination location.

    Returns:
        False to not continue linking
        True to continue linking location
    """
    if not exists(src):
        print("{} does not exist. Skipping.".format(src))
        return False
    if islink(dst):
        if is_bad_symlink(dst):
            print("Broken symlink found at {}. Removing"
                  .format(dst))
            unlink(dst)
        elif src == readlink(dst):
            print("{} is already at source".format(src))
            return False
    return True


def is_bad_symlink(filepath):
    # type: (str) -> bool
    """Returns True if symlink is relative or the file its
    pointing to does not exist."""
    is_symlink = islink(filepath)
    if not is_symlink:
        return False
    symlink_dst_exists = exists(readlink(filepath))
    abs_symlink = isabs(readlink(filepath))
    return not (symlink_dst_exists and abs_symlink)


def handle_file_backup(filepath, target):
    # type: (str) -> None
    """Moving existing file to a backup location."""
    # This function is only relevant when a file exists at the src location
    if not exists(filepath):
        return
    # Prevent duplicate bak symlinks
    bak_path = get_bak_path(filepath)
    print("Backing up existing file '{}' to '{}'"
          .format(filepath, bak_path))
    shutil.move(filepath, bak_path)


def get_bak_path(filepath):
    # type: (str) -> str
    """Get a backup filepath that does not exist.

    Use filepath to generate a path that is filepath.bak
    If it already exists, then generate a path such as filepath.bak1
    and so on.
    """
    candidate_paths = candidate_bak_path_retrieval(filepath)
    return first_true(candidate_paths, pred=path_available)


def path_available(filepath):
    # type: (str) -> bool
    """Return true if filepath is available"""
    parent_directory = dirname(filepath)
    if not exists(parent_directory):
        raise ParentDirectoryDoesNotExist(parent_directory, filepath)
    return not exists(filepath)


class ParentDirectoryDoesNotExist(Exception):
    """Exception for when a parent directory does not exist."""
    def __init__(self, parent_directory, filepath):
        self.parent_directory = parent_directory
        self.filepath = filepath
        # This is right pylint
        # pylint: disable=bad-super-call
        super(Exception, self).__init__(str(self))

    def __str__(self):
        fmt = "filepath '{filepath}' in '{parent_directory}'"
        return fmt.format(
            filepath=self.filepath,
            parent_directory=self.parent_directory)


def first_true(iterable, pred=None):
    # type: (Iterable[T], Optional[Callable]) -> T
    """Return the first true iterable.

    If pred is not None, then apply predicate to iterable before checking
    truth value.
    """
    try:
        return next(filter(pred, iterable))
    except StopIteration:
        raise NoTrueValueError


class NoTrueValueError(ValueError):
    """Exception for when there is no true value."""
    pass


def candidate_bak_path_retrieval(filepath):
    # type: (str) -> Iterable[str]
    """Yield candidate path for backup file."""
    ext = ".bak"
    template_new_path = "{}{}".format(filepath, ext)
    for ext_append in get_ext_append():
        yield "{}{}".format(template_new_path, ext_append)


def get_ext_append():
    # type: () -> Iterable[str]
    """Yield the extension for the current number."""
    yield ""
    for num in count(start=1):
        yield str(num)


if __name__ == "__main__":
    main(DOTFILE_TO_HOME, DOTFILE_DIR)
