require 'format/printf'

input =: ". each cutLF fread 'input.txt'

day02a =: [: +/ [: > (>./ - <./) each
day02b =: [: +/ [: > ([: (#~ 0&=@(1&|) AND 1&~:) [: , %/~) each

NB. Print answers
echo 'Day 02:'
'  Part A: %d' printf day02a input
'  Part B: %d' printf day02b input

exit 1
