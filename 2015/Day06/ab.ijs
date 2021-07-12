cmds =: 'off' ; 'on' ; 'toggle'
input =: (((cmds i. _8 { ]) ; ([: ". [: > _7 _5 _3 _1 { ])) [: ;: ])"1 cutopen@(1!:1)&.< 'input.txt'
ops =: >`+.`~:@.

Note 'Strategy'
Create a new matrix of 1s in the relevant area surrounded by 0s
and choose the relevant operator:
  off -> ANDNOT (>)
  on -> OR (+.)
  toggle -> XOR (~:)
)

s =: 1000 1000 NB. Size
s =: 20 20 NB. Size
gg =: 1 : '(-x) |. m {. y $ 1' NB. Generate mask Generator
gm =: s gg NB. Generate Mask

bf =: s $ 0 NB. Binary Field

mc =: 2&{. ([ gm >:@-@-) _2&{. NB. Mask from Coordinates

fakeinputraw =: 'toggle 0,1 through 2,5' ; 'turn on 0,7 through 15,8' ; 'ttoggle 14,0 through 14,19'
fakeinput =: (((cmds i. _8 { ]) ; ([: ". [: > _7 _5 _3 _1 { ])) [: ;: ])"1 > fakeinputraw

echo fakeinput

iter =: 3 : 0
  op =: (> {. {. y) ops
  echo 1 op 1
  bf =: bf (1 ops) (mc 2 3 8 5)
)

iter fakeinput

NB. exit 1
