#!/bin/bash

# This Script creates wireguard servers and peers
# By default this script creates the keys and configurations in a server directory

#Colors
R="\033[0;31m"
G="\033[0;32m"
NC="\033[00m"

USAGE="Usage: $0 {Endpoint IP} {Port} {Remote Network} [# of clients]"
SERVER=""
num_clients=$4
ENDPOINT=$1
REMOTE_NET=$3
[[ $2 < 65536 && $2 > 1024 ]] && PORT=$2 || PORT=51820
# Checks for Args more than 1.
if [[ $# -gt 4 || $# -lt 3 ]]; then
	printf "${R}[E] $USAGE${NC}\n"
	exit 1
fi
# If num_clients is not set. Set to 2
[ -v $4 ] && num_clients=2 || num_clients=$4

# Server Creation
function mkServer()
{
    # Create Server Directory
    printf "${G}[S] Creating Server Directory${NC}\n"
    declare -rg SERVER=Server-${RANDOM}
    mkdir $SERVER 2>/dev/null && printf "${G}[S] ${SERVER} Directory Created${NC}\n"|| printf "${R}[E] Failed to create directory ${SERVER}${NC}\n"
    # Create Server keys
    printf "${G}[S] Generating Server Keys${NC}\n"
    cd $SERVER
    /usr/bin/wg genkey | (umask 0077 && tee ${SERVER}.key) | wg pubkey > ${SERVER}.pub
    # Create Server Config
    printf "${G}[S] Compiling Server Configuration${NC}\n"
    cat << EOF >> ${SERVER}.conf
[Interface]
Address = 10.66.66.1/24
ListenPort = $PORT
PrivateKey = $(cat ${SERVER}.key)
EOF

    return 0
}

# Client Creation
function mkClient()
{
    client=client${1}
    addr=10.66.66.$(( 1 + $1 ))
    # Create Client keys
    printf "${G}[S] Generating Client Keys${NC}\n"
    /usr/bin/wg genkey | (umask 0077 && tee ${client}.key) | wg pubkey > ${client}.pub
    # Create Client Config
    printf "${G}[S] Compiling Client Configuration${NC}\n"
    cat << EOF >> ${client}.conf
[Interface]
Address = ${addr}/32
PrivateKey = $(cat ${client}.key)

[Peer]
PublicKey = $(cat ${SERVER}.pub)
Endpoint = ${ENDPOINT}:${PORT}
AllowedIPs = $REMOTE_NET
EOF
    # Add Client to Server Config
    printf "${G}[S] Adding Client to Server Configuration${NC}\n"
    cat << EOF >> ${SERVER}.conf
[Peer]
PublicKey = $(cat ${client}.pub)
AllowedIPs = ${addr}/32
EOF

    return 0
}
function cleanup()
{
    mkdir private public
    mv *.key private/
    mv *.pub public/
}
#Cause Why not
function main()
{
    printf "${G}[S] Calling mkServer()${NC}\n"
    mkServer
    [ $? ] && printf "${G}[S] Server Creation Successfully Completed.\n" || printf "${R}[E] Failed to Create Server.${NC}\n"
    for(( i=1; i <= $num_clients; i++ )); do
	printf "${G}[S] Creating Client $i${NC}\n"
	mkClient $i
	printf "${G}[S] Client ${i} Created Successfully${NC}\n"
    done
    cleanup
    printf "${G}[S] Completed $num_clients clients.${NC}\n"
}
main
exit 0
