#!/bin/bash

TEXNAME="thesis.tex"
AUXNAME="${TEXNAME%.tex}.aux"
PDFNAME="${TEXNAME%.tex}.pdf"

rm -rf ./*~
if [ ! -d ./out ]; then
	mkdir out
fi

if [ "$(ps -ef | grep evince-previewer | grep -v grep | wc -l)" -gt 0 ]; then
	kill "$(pidof evince-previewer)"
fi

pdfLatexMacro(){
	pdflatex -shell-escape -interaction=nonstopmode -file-line-error "$TEXNAME" | egrep ".*:[0-9]*:.*|LaTeX Warning:"
}

pdfLatexMacro
pdfLatexMacro
bibtex -terse "$AUXNAME"
pdfLatexMacro

#mv ./*.aux ./out
mv ./*.out ./out

evince -fw ./$PDFNAME > /dev/null 2>&1 &

