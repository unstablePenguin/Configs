#!/bin/bash
#
#export PS1="\[\e[33m\]\!\[\e[m\] \[\e[31m\]\u\[\e[m\] \[\e[32m\]\h\[\e[m\]\[\e[31m\][\[\e[m\]\[\e[32m\]\W\[\e[m\]\[\e[31m\]]\[\e[m\]: \e[$(( $(tput cols) - 14))G\[\e[32m\]$(ip r get 1.1.1.1 | cut -d" " -f 3)\[\e[00m\]\n"
#
let MAXW=$(tput cols)
let MAXH=$(tput lines)
let HALFW=$(( $MAXW / 2 ))
let HALFH=$(( $MAXH / 2 ))
_center="\e[${HALFH};${HALFW}H"
_clear="\e[2J"
_home="\e[H"
_noviscur="\e[?25l" #Invisible Cursor
_viscur="\e[?25h"   #Visible Cursor
G="\e[38;5;82m"
Y="\e[38;5;220m"
O="\e[38;5;208m"
R="\e[38;5;196m"
NC="\e[00m"
printf "$_clear"
printf "$_noviscur"
for i in {10..0};do 
    printf "$_clear"
    printf "$_center"
    if [[ $i -ge 8 ]]; then
        printf "${G}${RANDOM}${NC}"
    elif [[ $i -ge 5 ]]; then
        printf "${Y}${RANDOM}${NC}"
    elif [[ $i -ge 3 ]]; then
        printf "${O}${RANDOM}${NC}"
    else
        printf "${R}${RANDOM}${NC}"
    fi
    sleep .2
done
printf "$_viscur"
printf "${_clear}${_home}"
