# Script for a new setup (Ubuntu or Cygwin)

RUNNING_CYGWIN=$(uname -o | grep "Cygwin" | wc -l)

if [ $RUNNING_CYGWIN -eq 1 ]; then
  # install apt-cyg if not installed
  echo "cygwin prerequisites..."
else
  echo "linux prerequisites..."
fi

# sagi: (s)udo (a)pt-(g)et (i)nstall
function sagi {
  sudo apt-get --yes install $1
}

# jgi: (j)ust (g)et (i)nstall
function jgi {
  for var in "$@"
  do
    if [ $RUNNING_CYGWIN -eq 1 ]; then
      apt-cyg install "$var"
    else #linux
      sagi "$var"
    fi
  done
}


# shared libraries
jgi lynx make git nano subversion sed php perl mysql-common
#TODO: Make, git, nano, subversion, sed, php, perl, mysql-common,
