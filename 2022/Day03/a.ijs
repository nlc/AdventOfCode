require 'format/printf'

input =: cutLF fread 'input.txt'
day03a =: [:+/[:>(1+(,a.{~97 65+"0 1 i.26)i.])@((-:@#({.({.@I.@e.)}.)]){])&.>

echo 'Day 03:'
'  Part A: %d' printf day03a input

exit 1
