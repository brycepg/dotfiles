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
