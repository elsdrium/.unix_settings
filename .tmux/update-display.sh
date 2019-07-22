#!/bin/sh

shell_grep="sh|csh|bash|zsh"

# Update $DISPLAY for each tmux pane that is currently running one of the $shell_grep process
tmux list-panes -s -F "#{session_name}:#{window_index}.#{pane_index} #{pane_current_command}" | \
    grep -E $shell_grep| \
    cut -f 1 -d " " | \
    xargs -I PANE tmux send-keys -t PANE 'eval $(tmux showenv -s DISPLAY)' Enter
