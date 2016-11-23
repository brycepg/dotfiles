syntax on
if has('win32') && ! has('gui_running')
    " 256 Colors do not work in cmd.exe and cmder
    colorscheme wombat
else
    colorscheme wombat256mod
endif
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

" Allow buffers to be hidden
set hidden

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

map <F2> :so $MYVIMRC
map <F4> :UndotreeToggle<CR>
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
Plug 'tpope/vim-abolish'

" I haven't used this very much
Plug 'mbbill/undotree'
Plug 'qpkorr/vim-bufkill'

" Refresh memory on usefulenss
Plug 'godlygeek/tabular'

" Do I still want these
"Plug 'Glench/Vim-Jinja2-Syntax'
"Plug 'tpope/vim-haml'
"Plug 'hynek/vim-python-pep8-indent'

" Too slow
Plug 'klen/python-mode', {'for': 'python,vim'}

" To be determined area
Plug 'justinmk/vim-sneak'

if !has('nvim')
  Plug 'noahfrederick/vim-neovim-defaults'
else
    Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote'), 'for': 'vim,c'}
    Plug 'benekastah/neomake'
endif

call plug#end()


" Do not auotmatically insert comments.
set formatoptions-=r formatoptions-=o formatoptions-=c

" pymode enabled auto textwidth chopping. Destroys my concentration
let g:pymode_options=0
" pymode indent documentation is wonky.
let g:pymode_indent=1

let g:deoplete#enable_at_startup = 1

let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ }

let g:rainbow_active = 1

set shiftwidth=4 tabstop=4 softtabstop=4
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif

" Persistent undo directory
" Create undodir if not existent
let undodir_path = $HOME . "/.undodir"
if !isdirectory(undodir_path)
    call mkdir(undodir_path)
endif
set undofile
set undodir=~/.undodir

" Enable project specific configuration files
set exrc

" Disable unsafe config injection for exrc
set secure
