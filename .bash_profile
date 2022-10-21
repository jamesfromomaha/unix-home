# sometimes the local machine needs to apply profile stuff before the common set
if [[ -f ~/.local_preprofile ]]
then
  source ~/.local_preprofile
fi

# names
# root or not root
NAME=
if [[ $LOGNAME == root ]]
then
  NAME=$LOGNAME@
  export HOME=~jwhite
  cd
fi
cd
# get host name if we don't have it already
export HOSTNAME=${HOSTNAME##*@}
if [[ -z $HOSTNAME ]]
then
  export HOSTNAME=$(uname -n)
fi
export HOSTNAME=$(echo $HOSTNAME |tr '[:upper:]' '[:lower:]')

# terminal settings
# xterm-256color
export TERM=xterm-256color
export TERMINAL=$TERM
# utf8
export LANG=en_US.utf8
export LC_ADDRESS=$LANG
export LC_COLLATE=$LANG
export LC_CTYPE=$LANG
export LC_IDENTIFICATION=$LANG
export LC_MEASUREMENT=$LANG
export LC_MESSAGES=$LANG
export LC_MONETARY=$LANG
export LC_NAME=$LANG
export LC_NUMERIC=$LANG
export LC_PAPER=$LANG
export LC_TELEPHONE=$LANG
export LC_TIME=$LANG

# bash settings
# prompts
if [[ $LOGNAME == root ]]
then
  export PS1='`[[ $(jobs -l |wc -l |sed "s/^ *//") != 0 ]] && echo -n "\[\e[0;33m\][\j]\[\e[m\] "; echo -n "\[\e[31m\]'$NAME$HOSTNAME'\[\e[m\]:\w \[\e[31m\]>\[\e[m\] "`'
else
  export PS1='`[[ $(jobs -l |wc -l |sed "s/^ *//") != 0 ]] && echo -n "\[\e[0;33m\][\j]\[\e[m\] "; echo -n "\[\e[36m\]'$NAME$HOSTNAME'\[\e[m\]:\w \[\e[36m\]>\[\e[m\] "`'
fi
export PS2='> '
# ignore case when globbing
shopt -s nocaseglob extglob
# vi-style command line editing
set -o vi
# add /usr/local/bin, ~/bin, and current working directory to path
if [[ ! $PATH =~ (^|:)/usr/local/bin(:|$) ]]
then
  export PATH=$PATH:/usr/local/bin
fi
export PATH=$PATH:~/bin:.
# history settings
export HISTTIMEFORMAT='%F %T  '
export HISTCONTROL=ignoredups
export HISTIGNORE="c:exit:fg:l:ll:ls:sudo -i:which *:x"

# rc file
if [[ -f ~/.bashrc ]]
then
  source ~/.bashrc
fi

# bash
if [[ -f ~/.local_profile ]]
then
  source ~/.local_profile
fi

# if there's a CDDIR environment variable, cd to that directory
if [[ -n $CDDIR ]]
then
  cd "$CDDIR"
  unset CDDIR
fi
