#!/bin/bash

# https://adventofcode.com/2023/day/3

## part 1
## part 2

INPUT_DATA=$1

declare -A LINES_ARR
declare -A SPECIAL_CHAR_IND
declare -A NUMBER_IND

LINE_NUMBER=1
while IFS= read -r line; do
  #echo "Line:$LINE_NUMBER"
  #### IMPORTANT: $ sign must be escaped to be used by grep!!
  char_indexes=$(echo "$line" | grep -obe "#" -e "+" -e "&" -e "\\$" -e "=" -e "%" -e "@" -e "/" -e "-" | grep -oE "[0-9]+")
  char_indexes="${char_indexes//$'\n'/ }"
  #echo "${char_indexes}"
  LINES_ARR[$LINE_NUMBER]="$line"
  SPECIAL_CHAR_IND[$LINE_NUMBER]="${char_indexes}"

  asterisk_indexes=$(echo "$line" | grep -ob "*" | grep -oE "[0-9]+")
  asterisk_indexes="${asterisk_indexes//$'\n'/ }"
  SPECIAL_CHAR_IND[$LINE_NUMBER]+=" ASTX:${asterisk_indexes}"

  ## remove special characters from the line to be able to parse numbers
  line=$(echo "$line" | tr -c '[:alnum:][:blank:]\n' '.')
  ##echo "LINE: $line"

  ind_counter=0
  IFS="."
  for num in $line
  do
    re='^[0-9]+$'
    if [[ $num =~ $re ]] ; then
      #echo "Index:$ind_counter Number:$num"
      NUMBER_IND["$LINE_NUMBER $ind_counter"]=$num
      num_lenght=$(echo -n "$num" | wc -c)
      for ((i=1;i<num_lenght;i++)); do
        ind_counter=$((ind_counter+1))
        #echo "Index:$ind_counter Number:$num"
        NUMBER_IND["$LINE_NUMBER $ind_counter"]=$num
      done
      ind_counter=$((ind_counter+1))
    fi
    ind_counter=$((ind_counter+1))
  done
  LINE_NUMBER=$((LINE_NUMBER+1))
done < $INPUT_DATA

SUM=0
GEAR_RATIO_SUM=0

