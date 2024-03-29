" pymode enabled auto textwidth chopping. Destroys my concentration
let g:pymode_options=0

" pymode indent documentation is wonky.
let g:pymode_indent=1

" Override go-to.definition key shortcut to Ctrl-]
let g:pymode_rope_goto_definition_bind = "<C-]>"

" Override view python doc key shortcut to Ctrl-Shift-d
let g:pymode_doc_bind = "<C-S-d>"

" Trim whitespace
let g:pymode_trim_whitespaces = 1

" Turn off lint window
let g:pymode_lint_cwindow = 0
nnoremap <leader>q :call CWindowToggle()<CR>

" use :e when goto definition
let g:pymode_rope_goto_definition_cmd = 'e'

" Try out pymode syntax
let g:pymode_syntax_all = 1
let g:pymode_syntax_space_errors = 0

" Toggle lint mode. If lint mode is off also rerun the linter to populate the window
function! CWindowToggle()
	if g:pymode_lint_cwindow
		let g:pymode_lint_cwindow = 0
	else
		let g:pymode_lint_cwindow = 1
        PymodeLint
	endif
endfunction

" Turn off code completion on dot
let g:pymode_rope_complete_on_dot = 0

" Set comment string for python
setlocal commentstring=#%s

" Set definition match for python
setlocal define=^\s*\\(def\\\\|class\\)

" Taken from pymode_options. XXX figure out what they do
setlocal formatoptions-=t
setlocal complete+=t

let g:pymode_python = 'python3'

" Docstring preview in folds
let g:SimpylFold_docstring_preview = 1
let g:SimpylFold_fold_docstring = 0

" Uot use one shiftwidth (4 spaces) for parenthesis indent
" The default is 2*shiftwidth, which is not a valid hanging indent.
let pyindent_nested_paren="&sw"
let pyindent_open_paren="&sw"


" Like gJ, but always remove spaces
fun! JoinSpaceless()
    execute 'normal gJ'

    " Character under cursor is whitespace?
    if matchstr(getline('.'), '\%' . col('.') . 'c.') =~ '\s'
        " When remove it!
        execute 'normal dw'
    endif
endfun
noremap <leader>J :call JoinSpaceless()<CR>

" Use improved python indentation for nested parens
"source: https://github.com/dccmx/google-style.vim/blob/master/indent/python.vim
set indentexpr=GetGooglePythonIndent(v:lnum)
let s:maxoff = 50 " maximum number of lines to look backwards.
function! GetGooglePythonIndent(lnum)

  " Indent inside parens.
  " Align with the open paren unless it is at the end of the line.
  " E.g.
  "   open_paren_not_at_EOL(100,
  "                         (200,
  "                          300),
  "                         400)
  "   open_paren_at_EOL(
  "       100, 200, 300, 400)
  call cursor(a:lnum, 1)
  let [par_line, par_col] = searchpairpos('(\|{\|\[', '', ')\|}\|\]', 'bW',
        \ "line('.') < " . (a:lnum - s:maxoff) . " ? dummy :"
        \ . " synIDattr(synID(line('.'), col('.'), 1), 'name')"
        \ . " =~ '\\(Comment\\|String\\)$'")
  if par_line > 0
    call cursor(par_line, 1)
    if par_col != col("$") - 1
      return par_col
    endif
  endif

  " Delegate the rest to the original function.
  return GetPythonIndent(a:lnum)
endfunction

" Original warning sign is too hard to see
let g:neomake_warning_sign={'text': 'W'}

" Set vim-test python runner to pytest, delete if using a different test
" runner
let test#python#runner = 'pytest'
let g:neomake_python_enabled_makers = ['flake8']

" Override ftplugin/python.vim tabstop set to 8
autocmd FileType python setlocal tabstop=4

" Auto delete trailing whitespace, save cursor position
augroup noWhitespace
  autocmd!
  autocmd BufWritePre * let currPos = getpos(".")
  autocmd BufWritePre * %s/\s\+$//e
  autocmd BufWritePre * %s/\n\+\%$//e
  autocmd BufWritePre *.[ch] %s/\%$/\r/e
  autocmd BufWritePre * call cursor(currPos[1], currPos[2])
augroup END
