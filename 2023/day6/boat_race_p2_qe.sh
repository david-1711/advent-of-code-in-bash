#!/bin/bash

# https://adventofcode.com/2023/day/6

## part 2 - using quadratic equasion instead of for loop

INPUT_DATA=$1

TIME=$(sed 's/[^0-9]*//g' <<< $(head -n 1 $INPUT_DATA))
DIST=$(sed 's/[^0-9]*//g' <<< $(tail -n 1 $INPUT_DATA))

## supporting only integers
function solve_quadratic_equasion()
{
    local x=$1
    local y=$2
    local z=$3

    if [[ $x = 0 ]]; then
        echo "Not a quadratic equation.";
        return 1;
    fi

    D=$(( ($y)*($y)-4*($x)*($z) ))

    if [[ $D -gt 0 ]]; then
        echo -n "$(echo -e "scale=3\n0.5*(-($y)+sqrt($D))/($x)" | bc) "  #x1
        echo "$(echo -e "scale=3\n0.5*(-($y)-sqrt($D))/($x)" | bc)" #x2
    else
        echo -n "($(echo -e "scale=3\n-0.5*($y)/($x)" | bc), $(echo -e "scale=3\n0.5*sqrt(-($D))/($x)" | bc))"  #x1
        echo "($(echo -e "scale=3\n-0.5*($y)/($x)" | bc), $(echo -e "scale=3\n-0.5*sqrt(-($D))/($x)" | bc))"  #x2
    fi
}

## [[ $((n*(TIME-n))) -gt $DIST ]]
## $TIMEn - n^2 > $DIST => - n^2 + $TIMEn - $DIST = 0
X12="$(solve_quadratic_equasion "-1" "$TIME" "-$DIST")"

X1_int=$(echo "${X12%% *}" | awk '{printf("%d\n",$1 + 0.99)}') #round to higher int
X2_int=$(echo "${X12#* }" | awk '{printf("%d\n",$1 + 0.99)}') #round to higher int

echo "Ways to beat the game: $((X2_int-X1_int))"
