# local profile
[[ -f ~/.local/profile ]] && source ~/.local/profile

# silence annoying messages
export BASH_SILENCE_DEPRECATION_WARNING=1
export DOCKER_CLI_HINTS=false
export HOMEBREW_NO_ENV_HINTS=1

# names
# root or not root
NAME=
[[ $LOGNAME == root ]] && NAME=$LOGNAME@
# get host name if we don't have it already
export HOSTNAME=${HOSTNAME##*@}
[[ -z $HOSTNAME ]] && export HOSTNAME=$(uname -n)
export HOSTNAME=$(echo $HOSTNAME |tr '[:upper:]' '[:lower:]')

# terminal settings
# xterm-256color
export TERM=xterm-256color
export TERMINAL=$TERM
# utf8
export LANG=en_US.UTF-8
export LC_CTYPE=$LANG 2>/dev/null
export LC_ALL=$LANG 2>/dev/null
export LC_ADDRESS=$LANG 2>/dev/null
export LC_COLLATE=$LANG 2>/dev/null
export LC_CTYPE=$LANG 2>/dev/null
export LC_IDENTIFICATION=$LANG 2>/dev/null
export LC_MEASUREMENT=$LANG 2>/dev/null
export LC_MESSAGES=$LANG 2>/dev/null
export LC_MONETARY=$LANG 2>/dev/null
export LC_NAME=$LANG 2>/dev/null
export LC_NUMERIC=$LANG 2>/dev/null
export LC_PAPER=$LANG 2>/dev/null
export LC_TELEPHONE=$LANG 2>/dev/null
export LC_TIME=$LANG 2>/dev/null

# bash settings
# prompts
if [[ $LOGNAME == root ]]
then
  export PS1='`[[ $(jobs -l |wc -l |sed "s/^ *//") != 0 ]] && echo -n "\[\e[0;33m\][\j]\[\e[m\] "; echo -n "\[\e[31m\]'$NAME$HOSTNAME'\[\e[m\]:\w \[\e[31m\]>\[\e[m\] "`'
else
  export PS1='`[[ $(jobs -l |wc -l |sed "s/^ *//") != 0 ]] && echo -n "\[\e[0;33m\][\j]\[\e[m\] "; echo -n "\[\e[36m\]'$NAME$HOSTNAME'\[\e[m\]:\w \[\e[36m\]>\[\e[m\] "`'
fi
export PS2='> '
# allow extra stuff like !(everything_but_this.file)
shopt -s extglob
# vi-style command line editing
set -o vi
# add /usr/local/bin, ~/bin, and current working directory to path
[[ ! $PATH =~ (^|:)/usr/local/bin(:|$) ]] && export PATH=$PATH:/usr/local/bin
export PATH=$PATH:~/bin:.
# history settings
export HISTTIMEFORMAT='%F %T  '
export HISTCONTROL=ignoredups
export HISTIGNORE="c:exit:fg:l:ll:ls:sudo -i:which *:x"

[[ -f ~/.bashrc ]] && FROM_PROFILE=true source ~/.bashrc
[[ -f ~/.local/bash_profile ]] && source ~/.local/bash_profile

# if there's a CDDIR environment variable, cd to that directory
if [[ -n $CDDIR ]]
then
  cd "$CDDIR"
  unset CDDIR
fi
