#!/bin/bash
#


#seq 100 200 | xargs -I{} -P0 nmap -Pn -sT -p 22,23,80 192.168.100.{} --open -oG - |grep -v '#'| grep -P '(report|open)' | sed 's|(\(1\))|\n|g' | sed -E 's|^(.+\s)I.+$|\1|'
PORTS="22,23,80"
_network=testnet

#seq 1 254 | xargs -I{} -P0 nmap -Pn -sT -n -p 23,23,80 192.168.8.{}  --open | rg '(^Nmap|^\d)' | awk '/Nmap/{print $NF} /^[0-9]/{print $0}' 

_hosts=$(seq 1 254 | xargs -I{} -P0 nmap -Pn -sT -n -p $PORTS -oN - 192.168.8.{}  --open | rg '(^Nmap|^\d)' | awk '/Nmap/{print $NF}')

mkdir $_network
cd $_network

for i in $_hosts;do
	mkdir $i
	nmap -Pn -sT -n -p $PORTS --open -oN ${i}/scan.nmap $i | awk '/^Nmap/{print $NF} /^[0-9]/{print $0}'
	traceroute $i >> ${i}/traceroute &
done

for i in $_hosts;do
	printf "Checking ${i}: \n"
	IFS=","
	for p in $PORTS;do
		case $p in 
			22)
	                    grep "22/tcp open" ${i}/scan.nmap
	                    if [[ $? == 0 ]];then
				    printf "Checking Version...\n"
				    ver_ck=true
				    if [[ ver_ck ]];then
				        printf "Sucks to suck\n"
				    fi
			    fi
				;;
			80)
	                    grep "80/tcp open" ${i}/scan.nmap
	                    if [[ $? == 0 ]];then
				    printf "Checking Version...\n"
				    curl http://${i}/ -o ${i}/curl.out 2>/dev/null
				    ver_ck=true
				    if [[ ver_ck ]];then
				        printf "Sucks to suck\n"
				    fi
			    fi
				;;
			23)
	                    grep "23/tcp open" ${i}/scan.nmap
	                    if [[ $? == 0 ]];then
				    printf "Checking Version...\n"
				    ver_ck=false
				    if [[ ver_ck ]];then
				        printf "Sucks to suck\n"
				    fi
			    fi
				;;
		esac
	done

done
