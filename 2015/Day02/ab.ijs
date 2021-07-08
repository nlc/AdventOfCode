require 'format/printf'

NB. Input data
input =: ((3,~3%~$)$]) > ". each (LF , 'x') cutopen (1!:1) < 'input.txt'

NB. Day 02 Part A solution
day02a =: ([: +/ ([: (<./ + [: +: +/) 1 2 5 { [: , */~)"1)

NB. Day 02 Part B solution
day02b =: [: +/ (+:@+/@}:@sort + */)"1

NB. Print answers
echo 'Day 02:'
'  Part A: %d' printf day02a input
'  Part B: %d' printf day02b input

exit 1
