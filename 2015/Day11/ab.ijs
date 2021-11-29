require 'format/printf'

atoi =: 97 -~ a. i. ]

NB. Input data
input =: 'hxbxwxba'

straightrx =: '|' joinstring (a. {~ ]) each 3 <\ 97 + i. 26
req1 =: straightrx rxin ]
req2 =: [: -. '[iol]' rxin ]
req3 =: 2 <: [: # [: = '(.)\1' rxall ]
reqs =: (req1 AND req2 AND req3)

increment =: (>: &.: (26&#.))&.: atoi

NB. Day 11 Part A solution
day11a =: increment^:(-.@reqs ])^:_

NB. Day 11 Part B solution
day11b =: [: day11a [: increment day11a

NB. Print answers
echo 'Day 11:'
'  Part A: %s' printf < day11a input
'  Part B: %s' printf < day11b input

exit 1
