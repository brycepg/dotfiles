syntax on
colorscheme wombat256
filetype plugin indent on
set colorcolumn=80
set expandtab
set number
set shiftwidth=4 tabstop=4 softtabstop=4

call plug#begin('~/.config/nvim/plugged')
Plug 'tpope/vim-surround'
Plug 'luochen1990/rainbow'
Plug 'benekastah/neomake'
Plug 'godlygeek/tabular'
Plug 'itchyny/lightline.vim'
call plug#end()

let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ }

let g:rainbow_active = 1
