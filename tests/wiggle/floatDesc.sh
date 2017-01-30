#!/bin/bash

#
# a test to see if wiggle.sh converges on a floating point number
#
#set -x
MAX_VAL=-0.1
PARAM_VAL=$2

# returns 1 if arg passed is a float
isFloat() {
  regExp='^[+-]?([0-9]*\.[0-9]+)$'
  if [[ $1 =~ $regExp ]]; then
      echo 1
  else
      echo 0
  fi
}

PARAM_VALID=$(isFloat $PARAM_VAL)

# if $2 was a number
if [[ $PARAM_VALID -ne 0 ]]; then
  # print the appropriate one
  GT=$(echo $PARAM_VAL'>'$MAX_VAL | bc -l)
  if [ $GT -eq 0 ]; then
    echo "$PARAM_VAL";
  else
    echo "$MAX_VAL";
  fi
else
  echo "Test failed: second param not a number";
  exit 1;
fi
