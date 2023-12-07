#!/bin/bash

# https://adventofcode.com/2023/day/6

## part1

INPUT_DATA=$1

declare -a TIME_ARRAY
declare -a DIST_ARRAY

read -ra TIME_ARRAY <<< $(head -n 1 $INPUT_DATA)
read -ra DIST_ARRAY <<< $(tail -n 1 $INPUT_DATA)

#echo ${TIME_ARRAY[@]}
#echo ${DIST_ARRAY[@]}

N=1
for ((i=1;i<${#TIME_ARRAY[@]};i++)); do
    t=${TIME_ARRAY[i]}
    comb=0
    for ((n=1;n<t;n++)); do
        [[ $((n*(t-n))) -gt ${DIST_ARRAY[i]} ]] && comb=$((comb+1))
    done
    N=$((N*comb))
done
echo "Ways to beat the game: $N"