for ((lne=1;lne<=${#LINES_ARR[*]};lne++)); do
    PREV_LINE=$((lne-1))
    CURR_LINE=${lne}
    NEXT_LINE=$((lne+1))
    ASTERISK_CHAR_IND="${SPECIAL_CHAR_IND[$CURR_LINE]##*ASTX:}" ## keep only numbers after "ASTX:"
    #echo "Line:${CURR_LINE} Indexes:${SPECIAL_CHAR_IND[$CURR_LINE]}"
    #echo "Asterisk_indexes:$ASTERISK_CHAR_IND"
    OTHER_CHAR_IND=${SPECIAL_CHAR_IND[$CURR_LINE]%ASTX:*} ## keep only numbers before "ASTX:"
    #echo "Other indexes:$OTHER_CHAR_IND"
    #echo "PREV_LINE:$PREV_LINE NEXT_LINE:$NEXT_LINE"
    SPECIAL_CHAR_IND[$CURR_LINE]="$ASTERISK_CHAR_IND $OTHER_CHAR_IND"
    ASTERISK_CHAR_IND=" ${ASTERISK_CHAR_IND} " ## append spaces for easier check for substring

    IFS=" "
    for ind in ${SPECIAL_CHAR_IND[$CURR_LINE]}
    do
      if [[ "$ASTERISK_CHAR_IND" == *" $ind "* ]]; then
        #echo "Asterisk index:$ind"
        AST_FOUND=0
      else
        AST_FOUND=1
      fi
      MULTIPLIERS=""

      if [[ ${NUMBER_IND["$PREV_LINE $ind"]} != "" ]]; then
        #echo "Number above found => Line:$PREV_LINE Index:$ind Number:${NUMBER_IND["$PREV_LINE $ind"]}"
        SUM=$((SUM+${NUMBER_IND["$PREV_LINE $ind"]}))
        [[ $AST_FOUND ]] && MULTIPLIERS="$MULTIPLIERS ${NUMBER_IND["$PREV_LINE $ind"]}"
      elif [[ ${NUMBER_IND["$PREV_LINE $((ind-1))"]} != "" || ${NUMBER_IND["$PREV_LINE $((ind+1))"]} != "" ]]; then
        if [[ ${NUMBER_IND["$PREV_LINE $((ind-1))"]} != "" ]]; then
          #echo "Number above left found => Line:$PREV_LINE Index:$ind Number:${NUMBER_IND["$PREV_LINE $((ind-1))"]}"
          SUM=$((SUM+${NUMBER_IND["$PREV_LINE $((ind-1))"]}))
          [[ $AST_FOUND ]] && MULTIPLIERS="$MULTIPLIERS ${NUMBER_IND["$PREV_LINE $((ind-1))"]}"
        fi
        if [[ ${NUMBER_IND["$PREV_LINE $((ind+1))"]} != "" ]]; then
          #echo "Number above right found => Line:$PREV_LINE Index:$ind Number:${NUMBER_IND["$PREV_LINE $((ind+1))"]}"
          SUM=$((SUM+${NUMBER_IND["$PREV_LINE $((ind+1))"]}))
          [[ $AST_FOUND ]] && MULTIPLIERS="$MULTIPLIERS ${NUMBER_IND["$PREV_LINE $((ind+1))"]}"
        fi
      fi

      if [[ ${NUMBER_IND["$CURR_LINE $((ind-1))"]} != "" ]]; then
        #echo "Number left found => Line:$CURR_LINE Index:$ind Number:${NUMBER_IND["$CURR_LINE $((ind-1))"]}"
        SUM=$((SUM+${NUMBER_IND["$CURR_LINE $((ind-1))"]}))
        [[ $AST_FOUND ]] && MULTIPLIERS="$MULTIPLIERS ${NUMBER_IND["$CURR_LINE $((ind-1))"]}"
      fi
      if [[ ${NUMBER_IND["$CURR_LINE $((ind+1))"]} != "" ]]; then
        #echo "Number right found => Line:$CURR_LINE Index:$ind Number:${NUMBER_IND["$CURR_LINE $((ind+1))"]}"
        SUM=$((SUM+${NUMBER_IND["$CURR_LINE $((ind+1))"]}))
        [[ $AST_FOUND ]] && MULTIPLIERS="$MULTIPLIERS ${NUMBER_IND["$CURR_LINE $((ind+1))"]}"
      fi

      if [[ ${NUMBER_IND["$NEXT_LINE $ind"]} != "" ]]; then
        #echo "Number below found => Line:$NEXT_LINE Index:$ind Number:${NUMBER_IND["$NEXT_LINE $ind"]}"
        SUM=$((SUM+${NUMBER_IND["$NEXT_LINE $ind"]}))
        [[ $AST_FOUND ]] && MULTIPLIERS="$MULTIPLIERS ${NUMBER_IND["$NEXT_LINE $ind"]}"
      elif [[ ${NUMBER_IND["$NEXT_LINE $((ind-1))"]} != "" || ${NUMBER_IND["$NEXT_LINE $((ind+1))"]} != "" ]]; then
        if [[ ${NUMBER_IND["$NEXT_LINE $((ind-1))"]} != "" ]]; then
          #echo "Number below left found => Line:$NEXT_LINE Index:$ind Number:${NUMBER_IND["$NEXT_LINE $((ind-1))"]}"
          SUM=$((SUM+${NUMBER_IND["$NEXT_LINE $((ind-1))"]}))
          [[ $AST_FOUND ]] && MULTIPLIERS="$MULTIPLIERS ${NUMBER_IND["$NEXT_LINE $((ind-1))"]}"
        fi
        if [[ ${NUMBER_IND["$NEXT_LINE $((ind+1))"]} != "" ]]; then
          #echo "Number below right found => Line:$NEXT_LINE Index:$ind Number:${NUMBER_IND["$NEXT_LINE $((ind+1))"]}"
          SUM=$((SUM+${NUMBER_IND["$NEXT_LINE $((ind+1))"]}))
          [[ $AST_FOUND ]] && MULTIPLIERS="$MULTIPLIERS ${NUMBER_IND["$NEXT_LINE $((ind+1))"]}"
        fi
      fi

      if [[ $AST_FOUND ]]; then
        NUMBER_OF_MULTIPLIERS=$(echo -n "$MULTIPLIERS" | wc -w)
        if [[ $NUMBER_OF_MULTIPLIERS -eq 2 ]]; then
          mult1="$(echo "$MULTIPLIERS" | cut -d " " -f2)"
          mult2="$(echo "$MULTIPLIERS" | cut -d " " -f3)"
          #echo "mult1:$mult1 mult2:$mult2" 
          GEAR_RATIO=$((mult1*mult2))
          GEAR_RATIO_SUM=$((GEAR_RATIO_SUM+GEAR_RATIO))
        fi
      fi
    done
done

echo "SUM:$SUM" #525911
echo "GEAR_RATIO_SUM:$GEAR_RATIO_SUM" #75805607

