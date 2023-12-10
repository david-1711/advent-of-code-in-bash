#!/bin/bash

# https://adventofcode.com/2023/day/8

## part 1

SCRIPT_DIR=$PWD/2023/day8/
INPUT_DATA=$SCRIPT_DIR/input_data

declare -A MAP

INSTRUCTIONS=""

function load_data() {
  read -r INSTRUCTIONS
  read -r
  while read -r key l r; do
    MAP[$key]="$l $r"
  done < <(cat | tr -ds '=(,)' ' ')  
}

load_data < "$INPUT_DATA"

CURRENT_POSITION="AAA"

step=0
inst_id=0
while [[ $CURRENT_POSITION != "ZZZ" ]]; do
    step=$((step+1))
    case ${INSTRUCTIONS:inst_id:1} in
        L)
            CURRENT_POSITION=${MAP[$CURRENT_POSITION]%% *}
        ;;
        R)
            CURRENT_POSITION=${MAP[$CURRENT_POSITION]##* }
        ;;
    esac
    inst_id=$(( (inst_id+1) % ${#INSTRUCTIONS}))
done

# for k in "${!MAP[@]}"
# do
#   printf "%s\n" "$k ${MAP[$k]}"
# done

echo "Steps:$step"
