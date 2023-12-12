#!/bin/bash

# https://adventofcode.com/2023/day/11

## part 1

SCRIPT_DIR=$PWD/2023/day11/
INPUT_DATA=$SCRIPT_DIR/test_data

declare -a LINES
declare -A GALAXIES

function expand_universe_horizontal()
{
    index=0  
    while read -r line; do
        #echo "$line"
        LINES["$index"]="$line"
        #echo "${LINES[$index]}"
        ((index++))
        if [[ $line != *"#"* ]]; then
            #echo "$line"
            LINES["$index"]="$line"
            #echo "${LINES[$index]}"
            ((index++))
        fi
    done
}

function expand_universe_vertical()
{
    line_lenght=$(echo -n "${LINES[0]}" | wc -c)
    lines_num=${#LINES[@]}
    galaxy_index=0
    #echo "columns:$line_lenght rows:$lines_num"
    for ((i=0;i<line_lenght;i++)); do
        galaxy_found=1
        for ((j=0;j<lines_num;j++)); do
            #echo "first_char:""${LINES[$j]:$i:1}"
            if [[ ${LINES[$j]:$i:1} == "#" ]]; then
                #echo "Galaxy found in row: $i"
                galaxy_found=0
                GALAXIES["$galaxy_index"]="$j,$i"
                ((galaxy_index++))
                #break
            fi
        done

        if [[ $galaxy_found == 1 ]]; then
            #echo "Galaxy not found in row: $i"
            for ((g=0;g<lines_num;g++)); do
                #LINES[j]=$(echo "${LINES[$j]}" | sed "s/./&./$i") ## insert dot to $i position
                LINES[g]="${LINES[$g]:0:$i}.${LINES[$g]:$i}" ## insert dot after $i-1 position
                #echo "${LINES[g]}"
            done
            ((i++))
            line_lenght=$(echo -n "${LINES[0]}" | wc -c)
            #echo "columns:$line_lenght rows:$lines_num"
        fi
    done
    for ((g=0;g<lines_num;g++)); do
        echo "${LINES[g]}"
    done    
}

## x1=$1 y1=$2 x2=$3 y2=$4
function calculate_distance()
{
    num1=$(($3 - $1))
    num1=${num1/-/}
    num2=$(($4 - $2))
    num2=${num2/-/}
    echo $((num1+num2))
}

function find_permutatons()
{
    for ((x=0;x<${#GALAXIES[@]};x++)); do
        #echo "${GALAXIES[$x]}"
        for ((i=x;i<${#GALAXIES[@]};i++)); do
            if [[ ${GALAXIES[$x]} != "${GALAXIES[$i]}" ]]; then
                #echo -n "${GALAXIES[$x]} ${GALAXIES[$i]}"
                distance=$(calculate_distance "${GALAXIES[$x]%%,*}" "${GALAXIES[$x]#*,}" "${GALAXIES[$i]%%,*}" "${GALAXIES[$i]#*,}")
                echo " $distance"
            fi
        done
    done
}

expand_universe_horizontal < "$INPUT_DATA"
expand_universe_vertical

# for ((i=0;i<${#GALAXIES[@]};i++)); do
#   printf "%s\n" "${GALAXIES[$i]}"
# done

find_permutatons | paste -sd"+" | bc
