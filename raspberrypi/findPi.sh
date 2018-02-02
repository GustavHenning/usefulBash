#!/bin/bash

# look for it on this ip range, find 'Raspberry', grab line: two lines before, and cut to the ip
PI_IP=$(sudo nmap -sn 192.168.0.0/24 | grep -B 2 "Raspberry" | head -n 1 | cut -d' ' -f 5)
PI_IP_LEN=${#PI_IP}

# if an ip was found
if [[ $PI_IP_LEN -ne 0 ]]; then
	echo "PI found at $PI_IP. Connecting..."
	ssh pi@$PI_IP
fi
