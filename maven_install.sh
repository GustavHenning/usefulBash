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
  HOTSPOT=$(java -version 2>&1 >/dev/null  | grep "HotSpot")
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

HAS_ENV=$(sudo cat /etc/profile.d/mavenenv.sh | grep M2_HOME | wc -l)
if [[ $HAS_ENV -ne 1 ]]; then
  sudo sh -c 'echo "export M2_HOME=/opt/maven" >> /etc/profile.d/mavenenv.sh'
  # we need to source it already to find the path to M2_HOME later
  sudo chmod +x /etc/profile.d/mavenenv.sh
  sudo sh -c ". /etc/profile.d/mavenenv.sh"
  sudo sh -c 'echo "export PATH=${M2_HOME}/bin:${PATH}" >> /etc/profile.d/mavenenv.sh'
fi

sudo chmod +x /etc/profile.d/mavenenv.sh
sudo sh -c ". /etc/profile.d/mavenenv.sh"

mvn --version
