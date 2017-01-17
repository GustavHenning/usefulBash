#!/bin/bash

#
# a simple test to see if wiggle.sh converges on a number
#
#set -x
MAX_VAL=100
PARAM_VAL=$2

isInt() {
  if [ "$1" -eq "$1" ]; then
    echo 1
  else
    echo 0
  fi
}

PARAM_VALID=$(isInt $PARAM_VAL)

# if $2 was a number
if [[ $PARAM_VALID -ne 0 ]]; then
  # print the appropriate one
  if [ "$MAX_VAL" -gt "$PARAM_VAL" ]; then
    echo "$PARAM_VAL";
  else
    echo "$MAX_VAL";
  fi
else
  echo "Test failed: second param not a number";
  exit 1;
fi
