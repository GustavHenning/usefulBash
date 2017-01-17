#!/bin/bash

# run with bash and not sh

RES=0

SIMPLE_TERMINATION=$(bash ../../wiggle.sh "bash ./simpleTermination.sh --asdf 10")
RES=$? || RES;

SCORE=$(echo $SIMPLE_TERMINATION | cut -d' ' -f 2)
if [[ $SCORE -ne 100 ]]; then RES=1; fi

if [[ $RES -eq 1 ]]; then echo "Failed test: simpleTermination"; fi


DESCENDING=$(bash ../../wiggle.sh "bash ./descending.sh --asdf 100")
RES=$? || RES;

SCORE=$(echo $DESCENDING | cut -d' ' -f 2)
if [[ $SCORE -ne 100 ]]; then RES=1; fi

if [[ $RES -eq 1 ]]; then echo "Failed test: descending"; fi



echo $SIMPLE_TERMINATION;
echo $DESCENDING;

if [[ $RES -eq 0 ]]; then
  echo "Tests passed."
  exit 0
else
  echo "Tests failed."
  exit 1
fi
