" F4 => deploy
function! Deploy()
  let path = expand("%:p:h")
  if (stridx(path, "/home/nodejs/chi-server/chi-client/") == 0 &&
      stridx(path, "/home/nodejs/chi-server/chi-client/chi-static) == -1)
    execute("!npm run build-dev")
  endif
endfunction
noremap  <silent> <buffer>  <f4>         :w!<cr>:call Deploy()<cr>
inoremap <silent> <buffer>  <f4>    <c-o>:w!<cr><c-o>:call Deploy()<cr>
