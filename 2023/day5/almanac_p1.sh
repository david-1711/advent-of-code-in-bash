#!/bin/bash

## https://adventofcode.com/2023/day/5

## part 1

SCRIPT_DIR=$PWD/2023/day5/
INPUT_DATA=$SCRIPT_DIR/input_data

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
done < "$INPUT_DATA"

#echo "$SEEDS"

##going through blocks
for ((k=1;k<=${#RANGES[*]};k++)); do
    #printf "%s\n" "$k=${RANGES[$k]}"
    MAP=""
    IFS=" "
    ## all seeds must get through first block before proceeding
    for s in $SEEDS; do
        #echo -e "\nseed:$s"
        match_found=-1
        IFS=";"
        for r in ${RANGES[$k]}; do
            #echo "Range:$r"
            src=$(echo "$r" | cut -d" " -f2)
            lenght=$(echo "$r" | cut -d" " -f3)
            dst=$(echo "$r" | cut -d" " -f1)
            #echo "$src $lenght $dst"
            if [[ $s -ge $src && $s -lt $((src+lenght)) ]]; then
                ##offset if the seed from range start
                offset=$((s-src))
                MAP="$MAP $((dst+offset))"
                #echo "match(offset:$offset): $((dst+offset))"
                match_found=0
            fi
            if [[ $match_found == 0 ]]; then
                break
            fi
        done
            if [[ $match_found != 0 ]]; then
                #echo "no match" ## not mapped
                MAP="$MAP $s"
            fi
    done
    SEEDS="$MAP"
    #echo "New seeds: $SEEDS"
done

echo "Lowest location number: $(echo "$SEEDS" | tr ' ' '\n' | sort -n | head -n 2 | tail -n 1)" #650599855

