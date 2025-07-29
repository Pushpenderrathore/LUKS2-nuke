#!/bin/bash

spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while kill -0 "$pid" 2>/dev/null; do
        for c in / - \\ \|; do
            printf "\r[install] Setting up for Arch-based system... [%c]" "$c"
            sleep $delay
        done
    done
    printf "\r[install] Setting up for Arch-based system... [✔]\n"
}

# Example long-running task (you can replace this with your actual install command)
(sleep 5) &

# Get PID of last background task
spinner $!

