#!/bin/bash

# run with bash and not sh

RED=`tput setaf 1`
GREEN=`tput setaf 2`
RESET=`tput sgr0`
# echo color
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
  EXP=$(echo $SCORE'=='$EXPECTED_SCORE | bc )
  if [[ $EXP -eq 0 ]]; then RES=1; echo; echo "Test failed: $TEST_NAME";fi
  ecol $RES
  return $RES
}

INT_INCR=$(bash ../../wiggle.sh "bash ./intIncr.sh --asdf 50")
RES=$? || RES; # see if command succeeds
testRan "$INT_INCR" 100 "intIncr" $RES
RES=$? # see if score is achieved

INT_INCR_FROM_ZERO=$(bash ../../wiggle.sh "bash ./intIncr.sh --asdf 0")
RES=$? || RES; # see if command succeeds
testRan "$INT_INCR_FROM_ZERO" 100 "intIncrFromZero" $RES
RES=$? # see if score is achieved

INT_DESC=$(bash ../../wiggle.sh "bash ./intDesc.sh --asdf 100")
RES=$? || RES;
testRan "$INT_DESC" 100 "intDesc" $RES
RES=$?

INT_PASS_ZERO_FROM_NEG=$(bash ../../wiggle.sh "bash ./intIncr.sh --asdf -10")
RES=$? || RES;
testRan "$INT_PASS_ZERO_FROM_NEG" 100 "intIncrPassZeroFromNegToPos" $RES
RES=$?

FLOAT_INCR=$(bash ../../wiggle.sh "bash ./floatIncr.sh --asdf 0.5")
RES=$? || RES;
testRan "$FLOAT_INCR" 1.0 "floatIncr" $RES
RES=$?

FLOAT_INCR_FROM_ZERO=$(bash ../../wiggle.sh "bash ./floatIncr.sh --asdf 0.0")
RES=$? || RES;
testRan "$FLOAT_INCR_FROM_ZERO" 1.0 "floatIncr" $RES
RES=$?

FLOAT_DESC=$(bash ../../wiggle.sh "bash ./floatDesc.sh --asdf 0.5")
RES=$? || RES;
testRan "$FLOAT_DESC" -0.1 "floatDesc" $RES
RES=$?

FLOAT_PASS_ZERO_FROM_POS=$(bash ../../wiggle.sh "bash ./floatDesc.sh --asdf 0.01")
RES=$? || RES;
testRan "$FLOAT_PASS_ZERO_FROM_POS" -0.1 "floatPassZeroFromPosToNeg" $RES
RES=$?

FLOAT_PASS_ZERO_FROM_NEG=$(bash ../../wiggle.sh "bash ./floatIncr.sh --asdf -0.5")
RES=$? || RES;
testRan "$FLOAT_PASS_ZERO_FROM_NEG" 1.0 "floatPassZeroFromNegToPos" $RES
RES=$?


echo
# File system and error msg tests
# TODO
# Integer tests
echo $INT_INCR;
echo $INT_INCR_FROM_ZERO;
echo $INT_DESC;
echo $INT_PASS_ZERO_FROM_POS;
echo $INT_PASS_ZERO_FROM_NEG;
# Floating point tests
echo $FLOAT_INCR;
echo $FLOAT_INCR_FROM_ZERO;
echo $FLOAT_DESC;
echo $FLOAT_PASS_ZERO_FROM_POS;
echo $FLOAT_PASS_ZERO_FROM_NEG;

if [[ $RES -eq 0 ]]; then
  echo "Tests passed."
  exit 0
else
  echo "Tests failed."
  exit 1
fi
