#!/bin/bash

#
# Start some applications and align them as prefered
#

if [ $(which xdotool | wc -l ) -eq 0 ]; then
	echo "xodotool required, installing..."
	sudo apt-get install xdotool
fi


function topLeft () {
	xdotool key ctrl+alt+Up+Left
	sleep 0.3
}

# make sure we are top left
topLeft

# terminal 1, 2, bottom left
xdotool key ctrl+alt+Down # go down
sleep 0.3
xdotool key ctrl+alt+t # term
sleep 0.3
xdotool key ctrl+super+Left # left expand
sleep 0.3

xdotool key ctrl+alt+t # term
sleep 0.3
xdotool key ctrl+super+Right # right expand
sleep 0.3

# terminal 3 (glances), bottom right
xdotool key ctrl+alt+Right # send down
sleep 0.3
xdotool key ctrl+alt+t # term
sleep 0.3
xdotool type "glances"
sleep 0.3
xdotool key Return
sleep 0.3
xdotool key ctrl+super+Up # expand
sleep 0.3

# telegram and whatsapp, top right
xdotool key ctrl+alt+Up # go up
sleep 0.3
if [ -z $(ps -ef | grep whatsie | grep -v grep) ]; then
	whatsie > /dev/null 2>&1 &
	sleep 3.0
fi
xdotool key ctrl+super+Left


# term, top left
topLeft
