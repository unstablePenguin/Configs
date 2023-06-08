#!/bin/bash

# This script read a name and creates the associated tmux window with it and starts pipe-pane
#read -p "$(tmux list-panes -F "#S:#I.#P")" nul
#read -p "Enter Tmux Session Name: " session
x=$(( $(tput cols) / 2 ))
y=$(( $(tput lines) / 2 ))
tput cup $y $(( $x - 19 ))
tput setaf 1
read -p "How many Windows: " num_wins
[[ -z $num_wins ]] && nums=1
tput clear
for i in $(seq 1 $num_wins); do
    tput cup $y $(( $x - 23 ))
    tput setaf 1
    read -p "Enter Window Title: " title
    tput sgr0
    tput clear
    dir=$(find ~/work -name $title)
    if [[ ! -d $dir ]]; then
        mkdir ~/work/${title}
        dir="~/work/${title}"
    fi
    tmux new-window -n $title
    tmux pipe-pane "cat >> ${dir}/${title}_primary.log"
    tmux split-window -v
    tmux pipe-pane "cat >> ${dir}/${title}_secondary.log"
done
