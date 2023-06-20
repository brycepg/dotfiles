" Installation:
" For nvim you should to run `pip install --user neovim jedi black`
"
" Run tests see vim-test
" :CestNearest
" :TestFile
"
" Notes:
" See ~/.vim/ftplugin/python for more python specific mappings
if filereadable(glob("~/.vimrc.local"))
        source ~/.vimrc.local
endif

" Map the leader key to comma
let mapleader=","
syntax enable
colorscheme wombat256mod
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

" Allow buffers to be hidden
set hidden

" No highligting during replace
autocmd cursorhold * set nohlsearch
autocmd cursormoved * set hlsearch

" Only enable use of the mouse in normal mode
" It's helpful to disable the mouse to copy and paste text
" via the terminal emulator because vim copy pasting is flaky
set mouse=n

"-------------------------------------------------------------
"--------------------------- Shortcuts -----------------------
"-------------------------------------------------------------
" nohl shortcut
map <SPACE>h :nohl<CR>
" Paste from clipboard
map <Leader>p "+p<CR>
" Yank line to clipboard
map <Leader>y "+yy<CR>
" Swap expressions between equals sign
map <Leader>s :s/\( \+\)\(.\+\)\(.=.\)\(.\+\)/\1\4\3\2<CR>:nohl<CR>
" Buffer history
nnoremap <leader>mh <cmd>lua require('memento').toggle()<CR>

" Source vimrc shortcut
" Show filesystem tree in sidebar
map <F2> :Tree<CR>
" View undo tree shortcut
" Show edits and deletions
map <F4> :UndotreeToggle<CR>
" Auto linting for Vim8+ and Neovim
map <F5> :Neomake<CR>
" Source vimrc
map <F6> :so $MYVIMRC<CR>:echom "Sourced " . $MYVIMRC<CR>


"-------------------------------------------------------------
"-------------------------- Testing --------------------------
"-------------------------------------------------------------
" Run tests
nnoremap <Leader><C-n> :TestNearest<CR>
nnoremap <Leader><C-f> :TestFile<CR>
nnoremap <Leader><C-s> :TestSuite<CR>
nnoremap <Leader><C-l> :TestLast<CR>
nnoremap <Leader><C-g> :TestVisit<CR>


"-------------------------------------------------------------
"------------------------ CtrlP plugin -----------------------
"-------------------------------------------------------------
" Open file menu
nnoremap <Leader>o :CtrlP<CR>
nnoremap <SPACE>o :CtrlP<CR>
" Open buffer menu
nnoremap <Leader>B :CtrlPBuffer<CR>
nnoremap <SPACE>B :CtrlPBuffer<CR>
nnoremap <SPACE>b :CtrlPBuffer<CR>
" Open most recently used files
nnoremap <Leader>f :CtrlPMRUFiles<CR>
nnoremap <SPACE>f :CtrlPMRUFiles<CR>

"-------------------------------------------------------------
"------------------- Plugin installation ---------------------
"-------------------------------------------------------------
function! DoRemote(arg)
    UpdateRemotePlugins
endfunction
call plug#begin('~/.config/nvim/plugged')
Plug 'm4xshen/autoclose.nvim'           " Autoclose functions
Plug 'kkoomen/vim-doge'                 " Documentation saffold
" - [ ] did this work?
Plug 'editorconfig/editorconfig-vim'    " Consistent coding styles between editors
" <leader>d - generate documentation scaffold for function,etc
Plug 'tpope/vim-eunuch'                 " :Delete :Move :Rename :SudoWrite :SudoEdit
Plug 'qpkorr/vim-bufkill'               " :BD option to close buffer
Plug 'mbbill/undotree'                  " :UndotreeShow
Plug 'ctrlpvim/ctrlp.vim'               " Fuzzy search
Plug 'tpope/vim-surround'               " Surround motions
Plug 'tpope/vim-repeat'                 " Extending repeat to macros
Plug 'tpope/vim-fugitive'               " Git from vim
Plug 'tpope/vim-abolish'                " Case smart replace/change: via Subvert/cr[smcu]
Plug 'arnar/vim-matchopen'              " Highlight last opened parenthesis
Plug 'tpope/vim-unimpaired'             " Bracket shortcuts
Plug 'ntpeters/vim-better-whitespace'   " Highlight trailing whitespace
Plug 'tmhedberg/SimpylFold'             " Better Python folding
Plug 'godlygeek/tabular'                " Alignment with :Tab /{Pattern}
Plug 'AndrewRadev/sideways.vim'         " Rearrange function parameters
Plug 'Chiel92/vim-autoformat'           " Auto format with :Autoformat
Plug 'neomake/neomake'                  " Static analysis tools :Neomake
Plug 'tell-k/vim-autopep8'              " :Autopep8 auto formatting
Plug 'Vimjas/vim-python-pep8-indent'    " pep8 Formatting on newline
Plug 'nvie/vim-flake8'                  " Use flake8 for python linting
Plug 'christoomey/vim-sort-motion'      " gs to sort python imports
Plug 'michaeljsmith/vim-indent-object'  " Indention objects ai/ii/aI/iI mainly for python
Plug 'vim-scripts/ReplaceWithRegister'  " griw - replace section with register value
Plug 'wellle/targets.vim'               " extra text objects - cin) da,
Plug 'FooSoft/vim-argwrap'              " Change argument wrapping
Plug 'kopischke/vim-fetch'              " Opening to specific line using colon number ex :3
Plug 'cespare/vim-toml'                 " toml syntax for vim
Plug 'itchyny/lightline.vim'            " Status bar
Plug 'majutsushi/tagbar'                " Show ctags info
Plug 'Glench/Vim-Jinja2-Syntax'         " Fix jinja syntax highlighting
Plug 'solarnz/thrift.vim'               " Thrift syntax
Plug 'janko-m/vim-test'                 " Run tests inside vim :TestNearest :TestFile
Plug 'davidhalter/jedi-vim'             " Autocompletion (ctrl + space)
Plug 'vim-scripts/ingo-library'         " Dependent library for JumpToLastOccurrence
Plug 'vim-scripts/JumpToLastOccurrence' " Jump to last occurance of a char with ,f motion ,t
Plug 'justinmk/vim-sneak'               " Two-char search using s motion
Plug 'AndrewRadev/bufferize.vim'        " :Bufferize to output vim functions into buffer
Plug 'KabbAmine/zeavim.vim'             " Zeal docs lookup with :Zeavim

