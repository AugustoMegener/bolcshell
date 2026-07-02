#!/usr/bin/env bash

hyprctl dispatch focuswindow "address:$(hyprctl clients -j | jq -r ".[] | select(.pid == $($(dirname "${BASH_SOURCE[0]}")/find-tmux-hyprwin.sh "$1")) | .address")"
