#!/bin/bash

# https://adventofcode.com/2023/day/7

## part 2

SCRIPT_DIR=$PWD/2023/day7/
INPUT_DATA=$SCRIPT_DIR/input_data

declare -a GAMES

function remap_hand()
{
    ## J is now remapped to "-" since this character is "lower" then
    ## letters and numbers when using sort command
    echo "$1" \
        | tr "A" "E" \
        | tr "K" "D" \
        | tr "Q" "C" \
        | tr "J" "-" \
        | tr "T" "A"
}

function determine_hand_strenght()
{
    local counted_hand=$1
    local lenght

    lenght=$(echo -n "$counted_hand" | wc -c)
    #echo "lnght:"$lenght
    #echo "counted hand:"${counted_hand}
    
    card_count=""
    for (( i=0;i<=lenght;i=i+4 )); do
        card_count="$card_count ${counted_hand:$i:1}"
    done
    #echo "crd_count:$card_count"

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

function optimize_jocker_hand()
{
    local hand=$1
    local counted_hand=$2
    local optimized_hand
    local jockers_num
    
    jockers_num=$(echo "$hand" |  sed 's/./&\n/g' | grep -c -)
    #echo "hand:$hand jockers_num:$jockers_num cnt_hnd:$counted_hand"
    #echo "hand:$hand"

    if [[ $jockers_num == 0 ]]; then
        optimized_hand="$hand"
        echo "$optimized_hand"
        return 0
    elif [[ $jockers_num == 5 ]]; then
        optimized_hand="A A A A A"
        echo "$optimized_hand"
        return 0
    fi

    # determine_hand_strenght "$counted_hand"
    # score=$?
    # #echo "score:$score"

    max_value=0
    lenght=$(echo -n "$counted_hand" | wc -c)
    for (( i=0;i<=lenght;i=i+4 )); do
        next=$((i+2))
        if [[ ${counted_hand:$i:1} -gt $max_value ]]; then
            if [[ ${counted_hand:$next:1} != "-" ]]; then
                max_value=${counted_hand:$i:1}
                card=${counted_hand:$next:1}
            fi
        fi
    done
    #echo "max_value:$max_value card:$card"

    optimized_hand="${hand//-/$card}"
    echo "$optimized_hand"
    return 0
}

while IFS= read -r line; do
    hand=${line%% *}
    bid=${line#* }
    #echo $hand $bid
    remapped_hand=$(remap_hand "$hand")
    sorted_hand=$(remap_hand "$hand" |  sed 's/./&\n/g' | sort -r)
    # shellcheck disable=SC2116
    # shellcheck disable=SC2086
    sorted_hand="$(echo $sorted_hand)" ##to remove needles spaces and tabs created by sort command
    count_unique=$(echo "$sorted_hand" | tr " " "\n" | uniq -c)
    # shellcheck disable=SC2116
    # shellcheck disable=SC2086
    cunt_unique="$(echo ${count_unique})" ##to remove needles spaces and tabs created by uniq command
    opt_card=$(optimize_jocker_hand "$sorted_hand" "$cunt_unique")

    sorted_hand="$(echo "$opt_card" |  tr " " "\n" | sort -r)" ##to remove needles spaces and tabs created by sort command
    # shellcheck disable=SC2116
    # shellcheck disable=SC2086
    sorted_hand="$(echo $sorted_hand)" ##to remove needles spaces and tabs created by sort command
    count_unique=$(echo "$sorted_hand" | tr " " "\n" | uniq -c)
    # shellcheck disable=SC2116
    # shellcheck disable=SC2086
    cunt_unique="$(echo ${count_unique})" ##to remove needles spaces and tabs created by uniq command

    determine_hand_strenght "$cunt_unique"
    strenght=$?
    #echo "sorted_hand:$sorted_hand opt_card:$opt_card"
    #echo "Type: $strenght"
    #sorted_hand="$(tr -d '[:blank:]' <<< "$sorted_hand")"
    GAMES+=("$strenght;$remapped_hand;$sorted_hand;$bid")
    #tmp_ifs=$(printf "%q" "$IFS")
    #echo "orig:$tmp_ifs" ##find current IFS to return to
    IFS=$'\n' #change IFS
    ## sorting by using 2 keys
    ## key1 is $strenght
    ## key2 is #remapped_hand
    # shellcheck disable=SC2207
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

echo "Total winings:$sum" #250665248
