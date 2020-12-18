NB. Embed matrix in a "halo" of zeros
NB. enhalodef =: (_1&|.)"1@(_1&|.)@((2:+$){.]) NB. probably very inelegant, applying that rotate twice explicitly
flip=:|."1@|.
edge =: ([:>:$){.]
enhalodef =: edge@flip^:2

NB. Tragically my J-fu isn't quite strong enough atm to come up with a tacit def
unenhalodef =: monad define
  newdim =: _2+$y
  (1 1 ,: newdim) ];.0 y
)
enhalo =: enhalodef :. unenhalodef

tacit =: 13 define
  newdim =: _2+$y
  (1 1 ,: newdim) ];.0 y
)

neighbors =: [:+/^:2(,"0/~@i:1)&|.
combine =: dyad def '(x *. (y < 5)) +. ((-. x) *. (y = 0))'
rule =: combine neighbors&.enhalo
mrule =: dyad def 'x * rule x * y' NB. mask then rule then mask


mask =: '.L' i. > cutopen 1!:1 < 'input.txt'
state =: (([: $ ]) $ 0:) mask

echo +/^:_ (mask mrule^:1:^:_ state)
exit 1
