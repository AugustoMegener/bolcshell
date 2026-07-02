#!/usr/bin/env bash

declare -A procs
while read -r pid comm; do
    procs["$pid"]="$comm"
done < <(
    ps -o pid=,comm= -t "$(tmux list-clients -t "$1" -F "#{client_tty}" |
        sed 's#^/dev/##' |
        paste -sd,)"
)

find_terminal_pid() {
    local pid=$1
    local comm
    while (( pid > 1 )); do
        comm=$(ps -o comm= -p "$pid" 2>/dev/null)
        case "$comm" in
            *kitty*|*foot*|*alacritty*|*wezterm*|*xterm*|*konsole*|*urxvt*|*st)
                echo "$pid"
                return 0
                ;;
        esac
        pid=$(ps -o ppid= -p "$pid" 2>/dev/null)
        pid=${pid//[[:space:]]/}
        [[ -z $pid ]] && return 1
    done
    return 1
}

for pid in "${!procs[@]}"; do
    result=$(find_terminal_pid "$pid")
    if [[ -n $result ]]; then
        echo "$result"
        break
    fi
done
