" general behavior settings

" use backslash as leader character
let mapleader = '\'
let g:mapleader = '\'

" store files under .vim, not in the working directory
set backupdir=~/.vim/.backups//
set directory=~/.vim/.swaps//
set undodir=~/.vim/.undos//
set undofile

" NO BELL
set noerrorbells
set t_vb=
set visualbell

set backspace=2
set modeline

" make tabs 2 spaces, shift 2 spaces, tab => spaces, smart autoindenting
set autoindent
set expandtab
set shiftwidth=2
set smartindent
set softtabstop=2
set tabstop=2
augroup cindent
  autocmd!
  autocmd FileType c,cpp,cs,java,javascript set cindent
augroup end

" case-smart searching that searches while typing and highlights matches
set hlsearch
set ignorecase
set incsearch
set smartcase
nnoremap <silent> <leader>case :set ignorecase! smartcase! <cr>
nnoremap <silent> <leader>high :nohlsearch <cr>

" reselect visual block after shifting
vnoremap < <gv
vnoremap > >gv

" make Y act like the rest of the capitals
nmap Y y$

" keep search matches at the center of the screen
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz
nnoremap <silent> g# g#zz
