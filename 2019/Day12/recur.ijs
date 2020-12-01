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


xs =: {. p
x0s =: {. p0

echo 'start'
iterate =: 3 : 0
  v =: v + dv p
  p =: p + v

  xs =: {. p

  NB. echo 'p'
  NB. echo p
  NB. echo 'p0'
  NB. echo p0

  i =: i + 1
)

iterate 0

(iterate^:(xs ([: -. -:) x0s)^:_) 0
echo i

exit 0
