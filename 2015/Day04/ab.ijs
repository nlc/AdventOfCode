require 'format/printf'

input =: 'bgvyzdsv'

NB. Define md5 helper function.
NB. Easier than typing the entire foreign.
md5 =: 15&(128!:6)

firstmd5 =: 1 : '1 i.~ m -:"(1) (# m) {."1 > ([: md5 x&,)@": each <"(0) y'

NB. Day 04 Part A solution
day04a =: '00000' firstmd5

NB. Day 04 Part B solution
day04b =: '000000' firstmd5

NB. Print answers
echo 'Day 04:'
'  Part A: %d' printf input day04a i. 1000000
'  Part B: %d' printf input day04b i. 1100000

exit 1
