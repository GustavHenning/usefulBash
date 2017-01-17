#!/bin/bash

# run with bash and not sh

RES=0

SIMPLE_TERMINATION=$(bash ../../wiggle.sh "bash ./simpleTermination.sh --asdf 10")
RES=$? || RES;

if [[ $RES -eq 1 ]]; then
  echo "Failed test: simpleTermination"
fi

if [[ $RES -eq 0 ]]; then
  echo "Tests passed."
else
  echo "Tests failed."
fi

echo $SIMPLE_TERMINATION;
