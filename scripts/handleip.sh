#!/bin/bash

# This aims to handle IP Addresses and Network Addresses
_prompt="Expects 1 arg"
[[ $# != 1 ]] && echo $_prompt && exit || true

_address=$1
_addresslist=()
function handleList()
{
    _inaddrs=$1
    IFS=","
    for a in $_inaddrs; do
        _addresslist+=($a)
    done
    IFS=" "
    echo "Address list: ${_addresslist[@]}"
    return 0
}

function handleNet()
{
    _inaddr=$1
    _net=${_inaddr:0:-3}
    _cidr=${_inaddr:$(( ${#_inaddr} - 2 )):3}
    _hosts=$((2 ** ( 32 - $_cidr ) - 2))
    #_y=${_net:$(( ${#net} - 1)):1}
    #_range=" $_y - $(( $_y + $_hosts ))"
    printf "Network address: $_net\nCIDR: $_cidr\nHosts: $_hosts\n"

}

function main()
{
if [[ $_address =~ "," ]]; then
    handleList $_address
else
    printf "IP Address: $_address\n"
fi
if [[ ${#_addresslist[@]} > 1 ]]; then
    for ip in ${_addresslist[@]}; do
        handleNet $ip
    done
elif [[ $_address =~ "/" ]]; then
    handleNet $_address
fi

}
main
