#!/bin/bash

# Global 
_ipvalid=1
# Utility
alpha=('' {a..z})
usedvars=()
# Break-out IP address or Network
function handleinput()
{
ip=$1
if [[ $ip =~ "," ]]; then
    IFS=","
    cnt=0
    for i in $ip; do
        validip ${i%/*}
        if [[ $? == 0 ]];then
            # Holds IPs and info
            #declare -g -A a=( [address]=${i%/*} [net]=${i} [threeoctets]=${i%.*} [cidrs]=${i#*/} )
            address=${i%/*}
            net=${i}
            threeoct=${i%.*}
            cidrs=${i#*/}
            # Calculate Subnet
            tmpcidr=${i#*/}
            tmp=${i##*.}
            host=${tmp%/*}
            step=$((2 ** (32 - $tmpcidr) ))
            IFS=" "
            tmplist=($(seq -s " " 0 $step 256))
            # Get ranges
            for (( idx=0;idx < ${#tmplist[@]}; idx++ )) ;do
                if [[ $host -ge ${tmplist[$idx]} ]] && [[ $host -le ${tmplist[$idx+1]} ]]; then
                    #declare -g -A a+=([range]="$(( ${tmplist[$idx]} + 1 )) $(( ${tmplist[$idx+1]} - 1 ))")
                    range="$(( ${tmplist[$idx]} + 1 )) $(( ${tmplist[$idx+1]} - 1 ))"
                fi
            done
            echo -e "address : $address\nnet : $net\n3 Octets : $threeoct\ncidrs : $cidr\nrange : $range"

            # To Track allocated vars
            usedvars+=(${alpha[$cnt]})
            ((cnt++))
        else
            :
            #echo "[E] Invalid IP Address $i"
            #exit 1
        fi
    done
fi
}
# Validate ip {{{
function validip()
{
ip=${1:? "[E] IP not provided"}
re='^(0*(1?[0-9]{1,2}|2([0-4][0-9]|5[0-5]))\.){3}'
re+='0*(1?[0-9]{1,2}|2([0-4][0-9]|5[0-5]))$'

if [[ $ip =~ $re ]]; then
    echo $ip
    _ipvalid=0
    return 0
else
    echo "[E] Invalid IP address $ip"
    return 1
fi
}
# }}}
# Execute nmap scan
# Collect active hosts
# create directory for each host
main()
{
    handleinput $1
}
main $1
# ping count=1 address=10.2.0.1
