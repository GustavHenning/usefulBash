#!/bin/bash

BOOST_FILE="boost_1_62_0"
BOOST_VERSION="1.62.0"


INST_BOOST=$(ls /usr/local/lib | grep libboost | wc -l)
INST_OPENCV=$(ls /usr/local/lib | grep opencv | wc -l)

if [ $INST_BOOST -ne 0 ]; then
  if [ $(ls /usr/local/lib | grep libboost | grep $BOOST_VERSION | wc -l) -ne 0 ]; then
    read -p "Boost with the same version already installed, continue? (y/n)?" choice
    case "$choice" in
      y|Y ) INST_BOOST=1;;
      * ) INST_BOOST=0;;
    esac
  else
    read -p "Boost with another version already installed, continue? (y/n)?" choice
    case "$choice" in
      y|Y ) INST_BOOST=1;;
      * ) INST_BOOST=0;;
    esac
  fi
fi

if [ $INST_OPENCV -ne 0 ]; then
  read -p "OpenCV already installed, continue? (y/n)?" choice
  case "$choice" in
    y|Y ) INST_OPENCV=1;;
    * ) INST_OPENCV=0;;
  esac
fi

if [ $INST_BOOST -eq 1 ]; then

# install boost - get source
echo "Fetching $BOOST_FILE..."
wget -O $BOOST_FILE.tar.gz http://sourceforge.net/projects/boost/files/boost/$BOOST_VERSION/$BOOST_FILE.tar.gz/downloadof
tar xzvf $BOOST_FILE.tar.gz
cd $BOOST_FILE/

# required libraries
echo "Installing requirements for $BOOST_FILE..."
sudo apt-get update -y
sudo apt-get install -y build-essential g++ python-dev autotools-dev libicu-dev build-essential libbz2-dev libboost-all-dev

# bootstrap
echo "Bootstrapping $BOOST_FILE..."
./bootstrap.sh --prefix=/usr/local

# build
echo "Building $BOOST_FILE..."
./b2

# install
echo "Installing $BOOST_FILE..."
sudo ./b2 install

# clean up
echo "Cleaning up $BOOST_FILE..."
cd ..
rm -rf ./$BOOST_FILE
rm -rf ./$BOOST_FILE.tar.gz

fi

if [ $INST_OPENCV -eq 1 ]; then

# install open cv
echo "Fetching OpenCV..."
git clone https://github.com/jayrambhia/Install-OpenCV

# install
echo "Installing OpenCV..."
cd Install-OpenCV/Ubuntu
chmod +x *
sudo bash ./opencv_latest.sh

# clean up
echo "Cleaning up OpenCV..."
cd ../..
sudo rm -rf ./Install-OpenCV

fi
echo "..."
echo "Installation complete"
