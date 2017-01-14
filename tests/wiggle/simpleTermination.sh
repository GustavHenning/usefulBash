#!/bin/bash

#
# a simple test to see if wiggle.sh converges on a number
#

MAX_VAL=1000
PARAM_VAL=$2

function isNum {
  if [[ $1 == ?(-)+([0-9]) ]]; then
    echo 1;
  else
    echo 0;
  fi
}

PARAM_VALID=$(isNum $PARAM_VAL)

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
