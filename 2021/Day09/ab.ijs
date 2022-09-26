require '../../utilities/utils.ijs'

sample =: "."0 readlines 'sample.txt'
input =: "."0 readlines 'input.txt'

[:>:*/@(<"2(((,-)@(,:|.)0 1)&|.)&.:(_&rim))#&,]
day09a =: [:+/[:>:*/@(<"2(((,-)@(,:|.)0 1)&|.)&.:(_&rim))#&,]

NB. redo
ismin =: (8 = [: +/^:2 ] <"2 (,"0/~i:1) |."1 2 ])&.:(_&rim)
day09aV2 =: [: +/^:2 [: (* ismin) 1 + ]
