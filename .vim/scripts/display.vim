" display settings

syntax on
colorscheme default

set list listchars=tab:▸\ ,precedes:<,extends:>
set ruler
set showmatch

" show line numbers as distance from cursor
set relativenumber
inoremap <silent> <leader>rnum <c-o>:set relativenumber! <cr>
nnoremap <silent> <leader>rnum :set relativenumber! <cr>
vnoremap <silent> <leader>rnum :set relativenumber! <cr>

" line wrapping
set nowrap
set display=lastline
set list fillchars=lastline:—
inoremap <silent> <leader>wrap <c-o> :set wrap! <cr>
nnoremap <silent> <leader>wrap :set wrap! <cr>
vnoremap <silent> <leader>wrap :set wrap! <cr>

" show line of current cursor (in current window only)
set cursorline
augroup currentline
  autocmd!
  autocmd WinEnter * set cursorline
  autocmd WinLeave * set nocursorline
augroup end

" resize splits on window resize
augroup splitresize
  autocmd!
  autocmd VimResized * execute "normal! \<c-w> ="
augroup end
