#!/usr/bin/env bash

# This script creates a self launching tarball.
# It takes in two files a shell script and a tar archive.
# The Shell script and the Tar archive will be created and the shell script will be executed.

# Functions
define_colors()
{
    RED="\033[31m"
    GRN="\033[32m"
    YLW="\033[33m"
    BLU="\033[34m"
    MAG="\033[35m"
    CYN="\033[36m"
    GRY="\033[37m"
    WHT="\033[97m"
    NC="\033[0m"
}

print_info()
{
    printf "${CYN}[-] Info: ${1}${NC}\n"
}
print_error()
{
    printf "${RED}[!] Error: ${1}${NC}\n"
}
print_success()
{
    printf "${GRN}[+] Success: ${1}${NC}\n"
}
handle_args()
{
    NUM_ARGS=$#
    MIN_ARGS=2
    MAX_ARGS=3

    if [[ $NUM_ARGS < $MIN_ARGS ]] || [[ $NUM_ARGS > $MAX_ARGS ]]; then
        print_error "Invalid number of arguments provided: ${NUM_ARGS}"
        exit 1
    elif (( ! $(file $1 | grep -c 'shell script') )) ;then
        print_error "First argument must be shell script"
        exit 1
    elif  (( ! $(file $2 | grep -cE 'tar|compressed data') ));then
        print_error "Second argument must be a tar or compressed tar"
        exit 1
    else
        return 0
    fi
}

create_script_tar()
{
    cat > run_me <<SH_EOF
#!/bin/bash
sed '1,3d' \$0 | tar x && bash ./launch ; exit 0
# tar data here
SH_EOF
    tar -c $1 $2 >> run_me
    chmod +x run_me
}

# Main
function main()
{
    define_colors
    handle_args $@
    create_script_tar $1 $2
}

main $@
