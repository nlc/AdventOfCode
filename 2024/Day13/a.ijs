NB. Done on Dec. 17--You came through again, Ken, happy birthday <3
require 'format/printf'

input =: >> ([: ". each [: '\d+'&rxall ]) each '|' cut ((LF , LF) ; '|') rxrplc fread 'input.txt'

NB. Simple change of basis: v' = A^_1 v
solve =: [: +/ 3 1 (+/ . *)"1 [: (#~ [: -.[: * [: +/ 1|])"1 (([: %.@|: 2 2 $ 4&{.) +/ . * (4&}.))"1

echo 'Day 13:'
'  Part A: %d' printf solve input
'  Part B: %d' printf solve 0 0 0 0 10000000000000x 10000000000000x +"1 input

exit 0
