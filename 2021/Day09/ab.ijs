require '../../utilities/utils.ijs'

sample =: "."0 readlines 'sample.txt'
input =: "."0 readlines 'input.txt'

NB. Day 09 Part A solution
day09a =: [:+/[:>:*/@(<"2(((,-)@(,:|.)0 1)&|.)&.:(_&rim))#&,]

NB. redo
ismin =: (8 = [: +/^:2 ] <"2 (,"0/~i:1) |."1 2 ])&.:(_&rim)
day09aV2 =: [: +/^:2 [: (* ismin) 1 + ]

NB. assign unique numbers instead of a binary mask
indicate =: * 1&+@i.@$

NB. morphological dilation, keeping values. because it uses OR,
NB. gives ambiguous results when sections overlap. fortunately
NB. for us, sections are guaranteed to be separated by walls.
dilate =: [:OR/(0,(,-)@(,:|.)0 1)&|.&.:(0&rim)

NB. apply "dilation", avoiding walls, until stable.
explore =: 3 : '((9~:y) * dilate)^:_ indicate ismin y'

NB. separate out all "basins" very nicely with (="2 0(*#])@~.@,) explore sample

NB. Day 09 Part B solution
day09b =: [: */ _3 {. [: sort [: +/^:_"2 (="2 0 (* # ])@~.@,)@explore

NB. Print answers
echo 'Day 09:'
'  Part A: %d' printf day09aV2 input
'  Part B: %d' printf day09b input

exit 0
