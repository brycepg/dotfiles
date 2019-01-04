" ------------------------ <Leader> key(SPACE) ------------------------
" Map the leader key to SPACE

"map <SPACE> <Nop>
let mapleader="\<SPACE>"
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

" Only enable use of the mouse in normal mode
" It's helpful to disable the mouse to copy and paste text
" via the terminal emulator because vim copy pasting is flaky
set mouse=n

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

" Source vimrc shortcut
map <F2> :so $MYVIMRC<CR>:echom "Sourced " . $MYVIMRC<CR>
" View undo tree shortcut
map <F4> :UndotreeToggle<CR>
" Auto linting for Vim8+ and Neovim
map <F5> :Neomake<CR>


" Run tests
nnoremap <Leader><C-n> :TestNearest<CR>
nnoremap <Leader><C-f> :TestFile<CR>
nnoremap <Leader><C-s> :TestSuite<CR>
nnoremap <Leader><C-l> :TestLast<CR>
nnoremap <Leader><C-g> :TestVisit<CR>

function! DoRemote(arg)
    UpdateRemotePlugins
endfunction
call plug#begin('~/.config/nvim/plugged')
Plug 'ctrlpvim/ctrlp.vim'             " Fuzzy search
Plug 'itchyny/lightline.vim'          " Status bar
Plug 'tpope/vim-surround'             " Surround motions
Plug 'tpope/vim-repeat'               " Extending repeat to macros
Plug 'tpope/vim-fugitive'             " Git from vim
Plug 'luochen1990/rainbow'            " Rainbow parenthesis
Plug 'tpope/vim-abolish'              " Case smart replace/change: via Subvert/cr[smcu]
" Broken by vim update
"Plug 'arnar/vim-matchopen'            " Highlight last opened parenthesis
Plug 'tpope/vim-unimpaired'           " Bracket shortcuts
Plug 'ntpeters/vim-better-whitespace' " Highlight trailing whitespace
" I haven't used this very much
Plug 'mbbill/undotree'
Plug 'qpkorr/vim-bufkill' " :BD option to close buffer
" Better Python folding
Plug 'tmhedberg/SimpylFold'
" Refresh memory on usefulenss
Plug 'godlygeek/tabular'
" Rearrange function parameters
Plug 'AndrewRadev/sideways.vim'
" Do I still want these
"Plug 'Glench/Vim-Jinja2-Syntax'
"Plug 'tpope/vim-haml'
" Plug 'justinmk/vim-sneak'

" Auto format with :Autoformat
Plug 'Chiel92/vim-autoformat'

" Static analysis tools
Plug 'benekastah/neomake'
" :Autopep8 auto formatting
Plug 'tell-k/vim-autopep8'
" pep8 Formatting on newline
Plug 'Vimjas/vim-python-pep8-indent'
" gs to sort python imports
Plug 'christoomey/vim-sort-motion'
" griw - replace section with register value
Plug 'vim-scripts/ReplaceWithRegister'
" extra text objects - cin) da,
Plug 'wellle/targets.vim'
" Change argument wrapping
Plug 'FooSoft/vim-argwrap'

Plug 'tpope/vim-eunuch'

Plug 'vim-scripts/ingo-library'
Plug 'vim-scripts/JumpToLastOccurrence'

" Opening to specific line
Plug 'kopischke/vim-fetch'

" Run tests inside vim
" :TestNearest
" :TestFile
Plug 'janko-m/vim-test'

" toml syntax for vim
Plug 'cespare/vim-toml'
" Show ctags info
Plug 'majutsushi/tagbar'

" Use flake8 for python linting
Plug 'nvie/vim-flake8'

" Fix jinja syntax highlighting
Plug 'Glench/Vim-Jinja2-Syntax'

" Autocompletion (ctrl + space)
" Can't figure how to disable autocomplete import
"Plug 'davidhalter/jedi-vim'

" Thrift syntax
Plug 'solarnz/thrift.vim'

if !has('nvim')
    Plug 'noahfrederick/vim-neovim-defaults'
else
    " Neovim only plugins
    " Autocompletion for Python Jedi
    "Plug 'zchee/deoplete-jedi'
    " Autocompletion
    "Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
endif

call plug#end()


" Do not auotmatically insert comments.
set formatoptions-=r formatoptions-=o formatoptions-=c

let g:deoplete#enable_at_startup = 1

" Status bar
" - Set colorscheme
" - Show folder in addition to filename
" - Show current class / method via tagbar
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'component_function': {
      \   'filename': 'LightlineFilename',
      \ },
      \ 'active': {
      \   'left': [ [ 'mode', 'paste'],
      \             [ 'readonly', 'filename', 'modified', 'tagbar'] ],
      \ },
      \ 'component': {
      \   'tagbar': '%{tagbar#currenttag("[%s]", "", "f")}',
      \ },
      \ }

function! LightlineFilename()
  return expand('%:F')
endfunction

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

" Turn on spell check
command! Spell :setlocal spell spelllang=en_us

" Look for ctags file in current directory
set tags=./tags,tags;

" Disable entering ex mode
noremap Q <Nop>


function! HasComma()
    " Return true if the line contains a comma
    let l:line = getline(".")
    if l:line =~ ","
        return 1
    else
        return 0
    endif
endfunction

" Indent after comma for python function code.
" Use with vim-python-pep8-indent
function! FunIndent()
    while HasComma()
        normal ^/,a
    endwhile
endfunction

let g:neomake_python_enabled_makers = ['flake8']

" Do not autocomplete on dot
let g:jedi#popup_on_dot = 0
let g:jedi#completions_enabled = 0
let g:jedi#show_call_signatures = 0

set directory=$HOME/.vim/swapfiles//

if filereadable(glob("~/.vimrc.local"))
        source ~/.vimrc.local
endif
