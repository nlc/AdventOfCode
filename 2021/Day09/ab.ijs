require '../../utilities/utils.ijs'

sample =: "."0 readlines 'sample.txt'
input =: "."0 readlines 'input.txt'

[:>:*/@(<"2(((,-)@(,:|.)0 1)&|.)&.:(_&rim))#&,]
day09a =: [:+/[:>:*/@(<"2(((,-)@(,:|.)0 1)&|.)&.:(_&rim))#&,]
