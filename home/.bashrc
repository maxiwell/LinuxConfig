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
    PS1='\u@\h:\W\$ '
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
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion   # Fedora
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion                         # Debian/Ubuntu
    fi
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

# Garante os bins locais mesmo em shell não-login (ex: painéis do herdr/tmux
# cujo server foi iniciado sem passar pelo ~/.profile)
for d in "$HOME/.local/bin" "$HOME/.local/usr/bin"; do
    case ":$PATH:" in *":$d:"*) ;; *) PATH="$d:$PATH";; esac
done
unset d

# Remove PATH duplicates
PATH=$(printf %s "$PATH" | awk -v RS=: -v ORS=: '{ if (!arr[$0]++) { print $0 } }')

export EDITOR=vim
export GIT_EDITOR=$EDITOR
export VISUAL=$EDITOR

export LANG=en_US.UTF8
export LC_ALL=en_US.UTF8

# Comment the NVM block to launch the bash faster
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm use 20 &> /dev/null

export CONAG_PROJ=$HOME/devel/rasgado/
#grepc() {
#    grep -RIi \
#        --exclude-dir=vendor \
#        --exclude-dir=modules \
#        --exclude-dir=.tags \
#        --exclude='*.php*' \
#        -e "$1" \
#        $CONAG_PROJ $CONAG_PROJ/public/assets/js
#    }

alias fc="find $CONAG_PROJ -iname "
alias f="find . -iname "
alias cdc="cd $CONAG_PROJ"

alias v="code -r"

# herdr: sem as vars de SSH ele copia via xclip (X11 forwarding) em vez de OSC 52, que o terminal local ignora
alias herdr='env -u SSH_CONNECTION -u SSH_TTY herdr'
# herdr: o Claude Code não reconhece TERM_PROGRAM=herdr e imprime caminhos como texto puro;
# com links OSC 8 o Ctrl+clique abre o arquivo no vim (plugin local-plugins/open-in-vim)
[[ $TERM_PROGRAM == herdr ]] && export FORCE_HYPERLINK=1

wtmux() {
  if [ -z "$1" ]; then
    echo "uso: wtmux <caminho-do-worktree>"
    return 1
  fi
  local dest
  dest=$(realpath "$1") || return 1
  if [ ! -d "$dest" ]; then
    echo "diretório não existe: $dest"
    return 1
  fi

  local session
  session=$(tmux display-message -p '#{session_name}')

  local p path root rel target
  while IFS=$'\t' read -r p path; do
    # descobre a raiz do worktree onde o pane está
    root=$(git -C "$path" rev-parse --show-toplevel 2>/dev/null)
    if [ -n "$root" ]; then
      rel=${path#"$root"}        # sufixo relativo, ex: /src/foo
      target="$dest$rel"
    else
      target="$dest"             # pane fora de um git worktree → vai pra raiz do novo
    fi
    # se o subdir não existir no novo worktree, cai na raiz
    [ -d "$target" ] || target="$dest"
    tmux send-keys -t "$p" " cd \"$target\"" C-m
  done < <(tmux list-panes -s -t "$session" -F '#{pane_id}'$'\t''#{pane_current_path}')
}

# Propaga cd pra todos os panes da sessao (mantendo sufixo relativo dentro do worktree)
# e atualiza o OSC 7 do terminal externo (VSCode) pra usar como base de paths relativos.
wt() {
    if [ -z "$1" ]; then
        echo "uso: wt <dir>" >&2
        return 1
    fi
    local dest
    dest=$(realpath "$1") || return 1
    if [ ! -d "$dest" ]; then
        echo "diretorio nao existe: $dest" >&2
        return 1
    fi

    local osc7
    printf -v osc7 '\033]7;file://%s%s\033\\' "${HOSTNAME}" "$dest"

    if [ -n "$TMUX" ]; then
        local session
        session=$(tmux display-message -p '#{session_name}')

        local p path root rel target
        while IFS=$'\t' read -r p path; do
            root=$(git -C "$path" rev-parse --show-toplevel 2>/dev/null)
            if [ -n "$root" ]; then
                rel=${path#"$root"}
                target="$dest$rel"
            else
                target="$dest"
            fi
            [ -d "$target" ] || target="$dest"
            tmux send-keys -t "$p" " cd \"$target\"" C-m
        done < <(tmux list-panes -s -t "$session" -F '#{pane_id}'$'\t''#{pane_current_path}')

        # OSC 7 via DCS passthrough do tmux: escapes internos viram \e\e
        printf '\033Ptmux;%s\033\\' "${osc7//$'\033'/$'\033\033'}"
    else
        cd "$dest" || return 1
        printf '%s' "$osc7"
    fi
}

# Igual ao wt, mas tambem renomeia a sessao do tmux com o nome do diretorio destino.
wts() {
    if [ -z "$1" ]; then
        echo "uso: wts <dir>" >&2
        return 1
    fi
    wt "$1" || return 1

    if [ -n "$TMUX" ]; then
        local dest name
        dest=$(realpath "$1") || return 1
        # tmux nao aceita '.' nem ':' em nomes de sessao
        name=$(basename "$dest")
        name=${name//[.:]/_}
        tmux rename-session "$name"
    fi
}

# opencode
export PATH=$HOME/.opencode/bin:$PATH

# hermes: CLI do Hermes Agent (container hermes-poc, /srv/ai-lab)
#   hermes -p ws-rasgado chat        conversa interativa
#   hermes -p ws-rasgado -z "..."    pergunta única
# Só define se não houver um executável hermes no PATH (type -P ignora funções e aliases)
if ! type -P hermes >/dev/null; then
    hermes() {
        local tty=(-i); [ -t 0 ] && [ -t 1 ] && tty=(-it)
        HERDR_AGENT=hermes docker exec "${tty[@]}" -u 1000:1000 hermes-poc /opt/hermes/.venv/bin/hermes "$@"
    }
fi
