#!/usr/bin/env bash
echo enter the ip to scan
read ip
echo enter the starting port
read port1
echo enter the ending port
read port2
echo scanning...
mkdir $ip
cd $ip/
nmap $ip -p $port1-$port2 -sV -oX scan.xml
grep 'open' scan.xml | grep 'service name' | cut -d= -f6-9 | cut -c 6- | cut -d\" -f4,6 >> keywords.txt
while read line ; do
	name=$(echo "$line" | cut -d\" -f1)
	url="https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query="${name// /+}"&search_type=all&isCpeNameSearch=false"
	wget -E .html $url
	echo $url >> links.txt
done < keywords.txt
for file in *; do cat $file | grep vuln-summary >> summary.txt; done
