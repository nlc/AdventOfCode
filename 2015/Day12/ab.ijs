require 'format/printf'

NB. Input data
input =: fread 'input.txt'

NB. Day 12 Part A solution
day12a =: [: +/ [: ". [: > '[-0-9]+' rxall ]

NB. Day 12 Part B solution
day12b =: 0:

NB. Print answers
echo 'Day 01:'
'  Part A: %d' printf day12a input
'  Part B: %d' printf day12b input

exit 1
