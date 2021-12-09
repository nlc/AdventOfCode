require '../../utilities/utils.ijs'

ref =: sort@ord each refstrs =: ' ' cut 'abcefg cf acdeg acdfg bcdf abdfg abdefg acf abcdefg abcdfg'

Note 'thoughts'
  First of all, #104, absolutely brutal.

  Should probably sort each cell, order shouldn't matter, it's just a bag of indices

  The two broad approaches I can think of rn are
    1) Build up intelligently from digits of known length
    2) Brute-force swap everything around until it works
)

test =: sort@ord each teststrs =: cut ('\| ' ; '') rxrplc 'agfeb dgafb agfecb gfcaed abegc febc ef fea ebfcdga bedagc | ebcadg eaf bafge gcaeb'

bruteforce =: 4 : '(ord y) { (x A. i. 7)'"0 1
(i.!7) bruteforce 'acef'
NB. AND/ (sort key encode strs) e."0 1 refstrs

ref&i.@(#~ AND/"1@(ref e."1~ ]) ) |: > { each (sort"1) each (i. !7)&bruteforce each teststrs

try =: 3 : 'ref&i.@(#~ AND/"1@(ref e."1~ ]) ) |: > { each (sort"1) each (i. !7)&bruteforce each y'

input =: ([: cut ('\| ' ; '') rxrplc ]) each cutopen fread inputfile

NB. res =: try each input

solve =: 200 14 ($,) [: > ([: ref&i.@(#~ AND/"1@(ref e."1~ ])) [: |: [: > [: { each [: sort"1&.> (i.!7)&bruteforce each) each
solved =: _4 {."1 solve input

day08a =: [: +/ 1 4 7 8 e."0 1~ ,
day08b =: [: +/ 10 #:^:(_1) ]

echo day08a solved
echo day08b solved
