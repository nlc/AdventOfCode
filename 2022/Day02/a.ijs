require '../../utilities/utils.ijs'

input =: cutLF fread 'input.txt'
day01a =: [: +/ (1+152686 A.i.9) { ~ ] i.~ [: sort ~.

echo 'Day 01:'
'  Part A: %d' printf day01a input

exit 1
