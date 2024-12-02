require '../../utilities/utils.ijs'

input =: ireadlines 'input.txt'

day09a =: {. ({~ 25+([: I. -.)@(25&}. ([ e. [: , +/~@])"0 1 ([: }: 25 ]\ ]))) input
day09b =: (<./+>./) input {~ (] (] + i.@(2&+)@i.) +/) day09a (e.*i.~)"0 1 (2 + i. 100) +/ \ input

echo 'Day 09:'
'  Part A: %d' printf day09a
'  Part B: %d' printf day09b

exit 0
