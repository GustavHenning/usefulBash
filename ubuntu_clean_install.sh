#!/bin/sh

GIT_NAME="Gustav Henning"
GIT_EMAIL="nightmunnas@gmail.com"

PACKAGES="aptitude autogen automake autoconf atom arj \
build-essential checkinstall calibre \
dpkg deluge default-jre default-java-plugin \
faac faad ffmpeg flac \
git gnome-shell gnome-tweak-tool gnome-mplayer geany gimp guake \
htop inkscape lynx lame most mysql-common mpg123 \
nano nmap nethogs php perl puddletag preload \
sublime-text-installer source-highlight subversion sed \
unzip unrar p7zip-full unetbootin \
vlc vorbis-tools wget xclip x264 xdotool"

# Script for a new setup (Ubuntu or Cygwin)
RUNNING_CYGWIN=$(uname -o | grep "Cygwin" | wc -l)

#
# PRE INSTALL TODO
#
if [ $RUNNING_CYGWIN -eq 1 ]; then
  # install apt-cyg if not installed
  echo "cygwin prerequisites..."
else
  echo "linux prerequisites..."

  echo "Admin password please..."
fi

# (j)ust (g)et (u)pdate
jgu() {
    if [ $RUNNING_CYGWIN -eq 1 ]; then
      apt-cyg update 1> /dev/null
    else
      sudo apt-get update
    fi
}

# sagi: (s)udo (a)pt-(g)et (i)nstall
sagi() {
  sudo apt-get -q --yes install $1
}

# jgi: (j)ust (g)et (i)nstall
jgi() {
  for var in "$@"
  do
    if [ $RUNNING_CYGWIN -eq 1 ]; then
      ALRDY=$(apt-cyg | grep "^$var$" | wc -l)
      if [ $ALRDY -eq 0 ]; then
        apt-cyg install "$var" 1> /dev/null
      fi
    else #linux
	sagi "$var"
    fi
  done

}

#
# PACKAGES FROM *-GET
#
#TODO replace with check for linux and also function: sar
sudo add-apt-repository --yes ppa:webupd8team/atom #Atom
sudo add-apt-repository --yes ppa:webupd8team/sublime-text-3 #Sublime

jgu
jgi $PACKAGES

# Manual stuff
ubuntu_manual() {

##
## Google Chrome
##
  sudo su -c 'echo "# Google software repository
  deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
  sudo apt-get update -y

# we need --force-yes because chrome is not an authenticated package
  sudo apt-get install -y --force-yes google-chrome-beta


##
## VLC as the default video player
##
  sudo apt-get install -y vlc
  sudo apt-get remove -y --purge totem

##
## Foxit Reader for PDFs
## TODO: MAke it grab latest version

wget http://cdn01.foxitsoftware.com/pub/foxit/reader/desktop/linux/2.x/2.2/en_us/FoxitReader2.2.1025_Server_x64_enu_Setup.run.tar.gz
tar xzvf FoxitReader*.tar.gz
sudo chmod a+x FoxitReader*.run
./FoxitReader.*.run
rm -f ./FoxitReader*




##
## And to finish it, a dist-upgrade to install/update them all.
##
  sudo apt-get update && sudo apt-get dist-upgrade -y

}

#
# post install
#
if [ $RUNNING_CYGWIN -eq 1 ]; then
	echo "cygwin post"
else
  ubuntu_manual
fi

#
# Git config
#
git config --global user.name $GIT_NAME
git config --global user.email $GIT_EMAIL

echo "Have fun"
