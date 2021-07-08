require 'format/printf'

input =: (1!:1) < 'input.txt'

NB. Map characters to movements
mc =: '>^<v' NB. movement characters
mv =: 4 2 $ 1 0 0 1 _1 0 0 _1 NB. movement vectors

NB. Day 03 Part A solution
day03a =: [:>:@{.@$@=[:+/\mv{~mc&i. NB. Have to >: for starting square

NB. Day 03 Part A solution
NB. Here we had to add an explicit first 0 0 location
day03b =: [:{.@$@=@,/[:([:+/\0 0,mv{~mc&i.)"1[:|:(2,~2%~$)$]

NB. Print answers
echo 'Day 03:'
'  Part A: %d' printf day03a input
'  Part B: %d' printf day03b input

exit 1
