require '../../utilities/utils.ijs'

input =: ". > ',' cut fread 'input.txt'
tallies =: (i. 9) histogram input

iterate =: ({.,~8{.(9({.)1(|.)7{.])+(3(|.)9({.)_2{.]))

NB. Day 06 Part A solution
day06a =: +/@(iterate^:80)

NB. Day 06 Part B solution
day06b =: +/@(iterate^:256)

NB. Print answers
echo 'Day 06:'
'  Part A: %d' printf day06a tallies
'  Part B: %d' printf day06b tallies

NB. exit 1
