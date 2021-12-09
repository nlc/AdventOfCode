require '../../utilities/utils.ijs'

input =: ([: cut ('\| ' ; '') rxrplc ]) each cutopen fread inputfile
ref =: sort@ord each refstrs =: ' ' cut 'abcefg cf acdeg acdfg bcdf abdfg abdefg acf abcdefg abcdfg'

bruteforce =: 4 : '(ord y) { (x A. i. 7)'"0 1
solve =: 200 14 ($,) [: > ([: ref&i.@(#~ AND/"1@(ref e."1~ ])) [: |: [: > [: { each [: sort"1&.> (i.!7)&bruteforce each) each

solved =: _4 {."1 solve input

NB. Day 08 Part A solution
day08a =: [: +/ 1 4 7 8 e."0 1~ ,

NB. Day 08 Part A solution
day08b =: [: +/ 10 #:^:(_1) ]

NB. Print answers
echo 'Day 08:'
'  Part A: %d' printf day08a solved
'  Part B: %d' printf day08b solved

exit 0
