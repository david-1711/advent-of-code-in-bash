#!/bin/bash

# https://adventofcode.com/2023/day/6

## part 2

SCRIPT_DIR=$PWD/2023/day6/
INPUT_DATA=$SCRIPT_DIR/input_data

TIME=$(head -n 1 "$INPUT_DATA")
TIME=${TIME//[^0-9]/}
DIST=$(tail -n 1 "$INPUT_DATA")
DIST=${DIST//[^0-9]/}

comb=0
for ((n=1;n<TIME;n++)); do
    [[ $((n*(TIME-n))) -gt $DIST ]] && comb=$((comb+1))
done
echo "Ways to beat the game: $comb" #28228952
