require '../../utilities/utils.ijs'

input =: readlines 'input.txt'

collate =: [: +/ [: ,^:_ [: >^:_ ([: # each [: 'XMAS'&rxall each {)"2 each
orthogonals =: [: collate [: < [: (,: |."1) (,: |:"2)
diagonals =: [: collate [: < /."2 [: (,:|:)"2 (,:|.)

day04a =: orthogonals + diagonals

rx =: 'M.M.A.S.S|M.S.A.M.S|S.S.A.M.M|S.M.A.S.M'
day04b =: [: +/^:_ [: > (1 1 ,: 3 3) ([: rx&rxeq ,) ;._3 ]

echo 'Day 04:'
'  Part A: %d' printf day04a input
'  Part B: %d' printf day04b input

exit 0
