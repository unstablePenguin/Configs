#!/bin/bash
#
#
PROMPT="Usage: $0 {NetworkAddr/CIDR}\nEx. $0 172.16.31.0/24 "
if [[ $# < 1 ]]; then
	printf "${PROMPT}\n"
        exit 1
fi
PORTS="22,23,80"
_network=$1
dir=${_network:0:-3}
logfile=${HOME}/${dir}/${dir}.log

if [[ -d $dir ]];then
	cd $dir
else
    printf "[-] Creating Directory for ${_network}\n" 
    mkdir ${HOME}/${dir} || exit 1
    cd $dir
fi
[[ -e $logfile ]] && mv $logfile ${logfile}.old || touch $logfile
[[ -d $dir ]] && printf "[+] Directory Created\n" | tee -a $logfile

printf "[-] Scanning for hosts on ${_network}\n" | tee -a $logfile
_hosts=$(nmap -sn -n -oG - $_network | awk '/Up/{print $2}')
printf "[+] Host Discovery Complete\n" | tee -a $logfile
echo $_hosts | tee -a $logfile
cd $dir
printf "[-] Starting Portscan\n" | tee -a $logfile
for i in $_hosts;do
	printf "[-] Creating directory for ${i}\n"
	mkdir $i
	nmap -Pn -sT -n -p $PORTS --open --traceroute -oN ${i}/scan.nmap $i
	printf "[+] Portscan Complete for ${i}\n" | tee -a $logfile
	cat ${i}/scan.nmap | tee -a $logfile
	grep "80/tcp open" ${i}/scan.nmap
        if [[ $? == 0 ]];then
	    printf "[-] Checking ${i} Version\n" | tee -a $logfile
######	    curl http://${i}/  2>/dev/null | grep "##pattern##" | tee -a ${i}/version.txt
	    ######printf "[+] ${i} Version: $(cat ${i/version.txt})\n" | tee -a $logfile

	fi
#####	grep "23/tcp open" ${i}/scan.nmap
	if [[ $? == 0 ]];then
	    printf "[-] Checking ${i} Version\n" | tee -a $logfile
#####	    true | tee -a ${i}/version.txt
	    ######printf "[+] ${i} Version: $(cat ${i/version.txt})\n" | tee -a $logfile
	fi
        	
done
