#!/bin/bash

# https://adventofcode.com/2023/day/6

## part 2

INPUT_DATA=$1

TIME=$(sed 's/[^0-9]*//g' <<< $(head -n 1 $INPUT_DATA))
DIST=$(sed 's/[^0-9]*//g' <<< $(tail -n 1 $INPUT_DATA))

comb=0
for ((n=1;n<TIME;n++)); do
    [[ $((n*(TIME-n))) -gt $DIST ]] && comb=$((comb+1))
done
echo "Ways to beat the game: $comb"
