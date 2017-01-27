#!/bin/bash

# run with bash and not sh

RED=`tput setaf 1`
GREEN=`tput setaf 2`
RESET=`tput sgr0`

ecol() {
  if [ $1 -eq 1 ]; then
    echo -n "${RED}-${RESET}"
  else
    echo -n "${GREEN}+${RESET}"
  fi

}

RES=0
testRan() {
  TESTED=$1
  EXPECTED_SCORE=$2
  TEST_NAME=$3
  RES=$4
  SCORE=$(echo $TESTED | cut -d' ' -f 2)
  if [[ $SCORE -ne $EXPECTED_SCORE ]]; then RES=1; echo; echo "Test failed: $TEST_NAME";fi
  ecol $RES
  return $RES
}

SIMPLE_TERMINATION=$(bash ../../wiggle.sh "bash ./simpleTermination.sh --asdf 10")
RES=$? || RES;
testRan "$SIMPLE_TERMINATION" 100 "simpleTermination" $RES
RES=$?

DESCENDING=$(bash ../../wiggle.sh "bash ./descending.sh --asdf 100")
RES=$? || RES;
testRan "$DESCENDING" 100 "descending" $RES
RES=$?


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
