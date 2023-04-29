#!/bin/bash

# This fixes screen resolution
#Colors
warn="\033[31;1;4m"
reset="\033[0m"
red="\033[31m"
green="\033[32m"
blue="\033[34m"
yellow="\033[33m"
purple="\033[35m"


PROMPT="${warn}Usage:${reset}${green} $(basename $0)${yellow} {Length} {Height} {refresh rate}${reset}\nExample:${green} $(basename $0)${yellow} 2560 1080 144${reset}\n"

if [[ $# -lt 3 ]]; then
    printf "$PROMPT"
    exit 1
else
    w=$1
    h=$2
    ref=$3
    x=0
    for i in $@; do
        if [[ i -gt 0 ]]; then
            (( x++ ))
        fi
    done
    if [[ $x -lt 3 ]];then
        printf "${warn}Error: invalid arguments.${reset}\n${PROMPT}"
        exit 1
    fi
    modeline=$(/bin/cvt $w $h $ref 2>/dev/null| grep Mode | cut -d ' ' -f 2- )
    mode=$(echo $modeline | awk '{print $1}')
    display=$(/bin/xrandr | awk '/ connected/{print $1}')

    xrandr --newmode $modeline
    xrandr --addmode $display $mode
    xrandr --output $display --mode $mode
    exit 0

fi
