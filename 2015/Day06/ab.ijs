require 'format/printf'

cmds =: 'off' ; 'on' ; 'toggle'
input =: (((cmds i. _8 { ]) ; ([: ". [: > _7 _5 _3 _1 { ])) [: ;: ])"1 cutopen@(1!:1)&.< 'input.txt'
opsa =: >`+.`~:@. NB. OPerationS for part A
opsb =: (0>.-)`+`(+[:>:])@. NB. OPerationS for part B

Note 'Strategy'
Create a new matrix of 1s in the relevant area surrounded by 0s
and choose the relevant operator:
  off -> ANDNOT (>)
  on -> OR (+.)
  toggle -> XOR (~:)
)

s =: 1000 1000 NB. Size
gg =: 1 : '(-x) |. m {. y $ 1' NB. Generate mask Generator
gm =: s gg NB. Generate Mask

mc =: 2&{. ([ gm >:@-@-) _2&{. NB. Mask from Coordinates

NB. s =: 20 20 NB. Size
NB. fakeinputraw =: 'toggle 0,1 through 2,5' ; 'turn on 0,7 through 15,8' ; 'toggle 14,0 through 14,19'
NB. fakeinput =: (((cmds i. _8 { ]) ; ([: ". [: > _7 _5 _3 _1 { ])) [: ;: ])"1 > fakeinputraw
NB. echo fakeinput

ia =: 3 : 0 NB. Iterate for part A
  op =. (> {. y) opsa
  bm =. mc > {: y NB. BitMask
  bf =: bf op bm
  '' NB. Hacky
)

ib =: 3 : 0 NB. Iterate for part B
  op =. (> {. y) opsb
  bm =. mc > {: y NB. BitMask
  bf =: bf op bm
  echo bf
  '' NB. Hacky
)

day06a =: 3 : 0
  bf =: s $ 0 NB. Binary Field
  ia"1 input
  +/^:_ bf
)

day06b =: 3 : 0
  bf =: s $ 0 NB. Binary Field
  ib"1 input
  +/^:_ bf
)

NB. Print answers
echo 'Day 06:'
'  Part A: %d' printf day06a input
'  Part B: %d' printf day06b input

exit 1
