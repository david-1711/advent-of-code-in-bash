#!/bin/bash

# https://adventofcode.com/2023/day/8

## part 2

SCRIPT_DIR=$PWD/2023/day8/
INPUT_DATA=$SCRIPT_DIR/input_data

declare -A MAP
declare -a START_POSITIONS
declare -a CYCLES

INSTRUCTIONS=""

function load_data() {
  read -r INSTRUCTIONS
  read -r
  while read -r key l r; do
    [[ $key == *A ]] && START_POSITIONS+=("$key")
    MAP[$key]="$l $r"
  done < <(cat | tr -ds '=(,)' ' ')  
}

load_data < "$INPUT_DATA"

for start in "${START_POSITIONS[@]}"; do
  CURRENT_POSITION="$start"
  #echo "curr_start:$CURRENT_POSITION"
  steps=0
  inst_id=0
  while [[ $CURRENT_POSITION != *Z ]]; do
      steps=$((steps+1))
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
  CYCLES+=("$steps")
done

# for k in "${!MAP[@]}"
# do
#   printf "%s\n" "$k ${MAP[$k]}"
# done

## least common multiple(LCM)
  for cycle in "${CYCLES[@]}"; do
    #echo "cycle:$cycle"
    factor "$cycle" | cut -d " " -f2- | tr ' ' '\n' | sort -n | uniq -c
  done > "$SCRIPT_DIR"/output_file ## <count> <LCM>

# 1. sort by <count> in reverse and by <LCM>
# 2. print only unique elements
# 3. remove space from start, reverse <count> <LCM> to be <LCM> <count>
# 4. convert <count> <LCM> to <count>^<LCM>
# 5. calculate power for each line
# 6. multiply all the powers 
echo -n "Steps:"
sort -k2n -k1nr "$SCRIPT_DIR"/output_file \
  | uniq -f1 | tr -s ' ' \
  | sed 's/ //' | awk '{print $2, $1}' | sed -e "s/ /^/g" \
  | bc | paste -sd'*' | bc

rm "$SCRIPT_DIR"/output_file
