#!/bin/bash

# This script addresses the problem of slow performance after ubuntu going into sleep mode.
# Note that this may break your system, do not use it unless you understand what you are doing.
# source: https://askubuntu.com/questions/623149/ubuntu-becomes-quite-laggy-after-wake-up

# check if we have msr-tools and install it if we dont
MSR_INSTALLED=$(dpkg -l | grep msr-tools | wc -l)
if [[ $MSR_INSTALLED -eq 0 ]]; then
	sudo apt-get install msr-tools
fi

# if we arent in this directory we cannot see the helper script
if [[ ! -e ./fix_resume_help.sh ]]; then
	echo "Helper script cannot be found, run this file from it's location"
	exit 1
fi

# check if we have added the script already, do it if we haven't
if [[ -e /usr/lib/pm-utils/sleep.d/99ZZresume_fix ]]; then
	sudo rm /usr/lib/pm-utils/sleep.d/99ZZresume_fix
fi

sudo bash -c "cp ./fix_resume_help.sh /usr/lib/pm-utils/sleep.d/99ZZresume_fix"
sudo chmod a+x /usr/lib/pm-utils/sleep.d/99ZZresume_fix
