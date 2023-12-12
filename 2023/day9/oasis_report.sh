#!/bin/bash

# https://adventofcode.com/2023/day/9

## part 1
## part 2

SCRIPT_DIR=$PWD/2023/day9/
INPUT_DATA=$SCRIPT_DIR/input_data

declare -a SEQUENCE_ENDS
declare -a SEQUENCE_STARTS

SUM_RIGHT=0
SUM_LEFT=0

function load_data() {
    while read -r line; do
        while [[ $line != "0"*" 0" ]]; do
            #echo "$line"
            last_num="${line##* }"
            first_num="${line%% *}"
            #echo "first_num:$first_num"
            #echo "$last_num"
            SEQUENCE_ENDS+=("$last_num")
            SEQUENCE_STARTS+=("$first_num")
            read -ra line_array <<< "$line"
            # echo ${#line_array[@]}
            # echo ${line_num}
            for ((i=0;i<${#line_array[@]}-1;i++)); do
                next=$((i+1))
                # curr_num=${line_array[i]}
                # next_num=${line_array[next]}
                #echo "curr:$curr_num nxt:$next_num"
                if [[ -z "$new_line" ]]; then
                    new_line="$(( line_array[next] - line_array[i] ))"
                else
                    new_line="$new_line $(( line_array[next] - line_array[i] ))"
                fi
            done
            #echo "new_line:$new_line"
            line="$new_line"
            new_line=""
            # last_num="${line##* }"
            # SEQUENCE_ENDS+=("$last_num")
            # echo "$last_num"
        done
        sum_right=$(echo "${SEQUENCE_ENDS[@]}" | tr " " "\n" | paste -sd"+" | bc)
        #echo "sum_right:$sum_right"
        SUM_RIGHT=$((SUM_RIGHT+sum_right))
        SEQUENCE_ENDS=()

        SEQUENCE_STARTS+=("0")
        read -ra SEQUENCE_STARTS <<< "$(echo "${SEQUENCE_STARTS[@]}" | tr " " "\n" | tac | paste -sd" ")"
        #echo "sequence_starts:" "${SEQUENCE_STARTS[@]}"
        sum_left=0
        for ((i=0;i<${#SEQUENCE_STARTS[@]}-1;i++)); do
            nxt=$((i+1))
            #echo "calc:${SEQUENCE_STARTS[nxt]} - $sum_left"
            sum_left=$((SEQUENCE_STARTS[nxt] - sum_left))
        done
        #echo "sum_left:$sum_left"
        SUM_LEFT=$((SUM_LEFT+sum_left))
        SEQUENCE_STARTS=()
    done
}

load_data < "$INPUT_DATA"

echo "Part 1 sum:"$SUM_RIGHT
echo "Part 2 sum:"$SUM_LEFT
