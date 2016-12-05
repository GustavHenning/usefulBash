#!/bin/bash

rm -rf ./*~
if [ ! -d ./out ]; then
	mkdir out
fi

pdflatex thesis.tex

mv ./*.aux ./out
mv ./*.out ./out
