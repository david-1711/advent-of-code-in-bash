#!/bin/bash

# https://adventofcode.com/2023/day/1

INPUT_DATA=$1

## part 1

echo -n "" > output_data1
echo -n "" > output_data2

while IFS= read -r line; do
  echo $line | sed 's/[^0-9]*//g' >> output_data1
done < $INPUT_DATA

while IFS= read -r line; do
  echo "${line:0:1}${line: -1}" >> output_data2
done < output_data1

SUM=0
while IFS= read -r line; do
  [[ -n $line ]] && SUM=$((SUM+$line))
done < output_data2
echo "SUM: "$SUM #53974

## part 2

cp $INPUT_DATA input_data2

sed -i 's/sevenine/79/g' input_data2
sed -i 's/nineight/98/g' input_data2
sed -i 's/fiveight/58/g' input_data2
sed -i 's/threeight/38/g' input_data2
sed -i 's/eighthree/83/g' input_data2
sed -i 's/eightwo/82/g' input_data2
sed -i 's/twone/21/g' input_data2
sed -i 's/oneight/18/g' input_data2

sed -i 's/nine/9/g' input_data2
sed -i 's/eight/8/g' input_data2
sed -i 's/seven/7/g' input_data2
sed -i 's/six/6/g' input_data2
sed -i 's/five/5/g' input_data2
sed -i 's/four/4/g' input_data2
sed -i 's/three/3/g' input_data2
sed -i 's/two/2/g' input_data2
sed -i 's/one/1/g' input_data2

echo -n "" > output_data3
echo -n "" > output_data4

while IFS= read -r line; do
  echo $line | sed 's/[^0-9]*//g' >> output_data3
done < input_data2

while IFS= read -r line; do
  echo "${line:0:1}${line: -1}" >> output_data4
done < output_data3

SUM=0
while IFS= read -r line; do
  SUM=$((SUM+$line))
done < output_data4
echo "SUM: "$SUM #52840

rm input_data2 output_data*

