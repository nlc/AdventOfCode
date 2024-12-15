Note 'Inputs'
  Input: 572556 22 0 528 4679021 1 10725 2790
  Sample: 125 17
)

input =: ". }: fread 'input.txt'
sample =: 0 1 10 99 999

digits =: 10&#.^:_1

one =: 1:
halve =: ($~2,-:@#)&.:digits
mult =: 2024&*

rules =: mult`one`halve

zero =: 0&=
NB. evendigits =: [:-.2|[:<.10^.]
evendigits =: [:-.2|#@digits

ruleindex =: (1 2 +/ . * zero,evendigits)"0

NB. ((mult`one`halve) @. ruleindex) each ;/ input

rule =: ((mult`one`halve) @. ruleindex) M.

blink =: ([: > [: ,"1 each/ [: rule each ;/)
