" Installation:
" For nvim run `pip install --user neovim jedi black pynvim`
"
" Run tests see vim-test
" :CestNearest
" :TestFile
"
" Notes:
" For NeoVim, this file is run AFTER plugins are loaded
" See ~/dotfiles/nvim/ftplugin/python.vim for more python specific mappings

" Header for startup message is a vim Tip
let g:startify_custom_header = 'startify#pad([GetTip()])'

if filereadable(glob("~/.vimrc.local"))
       source ~/.vimrc.local
endif

" Do not duplicate configuration
if !has("nvim")
    " Map the leader key to comma
    let mapleader=","
endif
syntax enable
colorscheme wombat256mod
filetype plugin indent on
set colorcolumn=93

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

set termguicolors

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
map <Leader>s :s/\( *\)\(.*\)\(.=.\)\(.*\)/\1\4\3\2<CR>
map <Leader>/ :help myhelp<bar>:set modifiable<CR>
map <Leader>rc :Vr<CR>
map <Leader>nrc :Nrc<CR>
" Source vimrc shortcut
" Show filesystem tree in sidebar
map <F1> :Cheatsheet<CR>
" File explorer
map <F2> :NERDTreeToggle<CR>
" Source vimrc
map <F3> :so $MYVIMRC<CR>:echom "Sourced " . $MYVIMRC<CR>
" View undo tree shortcut
" Show edits and deletions
map <F4> :UndotreeToggle<CR>
" Auto linting for Vim8+ and Neovim
map <F5> :Neomake<CR>


"-------------------------------------------------------------
"-------------------------- Testing --------------------------
"-------------------------------------------------------------
" Run tests
nnoremap <Leader><C-n> :TestNearest<CR>
nnoremap <Leader><C-f> :TestFile<CR>
nnoremap <Leader><C-s> :TestSuite<CR>
nnoremap <Leader><C-l> :TestLast<CR>
nnoremap <Leader><C-g> :TestVisit<CR>


"-----------------------------------------------------------
"------------------mappings & commands --------------------
"-----------------------------------------------------------
" Open file menu
nnoremap <SPACE>o :CtrlP<CR>
" Open buffer menu
nnoremap <Leader>B :CtrlPBuffer<CR>
nnoremap <SPACE>B :CtrlPBuffer<CR>
nnoremap <SPACE>b :CtrlPBuffer<CR>
" Open most recently used files
nnoremap <Leader>f :CtrlPMRUFiles<CR>
nnoremap <SPACE>f :CtrlPMRUFiles<CR>

" View last opened files
nnoremap <Leader>o :oldfiles<CR>
nnoremap <Leader>so :so %<CR>

" cycle through multiple buffers
nnoremap <silent> ]c :bn<CR>
nnoremap <silent> [c :bp<CR>

command! Tree :NeoTreeRevealToggle
command! T :Tree
command! Vimrc :e ~/dotfiles/nvim/vimrc.vim
command! Rc :Vimrc
command! Vr :Vimrc
command! Pythonrc :e ~/dotfiles/nvim/ftplugin/python.vim
command! Nvimrc :e ~/dotfiles/nvim/init.lua
command! Nv :Nvimrc
command! Nrc :Nvimrc
command! Nvr :Nvimrc
command! NvP :e ~/dotfiles/nvim/init.lua | :normal /^plugins<CR> | :normal $%<CR>
command! Pu :NvP
command! Ip :call InsertPlugin("")
command! Pi :Ip
command! OldReference :e ~/dotfiles/vim-cheatsheet.txt
command! Reference :help myhelp
command! Ref :Reference
command! Mru :oldfiles
command! So :so %
command! Src :so %
command! Ftp :e ~/dotfiles/nvim/ftplugin/python.vim
command! Ftl :e ~/dotfiles/nvim/ftplugin/lua.vim
" Open Shortcuts
command! Shortcuts :e ~/dotfiles/nvim/vimrc.vim | :normal ?command!<CR>
command! Sc :Shortcuts
" Turn on spell check
command! Spell :setlocal spell spelllang=en_us
" Turn off spell check
command! Nospell :setlocal spell spelllang=
" How do I get
command! Fkeys :nmap <F1>
command! -nargs=? Hrst call HeaderCreate('<args>')

function! Mytest()
    " TODO: display mappings
    echo nmap <F1>
endfunction

" Do not auotmatically insert comments.
set formatoptions-=r formatoptions-=o formatoptions-=c


set shiftwidth=4 tabstop=4 softtabstop=4
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif

" Persistent undo directory
" Create undodir if not existent
let undodir_path = $HOME . "/.config/.undodir"
if !isdirectory(undodir_path)
    call mkdir(undodir_path)
endif
set undofile
let &undodir = undodir_path


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

" Enable project specific configuration files
set exrc

" Disable unsafe config injection for exrc
set secure

" Fold by default
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevel=99

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

" Create swapfile if it doesn't exists and set it as the swap directory
let swapfile_dir = $HOME . "/.vim/swapfiles/"
if ! isdirectory(swapfile_dir)
    call mkdir(swapfile_dir)
endif
let &directory=swapfile_dir

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

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

" Shortcut for repeating macros
"
if has('nvim')
    call ddc#custom#patch_global('ui', 'native')
    call ddc#custom#patch_global('sources', ['around'])
    call ddc#custom#patch_global('sourceOptions', #{
          \ _: #{
          \   matchers: ['matcher_head'],
          \   sorters: ['sorter_rank']},
          \ })

    " Change source options
    call ddc#custom#patch_global('sourceOptions', #{
          \   around: #{ mark: 'A' },
          \ })
    call ddc#custom#patch_global('sourceParams', #{
          \   around: #{ maxSize: 500 },
          \ })

    " Customize settings on a filetype
    call ddc#custom#patch_filetype(['c', 'cpp'], 'sources',
          \ ['around', 'clangd'])
    call ddc#custom#patch_filetype(['c', 'cpp'], 'sourceOptions', #{
          \   clangd: #{ mark: 'C' },
          \ })
    call ddc#custom#patch_filetype('markdown', 'sourceParams', #{
          \   around: #{ maxSize: 100 },
          \ })

    " Mappings

    " <TAB>: completion.
    inoremap <silent><expr> <TAB>
    \ pumvisible() ? '<C-n>' :
    \ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
    \ '<TAB>' : ddc#map#manual_complete()

    " <S-TAB>: completion back.
    inoremap <expr><S-TAB>  pumvisible() ? '<C-p>' : '<C-h>'

    " Use ddc.
    call ddc#enable()
endif

let g:pydoc_cmd = 'python -m pydoc'

"===================================================
"=================Functions========================
"===================================================
function! InsertPlugin(plugin_line)
    " Insert a plugin into the lua line
    " - quote and brace and add comma
    " Optional[plugin_line(str)]

    " Retrieve line from clipboard if not
    " supplied
    let output_line = a:plugin_line
    if output_line ==# ''
        let output_line = getreg('+')
    endif

    " Does this line even work? I've been having the pipe symbol not work
    "let output_line = substitute(output_line, '^\n\|\n$', '', 'g')
    if stridx(output_line, "{") == -1
        " Drop quotes - only if there are no braces
        let output_line = substitute(output_line, "['\"]", '', 'g')
        " Add braces and quotes
        let output_line = "{\"" . output_line . "\"}"
    endif
    let lastChar = strpart(output_line, -1)
    " Add delimieter for next plugin
    if lastChar != ","
        let output_line = output_line . ","
    endif
    NvP
    execute 'normal O' . output_line
endfunction
