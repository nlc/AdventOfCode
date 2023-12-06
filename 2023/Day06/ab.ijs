require 'format/printf'

NB. Number of Ways the race can be won
nw =: [: +/ ] < [: (*|.)@i. 1+[

day06a =: [: */ nw"0/
day06b =: nw/

contents =: cutopen fread 'input.txt'
inputa =: > ".@(('[^\d ]';'') rxrplc ]) each contents
inputb =: > ".@(('[^\d]';'') rxrplc ]) each contents

echo 'Day 06:'
'  Part A: %d' printf day06a inputa
'  Part B: %d' printf day06b inputb
exit 1
