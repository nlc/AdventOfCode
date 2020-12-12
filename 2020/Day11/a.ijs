NB. Conway's Game of Life, for reference
cgol =: (]=3+4=*)[:+/^:2(,"0/~@i:1)&|.

NB. L.LL.LL.LL
NB. LLLLLLL.LL
NB. L.L.L..L..
NB. LLLL.LL.LL
NB. L.LL.LL.LL
NB. L.LLLLL.LL
NB. ..L.L.....
NB. LLLLLLLLLL
NB. L.LLLLLL.L
NB. L.LLLLL.LL
mask =: 10 10 $ 1 0 1 1 0 1 1 0 1 1 1 1 1 1 1 1 1 0 1 1 1 0 1 0 1 0 0 1 0 0 1 1 1 1 0 1 1 0 1 1 1 0 1 1 0 1 1 0 1 1 1 0 1 1 1 1 1 0 1 1 0 0 1 0 1 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 0 1 1 0 1 1 1 1 1 0 1 1

NB. Embed matrix in a "halo" of zeros
enhalodef =: (_1&|.)"1@(_1&|.)@((2:+$){.]) NB. probably very inelegant, applying that rotate twice explicitly

NB. Tragically my J-fu isn't quite strong enough atm to come up with an implicit def
unenhalodef =: monad define
  newdim =: _2+$y
  (1 1 ,: newdim) ];.0 y
)
enhalo =: enhalodef :. unenhalodef

state =: (([: $ ]) $ 0:) mask


NB. I think we need to
NB.   1. Mask the state with the mask
NB.   2. Calculate neighbors
NB.   3. Mask the state with the mask AGAIN
neighbors =: [:+/^:2(,"0/~@i:1)&|.

neighbors &.enhalo state
