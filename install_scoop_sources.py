#!/usr/bin/env python3

# Install packages for Windows under scoop

import subprocess
import re
import os
from os.path import dirname, realpath

NAME_COL_INDEX = 0
SOURCE_COL_INDEX = 2
DOTFILE_DIR = dirname(realpath(__file__))

SCOOP_PACKAGE_LIST = os.path.join(DOTFILE_DIR, 'vetted-scoop-files.txt')

def gen_whitespace_col(iter_, col):
    next(iter_) # Skip column
    next(iter_) # Skip spacer
    for line in iter_:
        columns = re.split(r'\s+', line.strip())
        yield columns[col]

def get_package_names():
    with open(SCOOP_PACKAGE_LIST, 'r') as file:
        yield from gen_whitespace_col(file, NAME_COL_INDEX)
    with open(SCOOP_PACKAGE_LIST, 'r') as file:
        items = set(gen_whitespace_col(file, SOURCE_COL_INDEX))
        for item in items:
            if item.startswith("http"):
                yield item

def gen_sources():
    with open(SCOOP_PACKAGE_LIST, 'r') as file:
        items = set(gen_whitespace_col(file, SOURCE_COL_INDEX))
        for item in items:
            if item.startswith("http"):
                continue
            yield item

def main():
    for source in gen_sources():
        subprocess.run(["scoop", "bucket", "add", source], shell=True)

    for name in get_package_names():
        subprocess.run(["scoop", "install", name], shell=True)

if __name__ == "__main__":
    main()
