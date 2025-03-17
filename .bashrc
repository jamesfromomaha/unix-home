if [[ $LOGNAME == root && -z $FROM_PROFILE ]]
then
  source .bash_profile
  return
fi


alias cdbin='cd /usr/local/bin'
alias cdvlog='cd /var/log'
alias gbr='git branch'
alias grep='grep --color=auto'
alias ls='ls -G'
alias pdbin='pushd /usr/local/bin'
alias pdvlog='pushd /var/log'
alias vi=vim

function truncate() {
  [[ -f $file ]] && echo -n >"$file"
}

function str2hex() {
  echo -n "$1" |xxd |tr ' ' "\n" |sed --quiet '/^....$/p' |tr --delete "\n"
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

# make sudo -i pass the current directory to the elevated shell
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


# print out a header
function heading() {
  case $1 in
  1)
    printf "\n\e[35m"
    echo '========================================================================'
    echo -n '=  '
    shift
    ;;
  2)
    printf "\e[36m"
    echo '------------------------------------------------------------------------'
    echo -n '-  '
    shift
    ;;
  3)
    printf "\e[34m"
    shift
    ;;
  *)
    printf "\e[34m"
    ;;
  esac
  echo "$@"
  printf "\e[m\n"
}


[[ -f ~/.local/bashrc ]] && source ~/.local/bashrc
