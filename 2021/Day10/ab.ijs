require '../../utilities/utils.ijs'

sample =: cutLF fread 'sample.txt'
input =: cutLF fread 'input.txt'

process =: 3 57 1197 25137 0 { ~ [: {.!.4 [: (4&~: # ]) ')]}>' i. ((<;._1 ' \(\)|\[\]|\{\}|<> ') rxrplc ])^:_

incompletes =: #~ [: > [:(0 = [:#[: (4&~: # ]) ')]}>' i. ((<;._1 ' \(\)|\[\]|\{\}|<> ') rxrplc ])^:_) each ]

NB. Day 10 Part A solution
day10a =: [: +/ [: > process each


NB. Day 10 Part A solution
day10b =: _. [ ] NB. PLACEHOLDER

NB. NB. Print answers
NB. echo 'Day 10:'
NB. '  Part A: %d' printf day10a input
NB. '  Part B: %d' printf day10b input
NB. 
NB. exit 1
