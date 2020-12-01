p =: 3 4 $ _15 1 _5 4 1 _10 4 6 4 _8 9 _2
p0 =: p
v =: 3 4 $ 0
NB. "spaceship operator"
sd =: [: * -

NB. apparently correct form
dv =: [: - [: +/"1 sd"0/~"1

U =: [: +/ |
T =: [: +/ |
E =: 4 : '(T x) * (U y)'

i =: 0

iterate =: 3 : 0
  v =: v + dv p
  p =: p + v

  echo 'p'
  echo |: p
  echo ''
  echo 'v'
  echo |: v
  echo ''
)

(iterate^:1000000) 0

exit 0
