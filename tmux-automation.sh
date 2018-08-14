#!/bin/bash

# TARGET_WIN=
# TARGET_PANE=
# SEND_KEYS=

if [[ -z ${TARGET_WIN} ]]; then
    TARGET_WIN="0"
fi

if [[ -z ${TARGET_PANE} ]]; then
    TARGET_PANE="0:${TARGET_WIN}.0"
fi

if [[ -z ${SEND_KEYS} ]]; then
    SEND_KEYS="make"
fi

tmux select-window -t "$TARGET_WIN"
tmux select-pane -t "$TARGET_PANE"
tmux send-keys -t "$TARGET_PANE" "$SEND_KEYS" Enter
