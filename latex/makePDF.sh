#!/bin/bash

rm -rf ./*~
if [ ! -d ./out ]; then
	mkdir out
fi

pdflatex thesis.tex

#mv ./*.aux ./out
mv ./*.out ./out

if [ $(ps -ef | grep FoxitReader | grep -v grep | wc -l) -gt 0 ]; then
	kill $(pidof FoxitReader)
fi
~/opt/foxitsoftware/foxitreader/FoxitReader.sh ./thesis.pdf > /dev/null 2>&1 &