Plug 'preservim/nerdtree' " :NERDTree :NERDTreeToggle :NERDTreeFocus
command! Tree :NERDTreeFocus " :Tree command
command! T :NERDTreeFocus " :T command
command! Vimrc :e ~/dotfiles/nvim/vimrc.vim
command! Nvimrc :e ~/dotfiles/nvim/init.lua
command! Cheatsheet :e ~/dotfiles/nvim/vim-cheatsheet.txt

Plug 'preservim/nerdtree' " :NERDTree :NERDTreeToggle :NERDTd T :Tree

" Do I still want these
"Plug 'tpope/vim-haml'
" Autocompletion
"Plug 'Valloric/YouCompleteMe'

" Utili snips code
""   EEEEEEEEEEEEEEEEEE
"""""Plug 'SirVer/ultisnips'

" Snippets are separated from the engine. Add this if you want them:
Plug 'honza/vim-snippets'

" Search cheatsheet for neovim
Plug 'sudormrfbin/cheatsheet.nvim' " <leader>?
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.1' }
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Trying out this linter for ansible make sure to install required linters in
" Gemfile or requirements.txt
Plug 'mfussenegger/nvim-lint'

" Doesn't work yet, blocked my Neural config and maybe plug
" Does it work now? :checkhealth is all green on quarth
Plug 'dense-analysis/neural'
    Plug 'MunifTanjim/nui.nvim'
    Plug 'elpiloto/significant.nvim'

" Colorschemes
Plug 'morhetz/gruvbox'

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
" Ctrl-S expand snippits
let g:UltiSnipsExpandTrigger="<c-s>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
" End of Utili snips code


if !has('nvim')
    Plug 'noahfrederick/vim-neovim-defaults'
    :echom "I now use plugins that are for vim only "
else
    " Python code formatting
    Plug 'ambv/black'
    " Neovim only plugins
    " Autocompletion
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    " Autocompletion for Python Jedi
    Plug 'zchee/deoplete-jedi'

    " Chatgpt
    Plug 'jackMort/ChatGPT.nvim'
    Plug 'MunifTanjim/nui.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'

endif

call plug#end()

if has('nvim')
    " Disable jedi completions for deoplete-jedi
    let g:jedi#completions_enabled = 0
    let g:deoplete#enable_at_startup = 1
endif


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

set shiftwidth=4 tabstop=4 softtabstop=4
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif

" Persistent undo directory
" Create undodir if not existent
let undodir_path = $HOME . "/.config/.undodir"
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
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevel=99

" Turn on spell check
command! Spell :setlocal spell spelllang=en_us
" Turn off spell check
command! Nospell :setlocal spell spelllang=

" Look for ctags file in current directory
set tags=./tags,tags,./ctags;

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
" To use :call FunIndent()
function! FunIndent()
    while HasComma()
        normal ^/,a
    endwhile
endfunction


" Do not autocomplete on dot
"let g:jedi#popup_on_dot = 0
"let g:jedi#show_call_signatures = 0
" Does this work?
let g:jedi#show_call_signatures = "1"
" Show docs !!!
let g:jedi#documentation_command = "K"


" Create swapfile if it doesn't exists and set it as the swap directory
let swapfile_dir = $HOME . "/.vim/swapfiles/"
if ! isdirectory(swapfile_dir)
    call mkdir(swapfile_dir)
endif
let &directory=swapfile_dir


" =============================
" === Neomake configuration ===
" =============================
" Auto run lint on write -- good for writing code
" autocmd BufWritePost * :Neomake
" When writing a buffer (no delay), and on normal mode changes (after 750ms).
" Full config: when writing or reading a buffer, and on changes in insert and
" normal mode (after 500ms; no delay when writing).
call neomake#configure#automake('nrwi', 500)

" language specific configuration is at ~/dotfiles/nvim/ftplugin
" Python configuration: ~/dotfiles/nvim/ftplugin/python.vim
