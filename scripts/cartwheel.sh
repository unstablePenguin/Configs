#!/bin/bash
#
#|-----------------------------------------------------------------------|
#|    o   \ o /  _ o         __|    \ /     |__        o _  \ o /   o    |
#|   /|\    |     /\   ___\o   \o    |    o/    o/__   /\     |    /|\   |
#|   / \   / \   | \  /)  |    ( \  /o\  / )    |  (\  / |   / \   / \   |
#|-----------------------------------------------------------------------|

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
s0='\u0030\e[1B\e[2D\u002f\u007c\u005c\e[1B\e[3D\u002f\u0020\u005c'
s1="\e[1D\u005c\u0030\u002f\e[1B\e[2D\u007c\e[1B\e[2D\u002f\u0020\u005c"
s2="\e[1D\u005f\e[1C0\e[1B\e[2D\u002f\u005c\e[1B\e[3D\u007c\u0020\u005c"
s3="\e[1B\e[1D\u005f\u005f\u005f\u005c\u0030\e[1B\e[6D\u002f\u0028\u0020\u0020\u007c"
s4="\e[2D\u005f\u005f\u007c\e[1B\e[1D\u005c\u0030\e[1B\e[2D\u0028\u0020\u005c"
s5="\e[1D\u005c\u0020\u002f\e[1B\e[2D\u007c\e[1B\e[2D\u002f\u0030\u005c"
s6="\e[2C\u007c\u005f\u005f\e[1B\e[5D\u0030\u002f\e[1B\e[3D\u002f\u0020\u0029"
s7="\e[1B\e[1D0\u002f\u005f\u005f\e[1B\e[4D\u007c\u0020\u0020\u0028\u005c"
s8="\e[1D\u0030\u0020\u005f\e[1B\e[3D\u002f\u005c\u0020\e[1B\e[3D\u002f\u0020\u007c"
_seq=($s0 $s1 $s2 $s3 $s4 $s5 $s6 $s7 $s8 $s1 $s0)
_colors=($G $Y $O $R)

function draw()
{
    printf "$_clear"
    printf "$_center"
    printf "$1"
}
printf "$_noviscur"
while true; do
    for i in ${_colors[@]}; do
	    _C=$i
        for i in ${_seq[@]}; do 
            draw "${_C}${i}${_NC}"
    	sleep .1
        done
    done
    read -t 0.1 -N 1 input
    [[ $input == "q" ]] && break
done
printf "${_clear}${_home}"
printf "$_viscur"
