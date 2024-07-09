#!/bin/bash

# Add New remote machine to ssh_config generate ssh key and transfer id
# Requires sshpass and ssh option IdentitiesOnly yes in .ssh/config
# Ensure IdentitiesOnly is in your .ssh/config

#Colors
warn="\033[31;1;4m"
reset="\033[0m"
red="\033[31m"
green="\033[32m"
blue="\033[34m"
yellow="\033[33m"
purple="\033[35m"

DISTRO=$(/bin/grep -E '^ID=\w+\b' /etc/os-release | cut -d = -f 2)
case $DISTRO in
    arch ) # For Arch Linux
        /bin/pacman -Q sshpass >/dev/null 2>&1
        if [[ $? == 1 ]]; then
            printf "${warn}[Warning]${reset}sshpass is required. ${blue}Please install it:\n${green}sudo pacman -S sshpass${reset}\n"
            exit 1
        fi
        ;;
    debian )
        /bin/dpkg -l sshpass 2>&1 >/dev/null
        if [[ $? == 1 ]]; then
            printf "${warn}[Warning]${reset}sshpass is required. ${blue}Please install it:\nsudo apt install sshpass\n"
            exit 1
        fi
        ;;
    ubuntu )
        /bin/dpkg -l sshpass 2>/dev/null
        if [[ $? == 1 ]]; then
            printf "${warn}[Warning]${reset}sshpass is required. ${blue}Please install it:\nsudo apt install sshpass\n"
            exit 1
        fi
        ;;
    "centos" )
        /bin/rpm -qa | /bin/grep sshpass 1>/dev/null
        if [[ $? == 1 ]]; then
            printf "${warn}[Warning]${reset}sshpass is required. ${blue}Please install it:\nsudo yum install sshpass\n"
            exit 1
        fi
        ;;
esac
# Check for .ssh/config and IdentitiesOnly
if [[ -s $HOME/.ssh/config ]]; then
    /bin/grep 'IdentitiesOnly yes' $HOME/.ssh/config >/dev/null 2>&1
    if [[ $? == 1 ]]; then
        printf "${warn}[Warning]${red} IdentitiesOnly yes is required in $HOME/.ssh/config.\n${green} Please add it and rerun.${reset}\n"
        exit 1
    fi
else
    printf "${warn}Warning:${reset}${red} You do not have a $HOME/.ssh/config or it is empty.\n${green} Please: man ssh to educate yourself on ssh. Have a nice day;)${reset}\n"
fi
# There is something strange going on with the prompt I have removed the variable to fix it.
#PROMPT="${warn}Usage:${reset} ${green}$(basename $0) ${blue}\[-J\(jumphosts\)\]${red} \{Nickname\}${yellow} \{Username\} \{Password\}${purple} \{IPAddress\} \{Port\}${reset}\n"
#PROMPT='Usage: $(basename $0) [-J(jumphosts)] {Nickname} {Username} {Password} {IPAddress} {Port}\n'

while getopts "J:h" option; do
    case ${option} in
        J ) # For -J
            JUMPHOSTS=$OPTARG
            ;;
        h ) # For -h
            #printf "\033[41;1;4mDon't be stupid${reset}\n"
            printf "\033[41;1;4mDon't be stupid${reset}\n"
            printf "${warn}Usage:${reset} ${green}$(basename $0) ${blue}[-J(jumphosts)]${red} {Nickname}${yellow} {Username} {Password}${purple} {IPAddress} {Port}${reset}\n"
            exit 1
            ;;
        \? ) # For Invalid Inputs
            printf "${warn}Use:${reset}[-J | -h]\n"
            exit 1
    esac
done
    shift  $(expr $OPTIND - 1)

if [ $# -lt 4 ]; then
    printf "${warn}Usage:${reset} ${green}$(basename $0) ${blue}[-J(jumphosts)]${red} {Nickname}${yellow} {Username} {Password}${purple} {IPAddress} {Port}${reset}\n"
    exit 1
fi
# Set Positional Args to VARS
NAME=$1
USER=$2
PASSWORD=$3
IP=$4
[ -v $5 ] && PORT="22" || PORT=$5 # If port is not set. Set to 22
IDFILE="$HOME/.ssh/$NAME"

ssh-keygen -f $IDFILE -q </dev/null
if [ $? ]; then
    if [ -v $JUMPHOSTS ]; then
        sshpass -p $PASSWORD ssh-copy-id -f -p $PORT -i $IDFILE $USER@$IP
        if [ $? == 0 ]; then
        printf "Host $NAME\n    Hostname $IP\n    Port $PORT\n    User $USER\n    IdentityFile $IDFILE\n\n" >> ~/.ssh/config
        else
            printf '${warn}[ERROR]${reset}${red} Unable to transfer ssh id.\n${warn}[Warning]${reset} Ensure IdentitiesOnly is in your ~/.ssh/config. Failure to do so will result in being locked out.${reset}\n'
            exit 1
        fi
    else
        sshpass -p $PASSWORD ssh-copy-id -f -o ProxyJump=$JUMPHOSTS -p $PORT -i $IDFILE $USER@$IP
        if [ $? == 0 ]; then
            printf "Host $NAME\n    Hostname $IP\n    Port $PORT\n    User $USER\n    ProxyJump $JUMPHOSTS\n    IdentityFile $IDFILE\n\n" >> ~/.ssh/config
        else
            printf '${warn}[ERROR]${reset} Unable to transfer ssh id.\n${warn}[Warning]${reset} ${red}Ensure IdentitiesOnly is in your ~/.ssh/config. Failure to do so will result in being locked out.${reset}\n'
            exit 1
        fi
    fi
fi
exit 0
