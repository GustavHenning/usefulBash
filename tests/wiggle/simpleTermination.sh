#!/bin/bash

#
# a simple test to see if wiggle.sh converges on a number
#
set -x
MAX_VAL=1000
PARAM_VAL=$2

isNum() {
  regExp='^?(-)+([0-9])$' #TODO this is flawed
  if [[ $1 =~ $regExp ]]; then
    echo 1
  else
    echo 0
  fi
}
isNum $PARAM_VAL
PARAM_VALID=$?

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
