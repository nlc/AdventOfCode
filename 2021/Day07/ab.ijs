require '../../utilities/utils.ijs'

input =: ". > ',' cutopen fread 'input.txt'

NB. Day 07 Part A solution
day07a =: [: x: [: <./ [: +/ [: | ] -/~~ [: i. >./

NB. Day 07 Part B solution
day07b =: [: x: [: <./ [: +/ [: -: [: (* >:) [: | ] -/~~ [: i. >./

NB. Print answers
echo 'Day 07:'
'  Part A: %d' printf day07a input
'  Part B: %d' printf day07b input

exit 1
