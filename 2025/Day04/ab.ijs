require '../../utilities/utils.ijs'

input =: > '.@'&i. each cutLF fread 'input.txt'

amask =: (* 4 > (1 1 ,: 3 3) (1 1 1 1 0 1 1 1 1 +/ . * ,);._3 rim) NB. Accessible MASK

day04a =: [: +/^:_ amask
day04b =: +/^:_ - [: +/^:_ (* -.@amask)^:_

echo 'Day 04:'
'  Part A: %d' printf day04a input
'  Part B: %d' printf day04b input

exit 1
