source ~/.vim/scripts/os.vim " this one has to come first
source ~/.vim/scripts/buffer.vim
source ~/.vim/scripts/display.vim
source ~/.vim/scripts/general.vim
source ~/.vim/scripts/motion.vim

if filereadable(expand('~/.local/vimrc'))
  source ~/.local/vimrc
endif

filetype indent on
filetype plugin on
