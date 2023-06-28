" Enable Mouse
set mouse=a

" Set Editor Font
if exists(':GuiFont')
    " Use GuiFont! to ignore font errors
    " GuiFont {font_name}:h{size}
endif

" Disable GUI Tabline
if exists(':GuiTabline')
    GuiTabline 0
endif

" Disable GUI Popupmenu
if exists(':GuiPopupmenu')
    GuiPopupmenu 0
endif

" Right Click Context Menu (Copy-Cut-Paste)
" Not working
nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
xnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>gv
snoremap <silent><RightMouse> <C-G>:call GuiShowContextMenu()<CR>gv

if exists('g:fvim_loaded')
    " good old 'set guifont' compatibility with HiDPI hints...
    if g:fvim_os == 'windows' || g:fvim_render_scale > 1.0
      " set guifont=Iosevka\ Slab:h14
    else
      " set guifont=Iosevka\ Slab:h28
    endif

    " Ctrl-ScrollWheel for zooming in/out
    nnoremap <silent> <C-ScrollWheelUp> :set guifont=+<CR>
    nnoremap <silent> <C-ScrollWheelDown> :set guifont=-<CR>
    nnoremap <A-CR> :FVimToggleFullScreen<CR>
endif
