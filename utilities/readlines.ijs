readlines =: 3 : '".(>cutopen (1!:1) < y)'

run =: dyad def '(1 ,: x) ] ;._3 y'

NB. kind of sucks because no apparent way to avoid a newline
bold =: monad define
  echo a. {~ 0X1B 0X5B , (0X30 + y) , 0X6D
)
