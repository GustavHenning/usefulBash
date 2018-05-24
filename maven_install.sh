#!/bin/bash

# WARNING: This removes the current installation of maven if installed in the same manner

function installJava()
{
  sudo add-apt-repository ppa:webupd8team/java
  sudo apt-get update -y
  sudo apt-get install oracle-java8-installer
  java -version
}

function needsJava()
{
  SE=$(java -version 2>&1 >/dev/null  | grep "SE Runtime" | wc -l)
  HOTSPOT=$(java -version 2>&1 >/dev/null  | grep "HotSpot" | wc -l)
  if [[ $SE -ne 1 ]]; then
    return 0
  fi

  if [[ $HOTSPOT -ne 1 ]]; then
    return 0
  fi

  return 1
}

if needsJava; then
  installJava
fi

# TODO automatically grab latest version
LATEST_VERSION="3.5.3"

cd /opt/
sudo wget -q http://www-eu.apache.org/dist/maven/maven-3/$LATEST_VERSION/binaries/apache-maven-$LATEST_VERSION-bin.tar.gz
sudo tar -xzf apache-maven-$LATEST_VERSION-bin.tar.gz
if [[ -d ./maven ]]; then
  sudo rm -rf ./maven
fi

sudo mv apache-maven-$LATEST_VERSION ./maven
sudo rm -f ./apache-maven-$LATEST_VERSION-bin.tar.gz*

set -x

cd -
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
sudo mv -f $parent_path/conf/mavenenv.sh /etc/profile.d/mavenenv.sh
#
# TODO not really tested extensively
sudo chmod +x /etc/profile.d/mavenenv.sh
source /etc/profile.d/mavenenv.sh

mvn --version
