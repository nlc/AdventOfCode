require 'format/printf'

NB. Input data
input =: > cutopen (1!:1) < 'input.txt'

NB. Day 04 Part A solution
cc =: +/@e.~ NB. Count occurrences of any Chars of x in y
hp =: +./@(}.=}:) NB. Has Pair
hs =: [:+./[E.] NB. Has Substring
r1 =: 3 <: 'aeiou'&cc NB. Rule 1
r2 =: hp NB. Rule 2
r3 =: [: +./ (4 2 $ 'abcdpqxy') hs"1 ] NB. Rule 3
nn =: r1 *. r2 *. [: -. r3 NB. Naughty or Nice
day04a =: [: +/ nn"1
NB. [:+/((3<:'aeiou'&(+/@e.~))*.+./@(}.=}:)*.[:-.[:+./(4 2$'abcdpqxy')([:+./[E.])"1])"1

NB. Day 04 Part B solution
day04b =: 0:

NB. Print answers
echo 'Day 04:'
'  Part A: %d' printf day04a input
'  Part B: %d' printf day04b input

NB. exit 1
