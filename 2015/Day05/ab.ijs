require 'format/printf'

NB. Input data
input =: > cutopen (1!:1) < 'input.txt'

NB. Day 04 Part A solution
cc =: +/@e.~ NB. Count occurrences of any Chars of x in y
hp =: +./@(}.=}:) NB. Has Pair
hs =: [:+./[E.] NB. Has Substring
r1 =: 3 <: 'aeiou'&cc NB. Rule 1
r2 =: hp NB. Rule 2
r3 =: [: -. [: +./ (4 2 $ 'abcdpqxy') hs"1 ] NB. Rule 3
na =: r1 *. r2 *. r3 NB. Naughty or Nice, part A
day05a =: [: +/ na"1
NB. [:+/((3<:'aeiou'&(+/@e.~))*.+./@(}.=}:)*.[:-.[:+./(4 2$'abcdpqxy')([:+./[E.])"1])"1

NB. Day 05 Part B solution
r4 =: +./@(2&}. = _2&}.) NB. Rule 4
dm =: 1 (i. |@- i:)~ E. NB. Distance from first to last Match
NB. (i.@# |."(0 1) ]) 'abacab' NB. rotate and compare pairs somehow?
tp =: (1<dm)"1 NB. try each pair
r5 =: [: +./ ([: ~. 2 ]\ ]) tp ]
nb =: r4"1 *. r5"1 NB. Naughty or Nice, part B
day05b =: [: +/ nb

NB. Print answers
echo 'Day 05:'
'  Part A: %d' printf day05a input
'  Part B: %d' printf day05b input

NB. exit 1
