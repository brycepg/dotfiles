function! GetSeparator()
    if has('unix')
        let separator = '/'
    elseif has('win32') || has('win64')
        let separator = '\\'
    else
        let separator = '/'
    endif
    return separator
endfunction

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

function! s:ffn(fn, path) abort
  return get(get(g:, 'io_' . matchstr(a:path, '^\a\a\+\ze:'), {}), a:fn, a:fn)
endfunction

" WTF does this do
function! s:fcall(fn, path, ...) abort
  return call(s:ffn(a:fn, a:path), [a:path] + a:000)
endfunction

" WHY
function! s:MinusOne(...) abort
  return -1
endfunction

function! s:MkdirCallable(name) abort
  let ns = matchstr(a:name, '^\a\a\+\ze:')
  if !s:fcall('isdirectory', a:name) && s:fcall('filewritable', a:name) !=# 2
    if exists('g:io_' . ns . '.mkdir')
      return [g:io_{ns}.mkdir, [a:name, 'p']]
    elseif empty(ns)
      return ['mkdir', [a:name, 'p']]
    endif
  endif
  return ['s:MinusOne', []]
endfunction

" command! -bar -bang -nargs=? -complete=dir Mkdir
"       \ let s:dst = empty(<q-args>) ? expand('%:h') : <q-args> |
"       \ if call('call', s:MkdirCallable(s:dst)) == -1 |
"       \   echohl WarningMsg |
"       \   echo "Directory already exists: " . s:dst |
"       \   echohl NONE |
"       \ elseif empty(<q-args>) |
"       \    silent keepalt execute 'file' fnameescape(@%) |
"       \ endif |
"       \ unlet s:dst
