#!/bin/bash

# https://adventofcode.com/2023/day/2

## part 1

SCRIPT_DIR=$PWD/2023/day2/
INPUT_DATA=$SCRIPT_DIR/input_data

RED_MAX=12
GREEN_MAX=13
BLUE_MAX=14

declare -a VALID_GAMES

while IFS= read -r line; do
  GAME_NUM=$(echo "$line" | cut -d ':' -f1)
  GAME_NUM=${GAME_NUM#*Game }
  GAME_SETS=$(echo "$line" | cut -d ':' -f2)
  GAME_SETS_NUM=$(grep -o ";" <<<"$GAME_SETS" | wc -l)
  GAME_SETS_NUM=$((GAME_SETS_NUM+1))
  #echo "GAME: ${GAME_NUM}, SETS: ${GAME_SETS_NUM}"
  REDS=0
  GREENS=0
  BLUES=0
  IFS=";"
  for set in $GAME_SETS
  do
    SET_INVALID=false
    IFS=","
    for data in $set
    do
      case $data in
        *red)
          REDS=${data% *}
          ;;
        *green)
          GREENS=${data% *}
          ;;
        *blue)
          BLUES=${data% *}
          ;;
        *)
          echo "ERROR"
          ;;
      esac
      if [[ $REDS -gt $RED_MAX || $GREENS -gt $GREEN_MAX || $BLUES -gt $BLUE_MAX ]]; then
        #echo "Set $GAME_NUM is not valid"
        SET_INVALID=true
        break
      fi
    done
      if [[ $SET_INVALID == "true" ]]; then
        break
      fi
  done
  if [[ $SET_INVALID == "false" ]]; then
    VALID_GAMES+=("$GAME_NUM")
  fi
done < "${INPUT_DATA}"

#echo -e "\nValid games:"
SUM_VALID=0
for game in "${VALID_GAMES[@]}"
do
   #echo "$game"
   SUM_VALID=$((SUM_VALID+game))
done

echo "Sum of valid games: "$SUM_VALID #2204

#part 2

SUM_OF_POWER=0

while IFS= read -r line; do
  GAME_NUM=$(echo "$line" | cut -d ':' -f1)
  GAME_NUM=${GAME_NUM#*Game }
  GAME_SETS=$(echo "$line" | cut -d ':' -f2)
  GAME_SETS_NUM=$(grep -o ";" <<<"$GAME_SETS" | wc -l)
  GAME_SETS_NUM=$((GAME_SETS_NUM+1))
  #echo "$line"
  REDS=0
  GREENS=0
  BLUES=0
  RED_MAX=0
  GREEN_MAX=0
  BLUE_MAX=0
  IFS=";"
  for set in $GAME_SETS
  do
    IFS=","
    for data in $set
    do
      case $data in
        *red)
          REDS=${data% *}
          if [[ $REDS -gt $RED_MAX ]]; then
            RED_MAX=$REDS
          fi
          ;;
        *green)
          GREENS=${data% *}
          if [[ $GREENS -gt $GREEN_MAX ]]; then
            GREEN_MAX=$GREENS
          fi
          ;;
        *blue)
          BLUES=${data% *}
          if [[ $BLUES -gt $BLUE_MAX ]]; then
            BLUE_MAX=$BLUES
          fi
          ;;
        *)
          echo "ERROR"
          ;;
      esac
    done
  done
  #echo "Min red:$RED_MAX Min green:$GREEN_MAX Min blue:$BLUE_MAX"
  POWER=$((RED_MAX*GREEN_MAX*BLUE_MAX))
  #echo "Power: $POWER"
  SUM_OF_POWER=$((SUM_OF_POWER+POWER))
done < "${INPUT_DATA}"

echo "Sum of power: $SUM_OF_POWER" #71036

