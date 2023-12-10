#!/bin/bash

# https://adventofcode.com/2023/day/1

SCRIPT_DIR=$PWD/2023/day1/
INPUT_DATA=$SCRIPT_DIR/input_data

## part 1

echo -n "" > "$SCRIPT_DIR"/output_data1
echo -n "" > "$SCRIPT_DIR"/output_data2

while IFS= read -r line; do
  #echo $line | sed 's/[^0-9]*//g' >> "$SCRIPT_DIR"/output_data1
  echo "${line//[^0-9]/}" >> "$SCRIPT_DIR"/output_data1
done < "$INPUT_DATA"

while IFS= read -r line; do
  echo "${line:0:1}${line: -1}" >> "$SCRIPT_DIR"/output_data2
done < "$SCRIPT_DIR"/output_data1

SUM=0
while IFS= read -r line; do
  [[ -n $line ]] && SUM=$((SUM+line))
done < "$SCRIPT_DIR"/output_data2
echo "SUM: "$SUM #53974

## part 2

cp "$INPUT_DATA" "$SCRIPT_DIR"/input_data2

sed -i 's/sevenine/79/g' "$SCRIPT_DIR"/input_data2
sed -i 's/nineight/98/g' "$SCRIPT_DIR"/input_data2
sed -i 's/fiveight/58/g' "$SCRIPT_DIR"/input_data2
sed -i 's/threeight/38/g' "$SCRIPT_DIR"/input_data2
sed -i 's/eighthree/83/g' "$SCRIPT_DIR"/input_data2
sed -i 's/eightwo/82/g' "$SCRIPT_DIR"/input_data2
sed -i 's/twone/21/g' "$SCRIPT_DIR"/input_data2
sed -i 's/oneight/18/g' "$SCRIPT_DIR"/input_data2

sed -i 's/nine/9/g' "$SCRIPT_DIR"/input_data2
sed -i 's/eight/8/g' "$SCRIPT_DIR"/input_data2
sed -i 's/seven/7/g' "$SCRIPT_DIR"/input_data2
sed -i 's/six/6/g' "$SCRIPT_DIR"/input_data2
sed -i 's/five/5/g' "$SCRIPT_DIR"/input_data2
sed -i 's/four/4/g' "$SCRIPT_DIR"/input_data2
sed -i 's/three/3/g' "$SCRIPT_DIR"/input_data2
sed -i 's/two/2/g' "$SCRIPT_DIR"/input_data2
sed -i 's/one/1/g' "$SCRIPT_DIR"/input_data2

echo -n "" > "$SCRIPT_DIR"/output_data3
echo -n "" > "$SCRIPT_DIR"/output_data4

while IFS= read -r line; do
  #echo $line | sed 's/[^0-9]*//g' >> "$SCRIPT_DIR"/output_data3
  echo "${line//[^0-9]/}" >> "$SCRIPT_DIR"/output_data3
done < "$SCRIPT_DIR"/input_data2

while IFS= read -r line; do
  echo "${line:0:1}${line: -1}" >> "$SCRIPT_DIR"/output_data4
done < "$SCRIPT_DIR"/output_data3

SUM=0
while IFS= read -r line; do
  SUM=$((SUM+line))
done < "$SCRIPT_DIR"/output_data4
echo "SUM: "$SUM #52840

rm "$SCRIPT_DIR"/input_data2 "$SCRIPT_DIR"/output_data*

