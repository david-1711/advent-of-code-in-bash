#!/bin/bash

# https://adventofcode.com/2023/day/11

## part 2

SCRIPT_DIR=$PWD/2023/day11/
INPUT_DATA=$SCRIPT_DIR/input_data

declare -a LINES
declare -A GALAXIES

SCALE=1000000
((SCALE--))

function expand_universe_horizontal()
{
    index=0
    expanded_columns=""
    while read -r line; do
        if [[ $line != *"#"* ]]; then
            #echo "$line"
            LINES["$index"]="$line"
            #echo "${LINES[$index]}"
            expanded_columns="$expanded_columns $index"
            ((index++))
        else
            #echo "$line"
            LINES["$index"]="$line"
            #echo "${LINES[$index]}"
            ((index++))
        fi
    done
    LINES["$index"]="$expanded_columns"
    LINES["$index"]="ex_rows ${LINES["$index"]/ /}"
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
            if [[ -z ${LINES[$lines_num]} ]]; then
                LINES[lines_num]="$i"
            else
                LINES[lines_num]="${LINES[$lines_num]} $i"
            fi

        fi
    done
    LINES[lines_num]="ex_colm ${LINES[$lines_num]}"
    for ((g=0;g<=lines_num;g++)); do
        echo "${LINES[g]}"
    done    
}

function expand_locations_of_galaxies()
{
    local expanded_rows
    local expanded_columns
    local column_multiplier
    local row_multiplier

    expanded_rows=${LINES[-2]#* }
    expanded_columns=${LINES[-1]#* }

    for ((i=0;i<${#GALAXIES[@]};i++)); do
        # printf "%s\n" "${GALAXIES[$i]%%,*}"
        # printf "%s\n" "${GALAXIES[$i]#*,}"
        #printf "%s\n" "old:${GALAXIES[$i]}"
        column_multiplier=$(echo "$expanded_columns" | sed "s/\([^ ]\+\)/(\1<${GALAXIES[$i]#*,}) + /g; s/ + $//" | bc)
        row_multiplier=$(echo "$expanded_rows" | sed "s/\([^ ]\+\)/(\1<${GALAXIES[$i]%%,*}) + /g; s/ + $//" | bc)
        GALAXIES["$i"]="$(( ${GALAXIES[$i]%%,*}+ (row_multiplier*SCALE) )),$(( ${GALAXIES[$i]#*,}+ (column_multiplier*SCALE) ))"
        #echo "rm:$row_multiplier cm:$column_multiplier"
        #printf "%s\n" "${GALAXIES[$i]}"
    done
}

## x1=$1 y1=$2 x2=$3 y2=$4
function calculate_distance()
{
    local x1
    local x2
    local y1
    local y2

    x1=$1
    y1=$2
    x2=$3
    y2=$4

    num1=$((x2 - x1))
    num1=${num1/-/}
    #num1=$((num1+column_multiplier))
    num2=$((y2 - y1))
    num2=${num2/-/}
    #num2=$((num2+row_multiplier))
    echo $((num1+num2))
    
    #echo -e "row_multiplier=$row_multiplier column_multiplier:$column_multiplier"
    #echo "x1:$x1 y1:$y1 x2:$x2 y2:$y2 dist:$((num1+num2))"
}

function find_permutatons()
{
    for ((x=0;x<${#GALAXIES[@]};x++)); do
        #echo "${GALAXIES[$x]}"
        for ((i=x;i<${#GALAXIES[@]};i++)); do
            if [[ ${GALAXIES[$x]} != "${GALAXIES[$i]}" ]]; then
                #echo "${GALAXIES[$x]} ${GALAXIES[$i]}"
                distance=$(calculate_distance "${GALAXIES[$x]%%,*}" "${GALAXIES[$x]#*,}" "${GALAXIES[$i]%%,*}" "${GALAXIES[$i]#*,}")
                echo "$distance"
            fi
        done
    done
}

expand_universe_horizontal < "$INPUT_DATA"
expand_universe_vertical

# for ((i=0;i<${#GALAXIES[@]};i++)); do
#   printf "%s\n" "${GALAXIES[$i]}"
# done

expand_locations_of_galaxies

find_permutatons | paste -sd"+" | bc #363293506944
