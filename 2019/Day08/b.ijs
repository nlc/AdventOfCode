require '../utilities/readlines.ijs'

(9!:37)0 _ _ _

lines =: readlines 'input_cheating.txt'

data =: 100 6 25 $,lines

NB. never really used axis rearrangement before, useful.
pattern =: (((2&~: i. 1:){])"1) 0&|: data

echo pattern { u: 16b20 16b2588

exit 0
