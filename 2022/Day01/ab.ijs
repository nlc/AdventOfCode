require 'format/printf'

input =: ". each '-' cut ('  ' ; '-') rxrplc (LF ; ' ') rxrplc fread 'input.txt' NB. ungodly hack

'day01a day01b' =: +/ |: 1 3 >@{."(0 1) |. sort +/ each input

echo 'Day 01:'
'  Part A: %d' printf day01a
'  Part B: %d' printf day01b

exit 1
