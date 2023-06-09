#!/bin/bash
#

ip=$1
addrs=()
nets=()
net3oct=()
cidrs=()
ranges=()

if [[ $ip =~ "," ]]; then
    IFS=","
    for i in $ip; do
        addrs+=(${i%/*})
        nets+=(${i})
        net3oct+=(${i%.*})
        cidrs+=(${i#*/})
        # Calculate Subnet
        tmpcidr=${i#*/}
        tmp=${i##*.}
        host=${tmp%/*}
        step=$((2 ** (32 - $tmpcidr) ))
        IFS=" "
        tmplist=($(seq -s " " 0 $step 256))
        # Get ranges
        for (( idx=0;idx < ${#tmplist[@]}; idx++ )); do
            if [[ $host -ge ${tmplist[$idx]} ]] && [[ $host -le ${tmplist[$idx+1]} ]]; then
                ranges+=("$(( ${tmplist[$idx]} + 1 )) $(( ${tmplist[$idx+1]} - 1 ))")
            fi
        done
    done
    #for idx in $(seq 0 ${#addrs[@]});do
    for idx in 0 1 2 3;do
    echo -ne "Address: ${addrs[$idx]}\nNetwork: ${nets[$idx]}\nCIDR: ${cidrs[$idx]}\nIP 3 octets: ${net3oct[$idx]}\nRange: ${ranges[$idx]}\n"
    perl -e 'print("-" x 30, "\n")'
    done
    
elif [[ $ip =~ "/" ]]; then
    addr=${ip%/*}
    cidr=${ip#*/}
    host=${addr##*.}
    step=$((2 ** (32 - $cidr) ))
    tmplist=($(seq -s " " 0 $step 256))
    
    for (( idx=0;idx < ${#tmplist[@]}; idx++ )); do
        if [[ $host -ge ${tmplist[$idx]} ]] && [[ $host -le ${tmplist[$idx+1]} ]]; then
            range="$(( ${tmplist[$idx]} + 1 )) $(( ${tmplist[$idx+1]} - 1 ))"
        fi  
    done
    
    echo -ne "Address: $addr\nCIDR: $cidr\nNetwork Range: $range\n"

else
    echo Address: $ip
fi
