# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# If .profile exist
#[[ -f ~/.profile ]] && . ~/.profile 

# History control variables
export HISTCONTROL=ignoreboth
export HISTSIZE=30000
export HISTFILESIZE=-1
export HISTTIMEFORMAT="%F %T "

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" -a -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

TERM="screen-256color"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color)
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    ;;
*)
    #PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    PS1='${debian_chroot:+($debian_chroot)}\W\$ '
    ;;
esac

# Comment in the above and uncomment this below for a color prompt
#PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# If this is an xterm set the title to user@host:dir
# case "$TERM" in
# xterm*|rxvt*)
#     PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
#     ;;
# *)
#     ;;
# esac
 
# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

#export SVN_SSH="ssh -p 6868"

# ssh-agent shared 
#SSH_ENV="$HOME/.ssh/ssh.env"
#if [[ -z $(pgrep ssh-agent) ]]; then
#    ssh-agent | head -n 2 > $SSH_ENV
#    eval "$(cat $SSH_ENV)"
#else
#    [[ -f $SSH_ENV ]] && eval $(cat $SSH_ENV) 
#fi
#ssh-add ~/.ssh/github

# Nautilus desktop crash openbox
alias nautilus="nautilus --no-desktop"
alias nemo="nemo --no-desktop"
#alias rm='trash-put'
alias tmux='tmux -u'
alias grep='grep --color'
alias egrep='egrep --color'
alias sudo_env='sudo env PATH=$PATH'
alias latexmkspeciale="grep -l '\\documentclass' *tex | xargs latexmk -pdf -pvc -silent"
alias ll="ls -lh"
alias f="find . -iname "

# Fedora
alias vim='vimx'

# eclim daemon
#/opt/eclipse/eclimd

export USE_CCACHE=1

# Eli Bendersky
# https://github.com/eliben/code-for-blog/blob/master/2016/persistent-history/add-persistent-history.sh
log_bash_persistent_history()
{
  local rc=$?
  [[ $(history 1) =~ ^\ *[0-9]+\ +([^\ ]+\ [^\ ]+)\ +(.*)$ ]]
  local date_part="${BASH_REMATCH[1]}"
  local command_part="${BASH_REMATCH[2]}"
  if [ "$command_part" != "$PERSISTENT_HISTORY_LAST" ]
  then
    echo $date_part "|" "$command_part" >> ~/.persistent_history
    export PERSISTENT_HISTORY_LAST="$command_part"
  fi
}

# Stuff to do on PROMPT_COMMAND
run_on_prompt_command()
{
    log_bash_persistent_history
}

PROMPT_COMMAND="run_on_prompt_command"

# IBM
qemubuildppcfamily()
{
    ../configure --target-list=ppc-linux-user,ppc64-linux-user,ppc64le-linux-user,ppc-softmmu,ppc64-softmmu \
                 --enable-debug-info --enable-trace-backends=ust && make -j $(nproc)
}

qemubuildx86family()
{
    ../configure --target-list=x86_64-linux-user,x86_64-softmmu \
                 --enable-debug-info --enable-trace-backends=ust && make -j $(nproc)
}

alias qemuclean='gitdir=$(git rev-parse --show-toplevel) && cd $gitdir &&
                 git submodule deinit -f --all && git clean -dfx &&
                 mkdir build && cd build'


