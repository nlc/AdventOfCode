require 'format/printf'

input =: ". }: fread 'input.txt'

digits =: 10&#.^:_1

zero =: 0&=
NB. evendigits =: [:-.2|[:<.10^.]
evendigits =: [:-.2|#@digits

selectrule =: *@[ * 1 + 1 2 (+/ . *) zero@] , evendigits@]

fh =: ({.~-:@#)&.:digits NB. First Half
sh =: (}.~-:@#)&.:digits NB. Second Half

NB. Can probably be refactored to remove the many <:@[ s
blink =: (1:`(<:@[ $: 2024&*@])`(<:@[ $: 1:)`((<:@[ $: fh@]) + (<:@[ $: sh@])) @. selectrule) M.

echo 'Day 11:'
'  Part A: %d' printf +/ 25 blink"(0) input
'  Part B: %d' printf +/ 75 blink"(0) input

exit 0
