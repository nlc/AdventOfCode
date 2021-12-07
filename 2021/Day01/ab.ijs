require '../../utilities/utils.ijs'

input =: ". readlines 'input.txt'

NB. Day 01 Part A solution
day01a =: +/@(}. > }:)

NB. Day 01 Part B solution
day01b =: [: day01a 3 +/\ ]

NB. Print answers
echo 'Day 01:'
'  Part A: %d' printf day01a input
'  Part B: %d' printf day01b input

exit 1
