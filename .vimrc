" Not compatible with vi
set nocompatible

" Indenting - 4 spaces to a tab always
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" Indentatiton
set autoindent
filetype plugin indent on

" Syntax highlighting
syntax on
" Enable 256 colors Terminal -- TODO: check if available before setting
set t_Co=256
colorscheme wombat256

" Enable line numbers
set number

" Add file recognition for arduino filetypes (in .vim)
au BufRead,BufNewFile *.pde set filetype=arduino
au BufRead,BufNewFile *.ino set filetype=arduino

" Show good column limit
set colorcolumn=80

" Explore file tree better
" Using :Explore
let g:netrw_liststyle=3

" ----- F-keys ------"
" Call makefile
map <F5> :!make<CR>
" TODO function to search all files like argdo but better


" Back Directories in centralized location to not pollute filesystem
set backupdir=~/.vim_bak/backup
set dir=~/.vim_bak/dir

execute pathogen#infect()
