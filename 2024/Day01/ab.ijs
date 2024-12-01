require '../../utilities/utils.ijs'

input =: |: ireadlines 'input.txt'

day01a =: [:+/[:|@-/sort"1
day01b =: [:+/^:_([*e.~)"0 1/

echo 'Day 01:'
'  Part A: %d' printf day01a input
'  Part B: %d' printf day01b input

exit 0
