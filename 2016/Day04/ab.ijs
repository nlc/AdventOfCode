require 'format/printf'

getname =: ('-' ; '') rxrplc 0 pick  ('^[a-z-]+-')&rxmatch rxfrom ]
getscid =: [: ". 0 pick  ('\d+')&rxmatch rxfrom ]
getcsum =: ('[\[\]]' ; '') rxrplc 0 pick  ('\[.*\]')&rxmatch rxfrom ]

name5mc =: (5 {. ] {~ [: \: [:+/="0/) sort@~. NB. 5 most common letters in name in order

validrooms =: (#~[: > (getcsum -: name5mc@getname)each) cutopen fread 'input.txt'

day04a =: +/ > getscid each validrooms

day04b =: ([: getscid@> ] #~ [: > [: (('north' rxin ]) a. {~ 97 + 26 | getscid + 97 -~ a. i. getname) each ]) validrooms

echo 'Day 04:'
'  Part A: %d' printf day04a
'  Part B: %d' printf day04b

exit 1
