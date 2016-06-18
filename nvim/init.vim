syntax on
colorscheme wombat256mod
filetype plugin indent on
set colorcolumn=93
set expandtab
set number
" gg and G will keep column
set nostartofline
" Do not autowrap lines ever
set textwidth=0
" Change split behavior(move cursor on split)
set splitbelow
set splitright
" Show next 3 lines while scrolling
set scrolloff=3
" Show next 5 columns while side-scrolling.
set sidescrolloff=5
" Global default sed
set gdefault

" Set tags dir
set tags=~/mytags

" Long history
set history=1000

" No highligting during replace
autocmd cursorhold * set nohlsearch
autocmd cursormoved * set hlsearch

" ------------------------ <Leader> key(SPACE) ------------------------
" Map the leader key to SPACE
map <SPACE> <Nop>
let mapleader="\<SPACE>"
" nohl shortcut
map <Leader>h :nohl<CR>
" Paste from clipboard
map <Leader>p "+p<CR>
" Yank line to clipboard
map <Leader>y "+yy<CR>
" Swap expressions between equals sign
map <Leader>s :s/\( \+\)\(.\+\)\(.=.\)\(.\+\)/\1\4\3\2<CR>:nohl<CR>
" ------------------ CtrlP plugin ---------------
" Open file menu
nnoremap <Leader>o :CtrlP<CR>
" Open buffer menu
nnoremap <Leader>B :CtrlPBuffer<CR>
" Open most recently used files
nnoremap <Leader>f :CtrlPMRUFiles<CR>
map <F5> :Neomake<CR>


function! DoRemote(arg)
    UpdateRemotePlugins
endfunction
call plug#begin('~/.config/nvim/plugged')
" I use these all the time
Plug 'ctrlpvim/ctrlp.vim'
Plug 'itchyny/lightline.vim'

" These should be default functionality/nvim option
Plug 'tpope/vim-surround'
Plug 'ntpeters/vim-better-whitespace'
Plug 'arnar/vim-matchopen'
Plug 'tpope/vim-unimpaired'
Plug 'luochen1990/rainbow'

" I haven't used this very much
Plug 'mbbill/undotree'
Plug 'benekastah/neomake'
Plug 'qpkorr/vim-bufkill'

" Refresh memory on usefulenss
Plug 'godlygeek/tabular'

" Do I still want these
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'tpope/vim-haml'

" Why does this intermittently work?
Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }

" Too slow
"Plug 'klen/python-mode', {'for': 'python'}

" To be determined area
call plug#end()

let g:deoplete#enable_at_startup = 1

let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ }

let g:rainbow_active = 1

set shiftwidth=4 tabstop=4 softtabstop=4
"let g:pymode_lint_cwindow = 0
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif

" Persistent undo directory
" Create undodir if not existent
let undodir_path = $HOME . "/.undodir"
if !isdirectory(undodir_path)
    call mkdir(undodir_path)
endif
set undofile
set undodir=~/.undodir
