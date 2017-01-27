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

DEBUG=0

# returns 1 if arg passed is an integer
isInt() {
  if [ "$1" -eq "$1" ]; then
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

varyLower() { # TODO floats
  if [[ $(isInt $1) -eq 1 ]]; then
      echo $(($1 - 1))
  fi
}

varyHigher() { # TODO floats
  if [[ $(isInt $1) -eq 1 ]]; then
    echo $(($1 + 1))
  fi
}

# returns 1 if $1 > $2, 0 if $1 == $2 and -1 if $1 < $2
compareResults() {
  FLT=$(isFloat $1)
  FLT=$FLT || isFloat $2
  # both floats TODO
  if [[ $FLT -eq 1 ]]; then
    if [ $(echo "$2 > $1" | bc ) -ne 0 ]; then
      echo 0
    else
      echo 1
    fi
  else
    # both integers
    if (( $1 > $2 )); then
      echo 1
    else
      if (( $1 < $2 )); then
        echo -1
      else
        echo 0
      fi
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
  IS_NUM=$(isNum ${CMD_SPLIT[$i]})
  if [[ $IS_NUM -eq 1 ]]; then
    NUM_INDICES[$IT_NUM]=$i
    let IT_NUM=IT_NUM+1
  fi
done

ROWS=${#NUM_INDICES[@]}
COLS=3

declare -A VARIATIONS
declare -A NEXT_CMD_SPLIT

for key in "${!CMD_SPLIT[@]}"
do
  NEXT_CMD_SPLIT["$key"]="${CMD_SPLIT["$key"]}"
done

STAGNATION=0
CURRENT_HIGH=$CMD_RET
CURRENT_CMD=$PROGRAM_COMMAND

while [[ $STAGNATION -ne 1 ]]; do
  STAGNATION=1
  if [ $DEBUG -eq 1 ]; then
    (>&2 echo "DBG: new epoch with $CURRENT_CMD")
  fi
  # tweak the numbers and fill the VARIATIONS array
  # TODO add option for 5 columns or more
  for ((i=0;i<ROWS;i++)) do
    for ((j=0;j<COLS;j++)) do
      IND=${NUM_INDICES[$i]}
      NUM=${NEXT_CMD_SPLIT[$IND]}
      case $j in
        0)
          VARIATIONS[$i,$j]=$(varyLower $NUM)
          ;;
        1)
          VARIATIONS[$i,$j]=$NUM
          ;;
        2)
          VARIATIONS[$i,$j]=$(varyHigher $NUM)
          ;;
      esac
    done
  done

  CURRENT_STILL_HIGH=0
  # keep the best result and continue unless stagnation
  # iterate through the possibilities
  for ((i=0;i<ROWS;i++)) do
    for ((j=0;j<COLS;j++)) do
      # build cmd from VARIATIONS
      for ((k=0;k<ROWS;k++)) do
        CMD_SPLIT[${NUM_INDICES[$k]}]=${VARIATIONS[$k,$j]}
      done
      CMD_TO_RUN=${CMD_SPLIT[0]}
      for ((k=1;k<${#CMD_SPLIT[@]};k++)) do
        CMD_TO_RUN="$CMD_TO_RUN ${CMD_SPLIT[$k]}"
      done
      # execute new cmd
      NEW_RET=$($CMD_TO_RUN)
      CMP=$(compareResults $CURRENT_HIGH $NEW_RET)
      if [ $DEBUG -eq 1 ]; then
        (>&2 echo "DBG: $CMD_TO_RUN: $NEW_RET, compared to $CURRENT_HIGH: $CMP")
      fi
      # if new top score
      if [[ $CMP -le 0 ]]; then
        CURRENT_HIGH=$NEW_RET
        # dont replace CMD if same score
        if [[ $CMP -lt 0 ]]; then
          CURRENT_CMD=$CMD_TO_RUN
          # Populate the next array
          for key in "${!CMD_SPLIT[@]}"
          do
            NEXT_CMD_SPLIT["$key"]="${CMD_SPLIT["$key"]}"
          done

          if [ $DEBUG -eq 1 ]; then
            (>&2 echo "DBG: New high with $CMD_TO_RUN: $NEW_RET, compared to $CURRENT_HIGH: $CMP")
          fi
        fi
      fi
      # stagnate only if all iterations gave no new top score
      CURRENT_STILL_HIGH=$CMP || $CURRENT_STILL_HIGH
      if [[ $CURRENT_STILL_HIGH -lt 0 ]]; then
        STAGNATION=0
      fi
    done
  done
done

echo "Score $CURRENT_HIGH achieved with program arguments $CURRENT_CMD"

exit 0;
