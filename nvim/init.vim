syntax on
if has('win32') && ! has('gui_running')
    " 256 Colors do not work in cmd.exe and cmder
    colorscheme wombat
else
    colorscheme wombat256mod
endif
filetype plugin indent on
set colorcolumn=93

" Override ftplugin/python.vim tabstop set to 8
autocmd FileType python setlocal tabstop=4

" Expand tabs into spaces
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
"Plug 'python-mode/python-mode', {'for': 'python,vim', 'branch': 'develop'}
Plug 'ctrlpvim/ctrlp.vim'             " Fuzzy search
Plug 'itchyny/lightline.vim'          " Status bar
Plug 'tpope/vim-surround'             " Surround motions
Plug 'tpope/vim-repeat'               " Extending repeat to macros
Plug 'tpope/vim-fugitive'             " Git from vim
Plug 'luochen1990/rainbow'            " Rainbow parenthesis
Plug 'tpope/vim-abolish'              " Case smart replace/change: via Subvert/cr[smcu]
Plug 'arnar/vim-matchopen'            " Highlight last opened parenthesis
Plug 'tpope/vim-unimpaired'           " Bracket shortcuts
Plug 'ntpeters/vim-better-whitespace' " Highlight trailing whitespace
" I haven't used this very much
Plug 'mbbill/undotree'
Plug 'qpkorr/vim-bufkill' " :BD option to close buffer
" Better Python folding
Plug 'tmhedberg/SimpylFold'
" Refresh memory on usefulenss
Plug 'godlygeek/tabular'
" Do I still want these
"Plug 'Glench/Vim-Jinja2-Syntax'
"Plug 'tpope/vim-haml'
" Plug 'justinmk/vim-sneak'

if !has('nvim')
    Plug 'noahfrederick/vim-neovim-defaults'
else
    " Neovim only plugins
    Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote'), 'for': 'vim,c'}
    Plug 'benekastah/neomake'
endif

call plug#end()


" Do not auotmatically insert comments.
set formatoptions-=r formatoptions-=o formatoptions-=c

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


function! HeaderCreate(...)
    " Create a rst header with the first character of the first argument.
    " Defaults to '='
    if a:0 < 1
        let l:char = '='
    else
        " First character of the first argument
        let l:char = a:1[0]
    endif
    normal yyp:s/./\=l:char/ | nohl
endfunction
command! -nargs=? Hrst call HeaderCreate('<args>')

" Enable project specific configuration files
set exrc

" Disable unsafe config injection for exrc
set secure

" Fold by default
set foldmethod=indent
set foldlevel=99
" Enable folding with the spacebar
nnoremap <space> za

" Look for ctags file in current directory
set tags=./tags,tags;
