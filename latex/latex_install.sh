#!/bin/bash

# This scripts downloads and installs a latex module. Intended for Ubuntu.
# Pay special attention to the destination folder
DESTINATION_FOLDER="/usr/share/texlive/texmf-dist/tex/latex"
# Author: Gustav Henning 2016


TEX_HASH_INSTALLED=$(which texhash)
LATEX_INSTALLED=$(which latex)

if [ -z $1 ]; then
  echo "specify which package to install"
  echo "example: latex_install.sh subfigure"
  exit 1
fi

if [ -d $DESTINATION_FOLDER/$1 ]; then
  echo "$1 seems to be installed already..."
  exit 1
fi

if [ -z $TEX_HASH_INSTALLED ] || [ -z $LATEX_INSTALLED ]; then
  echo "dependencies missing... texhash or latex not installed"
  exit 1
fi

# download zip
echo "Downloading $1.zip..."
wget -qO $1.zip http://mirrors.ctan.org/macros/latex/contrib/$1.zip

if [ $? -ne 0 ]; then
  echo "Could not find $1.zip, looking in obsolete..."
  wget -qO $1.zip http://mirrors.ctan.org/obsolete/macros/latex/contrib/$1.zip
  if [ $? -ne 0 ]; then
    rm -rf $1.zip
    echo "404: File not found for $1.zip. Exiting."
    exit 1
  else
    echo "Found $!.zip!"
  fi
else
  echo "Found $1.zip!"
fi

# extract zip
echo "Unzipping $1"
unzip $1.zip

# build folder (latex)
echo "Building $1"
cd $1
for ins in *.ins; do latex $ins; done
cd ..

# move folder to destination
echo "Moving $1 to $DESTINATION_FOLDER"
sudo mv ./$1 $DESTINATION_FOLDER
rm -rf $1.zip

# register folder
echo "Registering $1"
cd $DESTINATION_FOLDER/$1
sudo texhash

echo "Done"
