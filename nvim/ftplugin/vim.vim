" Auto delete trailing whitespace, save cursor position
augroup noWhitespace
  autocmd!
  autocmd BufWritePre * let currPos = getpos(".")
  autocmd BufWritePre * %s/\s\+$//e
  autocmd BufWritePre * %s/\n\+\%$//e
  autocmd BufWritePre *.[ch] %s/\%$/\r/e
  autocmd BufWritePre * call cursor(currPos[1], currPos[2])
augroup END
