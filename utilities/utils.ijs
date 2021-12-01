NB. TODO: Rename this file. It's not just readlines anymore

readlines =: 3 : '(>cutopen (1!:1) < y)'
readchars =: 3 : '>cutopen (1!:1) < y'
readwords =: cutopen@fread

run =: dyad def '(1 ,: x) ] ;._3 y'

NB. kind of sucks because no apparent way to avoid a newline
bold =: monad define
  echo a. {~ 0X1B 0X5B , (0X30 + y) , 0X6D
)

flip2d=:|."1@|.
edge2d =: ([:>:$){.]
enhalo2ddef =: edge2d@flip2d^:2
unenhalo2ddef =: monad define
  newdim =: _2+$y
  (1 1 ,: newdim) ];.0 y
)
enhalo2d =: enhalo2ddef :. unenhalo2ddef

NB. https://code.jsoftware.com/wiki/Essays/Odometer
odometer=: #: i.@(*/)
