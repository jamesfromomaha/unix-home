" jump to the next or previous line that has the same level or a lower level of
" indentation than the current line.
function! NextIndentLine(inclusive, forward, out)
  let line = line('.')
  let column = col('.')
  let eof = line('$')
  let indent = indent(line)
  let step = a:forward ? 1 : -1
  while (line > 0 && line <= eof)
    let line = line + step
    if (!a:out && indent(line) == indent || a:out && indent(line) < indent)
      if (strlen(substitute(getline(line), '^\s*\(.\{-}\)\s*$', '\1', '')) > 0)
        if (!a:inclusive)
          let line = line - step
        endif
        if (a:out)
          let column = column - &shiftwidth
        endif
        execute line
        execute "normal " column . "|"
        return
      endif
    endif
  endwhile
endfunction

nnoremap <silent> [l :call NextIndentLine(1, 0, 0) <cr>
nnoremap <silent> ]l :call NextIndentLine(1, 1, 0) <cr>
nnoremap <silent> [L :call NextIndentLine(1, 0, 1) <cr>
nnoremap <silent> ]L :call NextIndentLine(1, 1, 1) <cr>
vnoremap <silent> [l <c-o> :call NextIndentLine(1, 0, 0) <cr> m`gv``
vnoremap <silent> ]l <c-o> :call NextIndentLine(1, 1, 0) <cr> m`gv``
vnoremap <silent> [L <c-o> :call NextIndentLine(1, 0, 1) <cr> m`gv``
vnoremap <silent> ]L <c-o> :call NextIndentLine(1, 1, 1) <cr> m`gv``
onoremap <silent> [l :call NextIndentLine(1, 0, 0) <cr>
onoremap <silent> ]l :call NextIndentLine(1, 1, 0) <cr>
onoremap <silent> [L :call NextIndentLine(0, 0, 1) <cr>
onoremap <silent> ]L :call NextIndentLine(0, 1, 1) <cr>
