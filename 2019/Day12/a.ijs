NB. Sample data
NB. p =: 3 4 $ _1 2 4 3 0 _10 _8 5 2 _7 8 _1
NB. v =: 3 4 $ 0

NB. Real data
NB. <x=-15, y=1, z=4>
NB. <x=1, y=-10, z=-8>
NB. <x=-5, y=4, z=9>
NB. <x=4, y=6, z=-2>

p =: 3 4 $ _15 1 _5 4 1 _10 4 6 4 _8 9 _2
v =: 3 4 $ 0

NB. Crude explicit form: p -> delta v
NB. - 1+ (+/"1) _1+2*>/~"1 p

NB. no-less-crude tacit form
NB.  dv =: [: - [: 1&+ [: +/"1 [: _1&+ [: 2&* >/~"1 NB. wrong

NB. "spaceship operator"
sd =: [: * -

NB. apparently correct form
dv =: [: - [: +/"1 sd"0/~"1

iterate =: 3 : 0
  v =: v + dv p
  p =: p + v

  NB. echo p
  NB. echo ''
  NB. echo v
  NB. echo ''
  NB. echo ''
)

(iterate^:1000) 0

U =: [: +/ |
T =: [: +/ |
E =: 4 : '(T x) * (U y)'

echo +/ v E p
