#!/bin/bash
#
# wiggle.sh: Optimizes parameters of a program.
#
# Given a command to run a program with its parameters, that simultaniously returns a number which is to be maximized,
# wiggle.sh parses the integer and float numbers of those parameters and continues to run the command with those
# new variations until a local maximum is achieved.
#
# Running time for x iterations is O(1+3n*x) where n is the number of numeric arguments
#
# author: Gustav Henning 2016
#
set -x
# returns 1 if arg passed is an integer
isInt() {
  regExp='?(-)+([0-9])'
  if [[ $1 =~ $regExp ]]; then
    echo 1
  else
    echo 0
  fi
}

# returns 1 if arg is a number
isNum() {
  regExp='^[+-]?([0-9]+\.?|[0-9]*\.[0-9]+)$'
  if [[ $@ =~ $regExp ]]; then
      echo 1
  else
      echo 0
  fi
}

# returns 1 if arg passed is a float
isFloat() {
  regExp='^[+-]?([0-9]*\.[0-9]+)$'
  if [[ $1 =~ $regExp ]]; then
      echo 1
  else
      echo 0
  fi
}

varyLower() {
  echo $1
}

varyHigher() {
  echo $1
}

printMatrix() {
  #declare -A argArr=("${!1}")
  #echo "${argArr[@]}"
  echo "lel"
}

# returns 1 if $1 >= $2
compareResults() {
  isFloat $1
  FLT=$?
  isFloat $2
  FLT=$FLT || $?
  # both floats
  if [[ $FLT -eq 1 ]]; then
    if [ $(echo "$2 > $1" | bc ) -ne 0 ]; then
      echo 0
    else
      echo 1
    fi
  else
    # both integers
    if (( $2 < $1 )); then
      echo 0
    else
      echo 1
    fi
  fi

}

PROGRAM_COMMAND=$1

# run the command
CMD_RET=$($PROGRAM_COMMAND)
# if it doesnt return a number, exit with error
CMD_RETURNS_NUM=$(isNum $CMD_RET)

if [[ $CMD_RETURNS_NUM -eq 0 ]]; then
  echo "Program command did not return a number, instead it returned:"
  echo $CMD_RET
  exit 1
fi

declare -A CMD_SPLIT
declare -A NUM_INDICES

# split the command by spaces
IT=0
for str in $PROGRAM_COMMAND
do
  CMD_SPLIT[$IT]=$str;
  let IT=IT+1
done

# find the indices of numbers
IT_NUM=0
for ((i=0;i<${#CMD_SPLIT[@]};i++)) do
  isNum CMD_SPLIT[$i]
  if [[ $? -eq 1 ]]; then
    NUM_INDICES[$IT_NUM]=$i
    let IT_NUM=IT_NUM+1
  fi
done

ROWS=${#NUM_INDICES[@]}
COLS=3

declare -A VARIATIONS

# tweak the numbrs and fill the VARIATIONS array
for ((i=0;i<ROWS;i++)) do
  for ((j=0;j<COLS;j++)) do
    IND=${NUM_INDICES[$i]}
    NUM=${CMD_SPLIT[$IND]}
    case $j in
      0)
        varyLower $NUM
        VARIATIONS[$i,$j]=$?
        ;;
      1)
        VARIATIONS[$i,$j]=$NUM
        ;;
      2)
        varyHigher $NUM
        VARIATIONS[$i,$j]=$?
        ;;
    esac
  done
done

printMatrix VARIATIONS[@]
STAGNATION=0
CURRENT_HIGH=$CMD_RET
CURRENT_CMD=$PROGRAM_COMMAND

# keep the best result and continue unless stagnation
while [[ $STAGNATION -ne 1 ]]; do
  STAGNATION=1
  # iterate through the possibilities
  for ((i=0;i<ROWS;i++)) do
    for ((j=0;j<COLS;j++)) do
      # build cmd from VARIATIONS
      for ((k=0;k<ROWS;k++)) do
        CMD_SPLIT[NUM_INDICES[$k]]=${VARIATIONS[$k]}
      done
      CMD_TO_RUN=${CMD_SPLIT[0]}
      for ((k=1;k<${#CMD_SPLIT[@]};k++)) do
        CMD_TO_RUN="$CMD_TO_RUN ${CMD_SPLIT[$k]}"
      done
      # exeute new cmd
      NEW_RET=$($CMD_TO_RUN)
      compareResults $CURRENT_HIGH $NEW_RET
      CURRENT_STILL_HIGH=$?
      if [[ $CURRENT_STILL_HIGH -eq 0 ]]; then
        CURRENT_CMD=$CMD_TO_RUN
        CURRENT_HIGH=$NEW_RET
        STAGNATION=0
      fi
    done
  done
done

echo "Score $CURRENT_HIGH achieved with program arguments $CURRENT_CMD"

exit 0;
