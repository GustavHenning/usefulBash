#!/bin/bash
#
# Original author: miguelgfierro@github
#
# Set up several functions to .bashrc like cs (a combination of cd+ls), ccat
# (cat with color) or reimplement evince to run in background.
#
#
# IMPORTANT!!!
# METHOD OF USE:
#
# source setup_bashrc.sh
#
# We have to source the file instead of using sh. The reason is because the line
# source ~./.bashrc will source the file in the sub-shell, i.e. a shell which
# is started as child process of the main shell.
# Exit if not sourced
if [ "$0" == "$BASH_SOURCE" ]; then
  echo >&2 "Setup script has to be sourced, not run with sh. Aborting"
  exit 1
fi

INTENDED_BASH_PATH=~/.bashrc
# To set up the bashrc script in Windows using cygwin it is necessary to add
# at the beginning of the script to fix a problem with newlines the following:
if [ $(uname -o) == "Cygwin" ]; then
  (set -o igncr) 2>/dev/null && set -o igncr;
fi

# Create save path file if it is not created
if [ ! -e ~/.sp ]; then
    touch ~/.sp
fi

ADDON=$'
################################################################################
#Hide user name and host in terminal
#export PS1="\w$ "

#Make ls every time a terminal opens
ls

#cd + ls
function cs () {
    cd \$1
    ls -a
}

#transfer path: save the current path to a hidden file
function tp () {
    pwd > ~/.sp
}

#goto transfer path: goes where the previously saved tp points
function gtp () {
    cs \`cat ~/.sp\`
}

#cat with color
function ccat () {
    source-highlight -fesc -i \$1
}

#Remove trash from terminal and runs program in background
function evince () {
    /usr/bin/evince \$* 2> /dev/null & disown
}
function gedit () {
        /usr/bin/gedit \$* 2> /dev/null & disown
}

# up N: moves N times upwards (cd ../../../{N})
# author: Frederic Dauod
function up () {
  LIMIT=\$1
  P=\$PWD
  for ((i=1; i <= LIMIT; i++))
  do
      P=\$P/..
  done
  cd \$P
  export MPWD=\$P
}'

# apply the change, only if it isn't already
! grep -q "function up () {" $INTENDED_BASH_PATH || { echo >&2 "Script already run. Aborting"; return 1; }

# Valid bash, not POSIX sh
echo "$ADDON" >> $INTENDED_BASH_PATH
source $INTENDED_BASH_PATH

# if unix & dos2unix exists apply it
if [ $(uname -o) == "Cygwin" ]; then
  if [ command -v dos2unix >/dev/null 2>&1 ]; then
    dos2unix $INTENDED_BASH_PATH
  fi
fi

echo ".bashrc updated"
