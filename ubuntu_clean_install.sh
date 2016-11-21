PACKAGES="aptitude atom autogen automake autoconf arj \
build-essential checkinstall calibre \
dkpg deluge default-jre default-java-plugin \
faac faad ffmpeg flac \
git gnome-shell gnome-tweak-tool gnome-mplayer geany gimp guake \
htop inkscape lynx lame most mysql-common mpg123 \
nano nmap nethogs php perl puddletag \
sublime source-highlight subversion sed \
unzip unrar ubuntu-restricted-extrasp7zip-full unetbootin \
vlc vorbis-tools wget xclip x264"

# Script for a new setup (Ubuntu or Cygwin)
RUNNING_CYGWIN=$(uname -o | grep "Cygwin" | wc -l)

# PRE INSTALL TODO
if [ $RUNNING_CYGWIN -eq 1 ]; then
  # install apt-cyg if not installed
  echo "cygwin prerequisites..."
else
  echo "linux prerequisites..."

  echo "Admin password please..."
fi

# (j)ust (g)et (u)pdate
function jgu {
    if [ $RUNNING_CYGWIN -eq 1 ]; then
      apt-cyg update
    else
      sudo apt-get update
    fi
}

# sagi: (s)udo (a)pt-(g)et (i)nstall
function sagi {
  sudo apt-get --yes install $1
}

# jgi: (j)ust (g)et (i)nstall
function jgi {
  for var in "$@"
  do
    if [ $RUNNING_CYGWIN -eq 1 ]; then
      ALRDY=$(apt-cyg | grep "^$var$" | wc -l)
      if [ $ALRDY -eq 0 ]; then
        apt-cyg install "$var" 2> /dev/null # edit this for extensive info
      fi
    else #linux
      sagi "$var"
    fi
  done
}

# PACKAGES FROM *-GET
jgu
jgi $PACKAGES

# Manual stuff
function ubuntu_manual {

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
## And to finish it, a dist-upgrade to install/update them all.
##
  sudo apt-get update && sudo apt-get dist-upgrade -y

}

# post install
if [ $RUNNING_CYGWIN -eq 1 ]; then

else
  ubuntu_manual
fi

echo "Have fun"
