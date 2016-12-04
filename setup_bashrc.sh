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
#
# Exit if not sourced
if [ "$0" == "$BASH_SOURCE" ]; then
  echo >&2 "Setup script has to be sourced, not run with sh. Aborting"
  exit 1
fi

# Change this if home is not where you lay your head
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

ADDON=$'#START!SETUP!SCR##########

# Hide user name and host in terminal
#export PS1="\w$ "

# Make ls every time a terminal opens
ls

# typos
alias sl="ls"
alias exti="exit"
alias eixt="exit"
alias xit="exit"

# extensive ls
alias ll="ls -lasi"

# safe file management
alias cp="cp -iv"
alias rm="rm -i"
alias mv="mv -i"

# quick directory movement
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# quickly find files and directory
alias ff="find . -type f -name"
alias fd="find . -type d -name"

# print the current time
alias now="date +%T"

# all-in-one update
alias update="sudo apt-get update && sudo apt-get upgrade && sudo apt-get autoclean"

# OS Power commands
alias reboot="sudo /sbin/reboot"
alias shutdown="sudo /sbin/shutdown"

# Wifi
alias scanwifi="sudo iwlist scan >/dev/null 2>&1 &"
alias rswifi="sudo service network-manager restart"

# open mail client
alias mail="thunderbird > /dev/null 2>&1 & disown"

#
# cd + ls
#
function cs () {
    cd $1
    ls -a
}

#
# transfer path: save the current path to a hidden file
#
function tp () {
    pwd > ~/.sp
}

#
# goto transfer path: goes where the previously saved tp points
#
function gtp () {
    cs `cat ~/.sp`
}

#
# cat with color
#
function ccat () {
    source-highlight -fesc -i $1
}

#
# Remove trash from terminal and runs program in background
#
function evince () {
    /usr/bin/evince $* 2> /dev/null & disown
}
function gedit () {
        /usr/bin/gedit $* 2> /dev/null & disown
}

#
# up N: moves N times upwards (cd ../../../{N})
# author: Frederic Dauod
#
function up () {
  LIMIT=$1
  P=$PWD
  for ((i=1; i <= LIMIT; i++))
  do
      P=$P/..
  done
  cd $P
  export MPWD=$P
}

#
# Open chrome fast
#
function chr () {
  if [ $(which google-chrome-beta | wc -l) -eq 1 ]; then
     google-chrome-beta $* 2> /dev/null & disown
  else
     if [ $(which google-chrome | wc -l) -eq 1 ]; then
        google-chrome $* 2> /dev/null & disown
     else
        echo "No chrome :("
     fi
  fi
}

#
# Do a normal add/commit/push in one go
#
function gut () {
  if [ $# -eq 0 ] || [ $# -gt 2 ]; then
     echo "args are 1: message, 2: branch (default: master)"
     echo "dont forget to \"quote\" your message"
     return 1
  fi
  DEST=""
  if [ -z "$2" ]; then
    DEST="master"
  else
    DEST="$2"
  fi
  if [ $(which git | wc -l) -eq 1 ]; then
    git add -A
    git commit -m \"$1\"
    git push origin $DEST
  else
    echo "no git :("
  fi
}

#
# extract an archive
#
extract () {
 if [ -f $1 ] ; then
     case $1 in
         *.tar.bz2)   tar xvjf $1    ;;
         *.tar.gz)    tar xvzf $1    ;;
         *.bz2)       bunzip2 $1     ;;
         *.rar)       unrar x $1       ;;
         *.gz)        gunzip $1      ;;
         *.tar)       tar xvf $1     ;;
         *.tbz2)      tar xvjf $1    ;;
         *.tgz)       tar xvzf $1    ;;
         *.zip)       unzip $1       ;;
         *.Z)         uncompress $1  ;;
         *.7z)        7z x $1        ;;
         *)           echo "don\'t know how to extract \'$1\'..." ;;
     esac
 else
     echo "\'$1\' is not a valid file!"
 fi
}

#
# remove spaces recursively in folder and file names
# author: Michael Krelin
#

function fixnames () {
  find . -depth -name \'* *\' \
  | while IFS= read -r f ; do mv -i \"$f\" \"$(dirname \"$f\")/$(basename \"$f\"|tr \' \' _)\" ; done
}

#END!SETUP!SCR#'

# apply the change, replace if an older version exists
! grep -q "#START!SETUP!SCR#" $INTENDED_BASH_PATH || { echo >&2 "Script already run. Replacing... "; sed -i '/#START!SETUP!SCR#/,/#END!SETUP!SCR#/d' $INTENDED_BASH_PATH; }

# Valid bash, not POSIX sh! (suggestions welcome)
echo "$ADDON" >> $INTENDED_BASH_PATH
source $INTENDED_BASH_PATH

# if unix & dos2unix exists apply it
if [ $(uname -o) == "Cygwin" ]; then
  if [ command -v dos2unix >/dev/null 2>&1 ]; then
    dos2unix $INTENDED_BASH_PATH
  fi
fi

echo ".bashrc updated"
