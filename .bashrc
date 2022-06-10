# colors for grep and ls
alias grep='grep --color=auto'
alias ls='ls -G'

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
alias uncd='cd -'
export BINDIR=/usr/local/bin
export LOGDIR=/var/log
alias cdbin="cd $BINDIR"
alias cdlog="cd $LOGDIR"
alias pdbin="pushd $BINDIR"
alias pdlog="pushd $LOGDIR"

# miscellaneous commands
alias c=clear
alias pd=pushd
alias x=exit
alias y='echo -n'  # make y a noop

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
    builtin pushd ~ >/dev/null
  else
    builtin pushd "$@" >/dev/null
  fi
  if [[ $? == 0 ]]
  then
    echo :: $(dirs |cut --only-delimited --delimiter=' ' --fields=2-)
  fi
}
function popd() {
  builtin popd "$@" >/dev/null
  if [[ $? == 0 ]]
  then
    echo :: $(dirs |cut --only-delimited --delimiter=' ' --fields=2-)
  fi
}

# modify interactive sudo (sudo -i) to make it pass along the current directory
# as CDDIR, and shim -i with `sudo su -` on boxes that don't support -i
function sudo() {
  if [[ $1 == -i ]]
  then
    if command sudo -h 2>&1 |grep -q -- -i
    then
      command sudo "$@" CDDIR="`pwd`"
    else
      command sudo /bin/su --login -- root -c \
        "CDDIR='`pwd`' PROFILE_SOURCED= SUDO_USER=$LOGNAME bash --login"
    fi
  else
    command sudo "$@"
  fi
}

# server-local settings
if [[ -f ~/.localrc ]]
then
  source ~/.localrc
fi
