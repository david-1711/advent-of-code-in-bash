#!/bin/bash

## https://adventofcode.com/2023/day/5

## part 2

INPUT_DATA=$1

declare -a SEEDS_LIST
declare -A RANGES

count_blk=0
while IFS= read -r line; do
    if [[ $line == "seeds:"* ]]; then
        SEEDS="${line#*:}"
    elif [[ -z $line ]]; then
        count_blk=$((count_blk+1))
    elif [[ $line == [a-zA-Z]* ]]; then
        :
    else
        if [[ -z ${RANGES["$count_blk"]} ]]; then
            RANGES["$count_blk"]+="$line"
        else
            RANGES["$count_blk"]+=";$line"
        fi
    fi
done < $INPUT_DATA

read -ra SEEDS_LIST <<< "$SEEDS"

#echo "$SEEDS"
#echo "seeds number: ${#SEEDS_LIST[@]}"

IFS=" "
for ((s=0;s<${#SEEDS_LIST[@]};s=s+2)); do
    #echo "$s=${SEEDS_LIST[$s]}"
    next=$((s+1))
    SEEDS_LIST[next]=$(( SEEDS_LIST[s] + SEEDS_LIST[next] ))
    #echo "$next=${SEEDS_LIST[$next]}"
done

##going through blocks
# cnt=0
for ((k=1;k<=${#RANGES[*]};k++)); do
    #printf "%s\n" "$k=${RANGES[$k]}"
    MAP=""
    seeds_list_lenght=${#SEEDS_LIST[*]}
    for ((s=0;s<$seeds_list_lenght;s=s+2)); do
        #echo "seeds_lenght:$seeds_list_lenght"
        s_start=${SEEDS_LIST[$s]}
        next=$((s+1))
        s_end=${SEEDS_LIST[$next]}
        #echo "Seed_start:$s_start Seed_end:$s_end"
        match_found=-1
        IFS=";"
        for r in ${RANGES[$k]}; do
            #echo "Range:$r"
            src=$(echo "$r" | cut -d" " -f2)
            lenght=$(echo "$r" | cut -d" " -f3)
            dst=$(echo "$r" | cut -d" " -f1)
            if [[ $s_start -gt $src ]]; then
                overlap_start=$s_start
            else
                overlap_start=$src
            fi

            if [[ $s_end -lt $((src+lenght)) ]]; then
                overlap_end=$s_end
            else
                overlap_end=$((src+lenght))
            fi
            #echo "$s_start $s_end $overlap_start $overlap_end"
            if [[ $overlap_start -lt $overlap_end ]]; then
                MAP="$MAP $((overlap_start-src+dst)) $((overlap_end-src+dst))"
                if [[ $overlap_start -gt $s_start ]]; then
                    SEEDS_LIST+=("$s_start")
                    SEEDS_LIST+=("$overlap_start")
                    seeds_list_lenght=$((seeds_list_lenght+2))
                fi
                if [[ $s_end -gt $overlap_end ]]; then
                    SEEDS_LIST+=("$overlap_end")
                    SEEDS_LIST+=("$s_end")
                    seeds_list_lenght=$((seeds_list_lenght+2))
                fi
                #echo "match found: $((overlap_start-src+dst)) $((overlap_end-src+dst))"
                match_found=0     
            fi
            if [[ $match_found == 0 ]]; then
                break
            fi
        done
        if [[ $match_found != 0 ]]; then
            #echo "no match" ## not mapped
            MAP="$MAP $s_start $s_end"
        fi
    done
    SEEDS="$MAP"
    SEEDS_LIST=() ## remove everything from current seeds_list
    s=0 ## start iterating from begining through new seed_list
    IFS=" "
    read -ra SEEDS_LIST <<< "$SEEDS"
    #echo -e "\nNew seeds: $SEEDS"
    # cnt=$((cnt++))
    # for ((s=0;s<${#SEEDS_LIST[@]};s=s+1)); do
    #     echo "$s=${SEEDS_LIST[$s]}"
    # done
# break
#  [[ $cnt == 2 ]] && break
done

echo "Min seeds: $(echo "$SEEDS" | tr ' ' '\n' | sort -n | head -n 2 | tail -n 1)"

