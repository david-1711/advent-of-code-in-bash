#!/bin/bash

# https://adventofcode.com/2023/day/7

## part 1

INPUT_DATA=$1

declare -a GAMES

function remap_hand()
{
    echo "$1" \
        | tr "A" "E" \
        | tr "K" "D" \
        | tr "Q" "C" \
        | tr "J" "B" \
        | tr "T" "A"
}

function determine_hand_strenght()
{
    local counted_hand=$1
    local lenght

    lenght=$(echo -n "$counted_hand" | wc -c)
    # echo "lnght:"$lenght
    #echo "counted hand:${counted_hand}"
    
    card_count=""
    for (( i=0;i<=lenght;i=i+4 )); do
        card_count="$card_count ${counted_hand:$i:1}"
    done
    #echo "$card_count"

    if echo "$card_count" | grep -q 5; then
        return 6
    elif echo "$card_count" | grep -q 4; then
        return 5
    elif echo "$card_count" | grep -q 3; then
        if echo "$card_count" | grep -q 2; then
            return 4
        fi
        return 3
    elif [[ $(echo "$card_count" | tr " " "\n" | grep -c 2) == 2 ]]; then
        return 2
    elif echo "$card_count" | grep -q 2; then
        return 1
    else
        return 0
    fi
}

while IFS= read -r line; do
    hand=${line%% *}
    bid=${line#* }
    #echo $hand $bid
    remapped_hand=$(remap_hand "$hand")
    sorted_hand=$(remap_hand "$hand" |  sed 's/./&\n/g' | sort -r)
    sorted_hand="$(echo $sorted_hand)" ##to remove needles spaces and tabs created by sort command
    count_unique=$(echo "$sorted_hand" | tr " " "\n" | uniq -c)
    cunt_unique="$(echo ${count_unique})" ##to remove needles spaces and tabs created by uniq command
    determine_hand_strenght "$cunt_unique"
    strenght=$?
    #echo "$sorted_hand"
    #echo "Type: $strenght"
    #sorted_hand="$(tr -d '[:blank:]' <<< "$sorted_hand")"
    GAMES+=("$strenght;$remapped_hand;$bid")
    #tmp_ifs=$(printf "%q" "$IFS")
    #echo "orig:$tmp_ifs" ##find current IFS to return to
    IFS=$'\n' #change IFS
    ## sorting by using 2 keys
    ## key1 is $strenght
    ## key2 is #remapped_hand
    GAMES=($(sort -t ";" -k 1 -k 2 <<<"${GAMES[*]}"))
    IFS=$' \t\n' ##return to original IFS
done < "$INPUT_DATA"

# sum=0
for ((i=0;i<${#GAMES[@]};i++)); do
  rank=$((i+1))
  bid="${GAMES[$i]}"
  bid=${bid##*;}
  #echo "rank:$rank bid=$bid ${GAMES[$i]}"
  sum=$((sum+(rank*bid)))
done

echo "Total winings:$sum" #250120186