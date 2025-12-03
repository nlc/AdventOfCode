require 'format/printf'

input =: |: >cutLF fread 'input.txt'

day06a =: ([:{.~.{~[:\:[:+/~.=/~])"1
day06b =: ([:{:~.{~[:\:[:+/~.=/~])"1

echo 'Day 06:'
'  Part A: %s' printf < day06a input
'  Part B: %s' printf < day06b input

exit 1
