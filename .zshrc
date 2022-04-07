# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
unset SSH_AUTH_SOCK

# Disable ctrl-s freezing
stty -ixon
# Reserve ctrl-h
stty erase '^?'

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="bureau_custom"

export platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
    export platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
    export platform='osx'
elif [[ "$unamestr" == 'FreeBSD' ]]; then
    export platform='freebsd'
fi

# Notification for long-running commands
precmd () {
    echo -n -e "\a"
}

start_time=$SECONDS
function estimate_time_preexec {
    start_time=$SECONDS
}

function estimate_time_precmd {
    timer_result=$(( $SECONDS - $start_time ))
    if [[ $timer_result -gt 3 ]]; then
        calc_elapsed_time
    fi
    start_time=$SECONDS
}

function calc_elapsed_time {
if [[ $timer_result -ge 3600 ]]; then
    let "timer_hours = $timer_result / 3600"
    let "remainder = $timer_result % 3600"
    let "timer_minutes = $remainder / 60"
    let "timer_seconds = $remainder % 60"
    print -P "%B%F{red}>>> elapsed time ${timer_hours}h${timer_minutes}m${timer_seconds}s%b"
elif [[ $timer_result -ge 60 ]]; then
    let "timer_minutes = $timer_result / 60"
    let "timer_seconds = $timer_result % 60"
    print -P "%B%F{yellow}>>> elapsed time ${timer_minutes}m${timer_seconds}s%b"
elif [[ $timer_result -gt 3 ]]; then
    print -P "%B%F{green}>>> elapsed time ${timer_result}s%b"
fi
}


autoload -Uz add-zsh-hook

add-zsh-hook preexec estimate_time_preexec
add-zsh-hook precmd estimate_time_precmd

zstyle :omz:plugins:ssh-agent agent-forwarding on
zstyle :omz:plugins:ssh-agent identities id_rsa id_github id_bitbucket

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git gitfast github vi-mode ssh-agent sudo incr)
# optional plugins: mix aws

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

setopt AUTO_PUSHD
setopt GLOB_COMPLETE
setopt PUSHD_MINUS
setopt PUSHD_TO_HOME
setopt NO_BEEP
setopt NO_CASE_GLOB


bindkey -M vicmd "q" push-line
bindkey -M viins ";;" vi-cmd-mode
bindkey -M viins "^B" vi-backward-word
bindkey -M viins "^F" vi-forward-word

export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
export FZF_DEFAULT_COMMAND='ag -g ""'
export FZF_CTRL_T_COMMAND='ag -g ""'

if [[ $platform == 'osx' ]]; then
    export PATH="/Users/$USER/.local/bin:/usr/local/opt/go/libexec/bin:/usr/local/opt/python@2/libexec/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin"
    export PATH="/Users/elsdrium/Library/Python/3.8/bin:$PATH"

    alias l='ls -hpG'
    alias ls='ls -hpG'
    alias ll='ls -hlpGA'
    alias la='ls -pGA'

    # iTerm2 support
    alias imgcat=~/.iterm2/imgcat

else # Linux
    export PATH="~/.local/bin:/usr/local/bin:/usr/games:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"
    export LD_LIBRARY_PATH="/usr/local/lib64:/usr/local/lib:/usr/lib64:/usr/lib"

    alias l='ls --color=auto -hp'
    alias ls='ls --color=auto -hp'
    alias ll='ls --color=auto -hlpA'
    alias la='ls --color=auto -pA'
    alias rdwin='rdesktop -g 1620x980'
    #alias rs='rsync -av -e ssh elsdrm@140.109.135.120:/Users/elsdrm/Dropbox/.unix_settings /home/elsdrm'
    alias sag='sudo apt-get'
    alias acs='apt-cache search'
    alias sy='sudo yum'

    # system management
    alias dstat='dstat -cdlmnpsy'
    alias dus='du -smh' # disk usage summary
    alias xopen='xdg-open'
    alias gir='grep -ir'
    alias pscount="ps --no-headers auxwwwm | cut -f1 -d' ' | sort | uniq -c | sort -n"
fi

function findcpp {
    TARGET=$([[ $1 = /*  ]] && echo "$1" || echo "$PWD/${1#./}")
    find $TARGET -type f \
        -iname '*.c' -o -iname '*.C' -o -iname '*.cpp' -o -iname '*.cxx' -o -iname '*.cc' -o -iname '*.c++' -o \
        -iname '*.h' -o -iname '*.H' -o -iname '*.hpp' -o -iname '*.hxx' -o -iname '*.hh' -o -iname '*.h++' -o \
        -iname '*.inl'
}

alias tree='tree -f'
alias grep='grep --color=auto -n'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias fpp='fpp --keep-open'
alias less='less -r'
alias nv='nvim'
alias nvdiff='nvim -d'
alias rv='$EDITOR +PlugUpdate +qall'
alias rrv='$EDITOR +PlugClean +PlugUpdate +PlugInstall +qall'
alias ev='$EDITOR ~/.vimrc'
alias rz='source ~/.zshrc'
alias ez='$EDITOR ~/.zshrc'
alias et='$EDITOR ~/.tmux.conf'
alias vv='$EDITOR -c "normal '\''0"'
alias clearenv="unset \$(env | awk -F'=' '{print \$1}')"
alias ssh='TERM=xterm-256color ssh -X'
alias tmux='TERM=xterm-256color tmux -2 -u'
# alias vnc=xvnc4viewer -FullColor
# alias cuda='clang++ -std=c++11 -I/usr/local/cuda/include -L/usr/local/cuda/lib64 -lcudart --cuda-gpu-arch=sm_30'
alias p3u='sudo -H pip3 install --upgrade'
alias ipy='ipython3'
unalias grv

pushd()
{
    if [ $# -eq 0 ]; then
        DIR="${HOME}"
    else
        DIR="$1"
    fi

    builtin pushd "${DIR}" > /dev/null
}

popd()
{
    builtin popd > /dev/null
}

alias cd='pushd'
alias bd='popd'

# neovim is preferred, otherwise fall back to vi
if ! type nvim >& /dev/null; then
    export VISUAL="vim"
    export EDITOR="vim"
else
    export VISUAL="nvim"
    export EDITOR="nvim"
fi

v() {
    args=("$@")
    for file in "${args[@]}"; do
        [[ $file = -* ]] && continue   # Ignore options
        [[ $file = +* ]] && continue   # Ignore vim commands

        if ! [[ -e $file ]]; then
            printf '%s: cannot access %s: No such file or directory\n' "$EDITOR" "$file" >&2
            return 1
        fi
    done

    if [[ "$#" = "1" ]] && [[ "$@" = "-" ]]; then
        vv
    else
        # Use `command' to invoke the vim binary
        command "$EDITOR" "${args[@]}"
    fi
}

NORMAL_SYMBOL='@'
INSERT_SYMBOL='@'
#alias ndrun='nvidia-docker run -t -i -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --rm' # run Nvidia docker with X11 GUI
#
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
