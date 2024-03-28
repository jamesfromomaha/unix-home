" display settings

syntax on
colorscheme default

set list
set listchars=tab:▸\ ,precedes:<,extends:>
set ruler
set showmatch
set showtabline=0

" show line numbers as distance from cursor
set relativenumber
inoremap <silent> <leader>rnum <c-o>:set relativenumber! <cr>
nnoremap <silent> <leader>rnum :set relativenumber! <cr>
vnoremap <silent> <leader>rnum :set relativenumber! <cr>

" line wrapping
set display=lastline
set fillchars+=lastline:⋯
set nolinebreak
set nowrap
inoremap <silent> <leader>wrap <c-o> :set wrap! <cr>
nnoremap <silent> <leader>wrap :set wrap! <cr>
vnoremap <silent> <leader>wrap :set wrap! <cr>
nnoremap <silent> <leader>break :set linebreak! <cr>

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
