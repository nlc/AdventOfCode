require 'format/printf'

input =: > ([: > [: ". each '-?\d+' rxall ]) each cutLF fread 'input.txt'

histogram =: <:@(#/.~)@(i.@#@[ , I.) NB. https://code.jsoftware.com/wiki/Essays/Histogram

day14a =: */(sort@~.histogram]) #.-:1+(#~[:0&~:*/"1) 2 (<: - >:) (100 102) %"1 (101 103 | 2&{. + 2&}.)"(1) 1 1 100 100 *"1 input


'ls vs' =: (2&{."1 ; 2&}."1)  input
(i. 10) */ vs

echo 'Day 14:'
'  Part A: %d' printf day14a

NB. exit 0
