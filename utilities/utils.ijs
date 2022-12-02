require 'format/printf'

readlines =: 3 : '(>cutopen (1!:1) < y)'
ireadlines =: ".@readlines
readchars =: 3 : '>cutopen (1!:1) < y'
ireadchars =: ".@readchars
readwords =: cutopen@fread
readwords =: [: > (' ' , LF) cutopen [: fread ]
ireadwords =: ".@readwords
readtabular =: [: > [: cut each [: cutLF fread

NB. TODO: recognize numbers and parse
smartparse =: 3 : 0
  if. '^\s*\d+(\.\d*)?([Ee]\d*)?\s*$' rxin y do.
    ". y
  elseif. '^\s*0[Xx][0-9A-Fa-f]+\s*$' rxin y do.
    ". toupper y
  else.
    y
  end.
)
smartreadtabular =: [: > [: smartparse each each [: cut each [: cutLF fread

NB. I guess this feels like there should be a more atomic way to do this?
enumize =: [: +/ [: (i.@# * ]) [: = ]

inputfile =: 'input.txt'

run =: dyad def '(1 ,: x) ] ;._3 y'

ascii =: a. i. ]
ord =: 97 -~ ascii
chr =: ord^:_1

NB. kind of sucks because no apparent way to avoid a newline
bold =: monad define
  echo a. {~ 0X1B 0X5B , (0X30 + y) , 0X6D
)


Note 'obsolete'
  flip2d=:|."1@|.
  edge2d =: ([:>:$){.]
  enhalo2ddef =: edge2d@flip2d^:2
  unenhalo2ddef =: monad define
    newdim =: _2+$y
    (1 1 ,: newdim) ];.0 y
  NB. haha parsing )
  enhalo2d =: enhalo2ddef :. unenhalo2ddef
)

rimfwd =: (0&$: :(4 : '_1 _1 |. (2&+@$y) ({.!.x) y'))"2
NB. riminv =: _2&+@$ {. 1 1 |. ] NB. breaks when given a left arg
riminv =: (0&$: :(4 : '(_2&+@$ {. 1 1 |. ])y'))"2
rim =: rimfwd :. riminv

NB. https://code.jsoftware.com/wiki/Essays/Odometer
odometer=: #: i.@(*/)

histogram =: <:@(#/.~)@(i.@#@[ , I.) NB. https://code.jsoftware.com/wiki/Essays/Histogram
