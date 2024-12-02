require 'format/printf'

input =: ". each cutopen fread 'input.txt'

safe =: [: +/ [: */"1 [: +/"2 (2 3 $ _1 _2 _3 1 2 3) e.~"(0 1) (2 -/ \ ])
ko =: #~[:~:/~i.@# NB. list of versions of y with one element knocked out

day02a =: [: +/ [: > safe each
day02b =: [: +/ [: > ([: +./ safe"1@ko) each

echo 'Day 02:'
'  Part A: %d' printf day02a input
'  Part B: %d' printf day02b input

exit 0
