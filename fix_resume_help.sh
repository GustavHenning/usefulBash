#!/bin/bash
case "$1" in
    resume)
	sudo modprobe msr
	WEIRD_WAKEUP=$(sudo rdmsr -a 0x19a | grep 0 | wc -l)
	if [[ $WEIRD_WAKEUP -eq 0 ]]; then
		sudo wrmsr -a 0x19a 0x0
	fi
	;;
esac

exit 0
