require 'format/printf'

NB. Input data
input =: (1!:1) < 'input.txt'

NB. Day 01 Part A solution
NB. day01a =: [: (+:@(+/)-#) ')(' i. ]
day01a =: +/@(_1 2 p.')('i.])

NB. Day 01 Part B solution
day01b =: [: >:_1 i.~ (+/\@(_1 2 p.')('i.]))

NB. Print answers
echo 'Day 01:'
'  Part A: %d' printf day01a input
'  Part B: %d' printf day01b input

exit 1
