# Incremental completion for zsh
# by y.fujii <y-fujii at mimosa-pudica.net>, public domain


autoload -U compinit
zle -N self-insert self-insert-incr
zle -N vi-cmd-mode-incr
zle -N vi-backward-delete-char-incr
zle -N vi-backward-kill-word-incr
zle -N backward-delete-char-incr
zle -N expand-or-complete-prefix-incr
zle -N set-no-prediction
zle -N toggle-incr
compinit -u

bindkey -M viins '^[' vi-cmd-mode-incr
bindkey -M viins '^?' vi-backward-delete-char-incr
bindkey -M viins '^H' vi-backward-delete-char-incr
bindkey -M viins '^w' vi-backward-kill-word-incr
bindkey -M viins '^i' expand-or-complete-prefix-incr
bindkey -M viins '^z' set-no-prediction
bindkey -M viins '^u' toggle-incr
bindkey -M viins ' '  self-insert

#unsetopt automenu
compdef -d scp
#compdef -d tar
compdef -d java
compdef -d svn
compdef -d cvs

incr_enabled=1
now_predict=0

function toggle-incr
{
    if [[ "$incr_enabled" ]]; then
        unset incr_enabled
    else
        incr_enabled=1
    fi
}

function limit-completion
{
    if ((compstate[nmatches] <= 1)); then
        zle -M ""
    elif ((compstate[list_lines] > 6)); then
        compstate[list]=""
        zle -M "too many matches. (${compstate[nmatches]} candidates)"
    fi
}

function correct-prediction
{
    if ((now_predict == 1)); then
        if [[ "$BUFFER" != "$buffer_prd" ]] || ((CURSOR != cursor_org)); then
            now_predict=0
        fi
    fi
}

function remove-prediction
{
    if ((now_predict == 1)); then
        BUFFER="$buffer_org"
        now_predict=0
    fi
}

function show-prediction
{
    TILDE_REGEX='( |^)~([a-zA-Z0-9]*)$'
    if
        ((PENDING == 0)) &&
            ((CURSOR > 1)) &&
            [[ "$PREBUFFER" == "" ]] &&
            [[ "$BUFFER[CURSOR]" != " " ]] &&
            [[ ! $BUFFER =~ $TILDE_REGEX ]]
    then
        cursor_org="$CURSOR"
        buffer_org="$BUFFER"
        comppostfuncs=(limit-completion)
        zle complete-word
        cursor_prd="$CURSOR"
        buffer_prd="$BUFFER"
        if [[ "$buffer_org[1,cursor_org]" == "$buffer_prd[1,cursor_org]" ]]; then
            CURSOR="$cursor_org"
            if [[ "$buffer_org" != "$buffer_prd" ]] || ((cursor_org != cursor_prd)); then
                now_predict=1
            fi
        else
            BUFFER="$buffer_org"
            CURSOR="$cursor_org"
        fi
        echo -n "\e[32m"
    else
        zle -M ""
    fi
}

function preexec
{
    echo -n "\e[39m"
}

function set-no-prediction
{
    correct-prediction
    remove-prediction
}

function vi-cmd-mode-incr
{
    correct-prediction
    remove-prediction
    zle vi-cmd-mode
}

function self-insert-incr
{
    correct-prediction
    remove-prediction
    if zle .self-insert; then
        [[ "$incr_enabled" ]] && show-prediction
    fi
}

function vi-backward-delete-char-incr
{
    correct-prediction
    remove-prediction
    if zle vi-backward-delete-char; then
        [[ "$incr_enabled" ]] && show-prediction
    fi
}

function vi-backward-kill-word-incr
{
    correct-prediction
    remove-prediction
    if zle vi-backward-kill-word; then
        [[ "$incr_enabled" ]] && show-prediction
    fi
}

function backward-delete-char-incr
{
    correct-prediction
    remove-prediction
    if zle backward-delete-char; then
        [[ "$incr_enabled" ]] && show-prediction
    fi
}

function expand-or-complete-prefix-incr
{
    correct-prediction
    if ((now_predict == 1)); then
        CURSOR="$cursor_prd"
        now_predict=0
        comppostfuncs=(limit-completion)
        zle list-choices
    else
        remove-prediction
        zle expand-or-complete-prefix
    fi
}
