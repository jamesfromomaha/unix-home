if [[ $LOGNAME == root && -z $FROM_PROFILE ]]
then
  source .bash_profile
  return
fi

# colors for grep and ls
alias grep='grep --color=auto'
alias ls='ls -G'

# less typing
alias vi=vim

# aliases
alias l1='ls -1'
alias la='ls -A'
alias lr='ls -r'
alias lt='ls -t'
alias lar='ls -Ar'
alias lat='ls -At'
alias lrt='ls -rt'
alias lart='ls -Art'
alias ll='ls -gho'
alias lla='ls -Agho'
alias llr='ls -ghor'
alias llt='ls -ghot'
alias llar='ls -Aghor'
alias llat='ls -Aghot'
alias llrt='ls -ghort'
alias llart='ls -Aghort'
alias lld='ls -gho --color=always |grep ^d'
alias llda='ls -Agho --color=always |grep ^d'
alias lldr='ls -ghor --color=always |grep ^d'
alias lldt='ls -ghot --color=always |grep ^d'
alias lldar='ls -Aghor --color=always |grep ^d'
alias lldat='ls -Aghot --color=always |grep ^d'
alias lldrt='ls -ghort --color=always |grep ^d'
alias lldart='ls -Aghort --color=always |grep ^d'
alias lll='ls -hl'
alias llla='ls -hlA'
alias lllr='ls -hlr'
alias lllt='ls -hlt'
alias lllar='ls -hlAr'
alias lllat='ls -hlAt'
alias lllrt='ls -hlrt'
alias lllart='ls -hlArt'
alias llld='ls -hl --color=always |grep ^d'
alias lllda='ls -hlA --color=always |grep ^d'
alias llldr='ls -hlr --color=always |grep ^d'
alias llldt='ls -hlt --color=always |grep ^d'
alias llldar='ls -hlAr --color=always |grep ^d'
alias llldat='ls -hlAt --color=always |grep ^d'
alias llldrt='ls -hlrt --color=always |grep ^d'
alias llldart='ls -hlArt --color=always |grep ^d'

# quick dir change
export BINDIR=/usr/local/bin
export LOGDIR=/var/log
alias cdbin="cd $BINDIR"
alias cdlog="cd $LOGDIR"
alias pdbin="pushd $BINDIR"
alias pdlog="pushd $LOGDIR"


# remove a file's contents, creating it if need be
function truncate() {
  for file in "$@"
  do
    echo -n >"$file"
  done
}

# convert input string to hex
function str2hex() {
  echo -n "$1" |xxd |tr ' ' "\n" |sed --quiet '/^....$/p' |tr --delete "\n"
}

# vim files that match grep pattern
function vimgrep() {
  vim `grep -l "$@"`
}

function pushd() {
  if [[ $# == 0 ]]
  then
    pushd ~
    return
  fi
  builtin pushd "$@" >/dev/null
  [[ $? == 0 ]] && echo :: `dirs |cut -s -d ' ' -f 2-`
}
function popd() {
  builtin popd "$@" >/dev/null
  [[ $? == 0 ]] && echo :: `dirs |cut -s -d ' ' -f 2-`
}

# modify interactive sudo (sudo -i) to make it pass along the current directory
# in the CDDIR environment variable
function sudo() {
  [[ $1 == -i ]] && cwd="`pwd`"
  CDDIR="$cwd" command sudo "$@"
}

# generate a data url from an image
function img2url() {
  if [[ $# != 1 || ! -f $1 ]]
  then
    echo 'Usage:' >&2
    echo "  $0 FILENAME" >&2
    return
  fi

  case `echo -n "${1##*.}" |tr [A-Z] [a-z]` in
  apng) header="data:image/apng;base64,";;
  avif) header="data:image/avif;base64,";;
  bmp) header="data:image/bmp;base64,";;
  gif) header="data:image/gif;base64,";;
  ico|.cur) header="data:image/x-icon;base64,";;
  jpg|.jpeg|.jfif|.pjpeg|.pjp) header="data:image/jpeg;base64,";;
  png) header="data:image/png;base64,";;
  svg) header="data:image/svg+xml;base64,";;
  tif|.tiff) header="data:image/tiff;base64,";;
  webp) header="data:image/webp;base64,";;
  esac

  if [[ -z $header ]]
  then
    echo 'Invalid file type' >&2
    return
  fi

  echo -n "$header"
  base64 -i $1 |tr -d "\n"
}

[[ -f ~/.local/bashrc ]] && source ~/.local/bashrc
[[ -d ~/.local/rc.d ]] && for rcfile in ~/.local/rc.d/*; do source $rcfile; done
