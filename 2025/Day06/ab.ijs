require 'format/printf'

'ns os' =: (4&{. ; {:) cut each cutLF fread 'input.txt'
ns =: |: > ". each > ns
os =: , > os

day06a =: +/ os ((+/@])`(*/@])@.('*'&=@[))"0 1 ns
day06b =: +/ (|. os) ((+/@>@])`(*/@>@])@.('*'&=@[))"(0 0) 0 cut "."(1) 4 {."1 |.|: > cutLF fread 'input.txt'

echo 'Day 06:'
'  Part A: %d' printf < day06a
'  Part B: %d' printf < day06b
exit 1
