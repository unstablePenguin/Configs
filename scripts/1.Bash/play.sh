#!/bin/bash
#
W=$(tput cols)
H=$(tput lines)

for x in $(seq 1 $H);do
	printf "\e[$x;0H"
	if [[ $x == 1 ]]; then
		for i in $(seq 1 $W);do
            	    printf "\e[${i}G\e[47m0\e[m"
                done
		
	elif [[ $x == $H ]]; then
		for i in $(seq 1 $W);do
            	    printf "\e[${i}G\e[47m0\e[m"
                done
		
	elif [[ $(($x % 2)) == 0 ]];then
		for i in $(seq 1 $W);do
		if [[ $i == 1 ]]; then
            	    printf "\e[${i}G\e[47m0\e[m"
		elif [[ $i == $W ]]; then
            	    printf "\e[${i}G\e[47m0\e[m"
            	elif [[ $(($i % 2)) == 0 ]]; then
            	    printf "\e[${i}G\e[5;47m0\e[m"
            	else
            	    printf "\e[${i}G\e[5;40m0\e[m"
            	fi
                done

        else
		for i in $(seq 1 $W);do
            	if [[ $(($i % 2)) == 1 ]]; then
            	    printf "\e[${i}G\e[47m0\e[m"
		elif [[ $i == $W ]]; then
            	    printf "\e[${i}G\e[47m0\e[m"
            	else
            	    printf "\e[${i}G\e[5;40m0\e[m"
            	fi
                done
        fi
done
