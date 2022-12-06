require 'format/printf'

input =: fread 'input.txt'

firstnonrepeat =: [:{.@I.(#@~.=#)\

day06a =: 4 firstnonrepeat ]
day06b =: 14 firstnonrepeat ]

echo 'Day 06:'
'  Part A: %d' printf day06a input
'  Part B: %d' printf day06b input

exit 1
