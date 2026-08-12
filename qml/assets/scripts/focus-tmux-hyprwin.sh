#!/usr/bin/env bash
addr="$(hyprctl clients -j | jq -r ".[] | select(.pid == $($(dirname "${BASH_SOURCE[0]}")/find-tmux-hyprwin.sh "$1")) | .address")"
hyprctl dispatch "hl.dispatch(hl.dsp.focus({ window = \"address:$addr\" }))"
