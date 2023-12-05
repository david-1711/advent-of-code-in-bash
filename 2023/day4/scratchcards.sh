#!/bin/bash

# https://adventofcode.com/2023/day/4

## part 1
## part 2

INPUT_DATA=$1

function find_match()
{
    local array=$1
    local value=$2

    if echo "${array[@]}" | grep -Fq " $value "; then
        return 0
    else
        return 1
    fi
}

declare -A CARDS

CARD_NUMBER=1
POWER_SUM=0
while IFS= read -r line; do
    DATA="${line#*:}"
    WIN_NUM="${DATA%%|*}"
    MY_NUM="${DATA#*|} "

    if [[ -z ${CARDS[$CARD_NUMBER]} ]]; then 
        CARDS[$CARD_NUMBER]="0" # initialize to 0 otherwise will be empty and sum won't work'
    fi
    CARDS[$CARD_NUMBER]=$((CARDS[$CARD_NUMBER]+1))
    # echo "WIN:\"$WIN_NUM\""
    # echo "MY:\"$MY_NUM\""
    matches=0
    for num in $MY_NUM; do
        if find_match "$WIN_NUM" "$num"; then
            matches=$((matches+1))
        fi
    done

    if [[ $matches -gt 0 ]]; then
        pwr=$((matches-1))
        POWER=$((2**pwr))
        POWER_SUM=$((POWER_SUM+POWER))
        #echo "Line:$CARD_NUMBER Matches:$matches Power:$POWER Power_sum:$POWER_SUM"
    fi

    for ((mat=0;mat<matches;mat++)); do
        sum=$((CARD_NUMBER+1+mat))
        if [[ -z ${CARDS[$sum]} ]]; then 
            CARDS[$sum]="0" # initialize to 0 otherwise will be empty and sum won't work'
        fi
        #echo "There is ${CARDS[$sum]} cards with id $sum"
        #CARDS[$CARD_NUMBER] holds number of duplicates of specific card X, This means, every matched card should get
        #the same number of duplicates since duplicated X cards will produce duplicated matching cards.
        #So in other wods, if current card has Y copies, all matches should be also appended with Y copies
        CARDS[$sum]=$((CARDS[$sum] + CARDS[$CARD_NUMBER]))
        #echo "There is now ${CARDS[$sum]} cards with id $sum"
    done
    CARD_NUMBER=$((CARD_NUMBER+1))
done < $INPUT_DATA

echo "Power_sum:$POWER_SUM" #22674

sum=0
for ((card_num=1;card_num<=${#CARDS[*]};card_num++)); do
# for card_num in "${!CARDS[@]}"; do
  #printf "%s\n" "$card_num=${CARDS[$card_num]}"
  sum=$((sum+${CARDS[$card_num]}))
done

echo "Number_of_cards:$sum" #5747443

