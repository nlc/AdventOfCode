require 'format/printf'

input =: "."0('\D';'') rxrplc fread 'input.txt'

day01a =: +/@#~ ] = 1&|.
day01b =: +/@#~ ] = -:@# |. ]

NB. Print answers
echo 'Day 01:'
'  Part A: %d' printf day01a input
'  Part B: %d' printf day01b input

exit 1
