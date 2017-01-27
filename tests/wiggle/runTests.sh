#!/bin/bash

# run with bash and not sh

RED=`tput setaf 1`
GREEN=`tput setaf 2`
RESET=`tput sgr0`

ecol() {
  if [ $? -eq 1 ]; then
    echo -n "${RED}-${RESET}"
  else
    echo -n "${GREEN}+${RESET}"
  fi

}

RES=0

SIMPLE_TERMINATION=$(bash ../../wiggle.sh "bash ./simpleTermination.sh --asdf 10")
RES=$? || RES;
ecol
SCORE=$(echo $SIMPLE_TERMINATION | cut -d' ' -f 2)
if [[ $SCORE -ne 100 ]]; then RES=1; echo; echo "Failed test: simpleTermination";fi

DESCENDING=$(bash ../../wiggle.sh "bash ./descending.sh --asdf 100")
RES=$? || RES;
ecol
SCORE=$(echo $DESCENDING | cut -d' ' -f 2)
if [[ $SCORE -ne 101 ]]; then RES=1; echo; echo "Failed test: descending"; fi



echo
echo $SIMPLE_TERMINATION;
echo $DESCENDING;

if [[ $RES -eq 0 ]]; then
  echo "Tests passed."
  exit 0
else
  echo "Tests failed."
  exit 1
fi
