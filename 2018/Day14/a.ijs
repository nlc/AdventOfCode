require 'plot'

dg =: (10#.^:_1]) :. (10#:^:_1])
input =: 864801

ex1 =: 0 1 ; 3 7
ex2 =: 0 6 ; 3 7 1 0 1 0 1 2 NB. => 4 8 ; 3 7 1 0 1 0 1 2 4

stupid =: 3 : 0
  'is ns' =. y
  qs =. is { ns
  ns2 =. ns , dg +/ qs
  is2 =. (#ns2) | 1 + is + qs

  is2 ; ns2
)

board =: ex1

run1 =: stupid^:300000 board
echo $ 1 pick run1
exit 1
echo run1
NB. echo dg^:(_1) 10 {. (# 1 pick inp) }. 1 pick run1
echo dg^:(_1) 10 {. (input) }. 1 pick run1

NB. echo stupid^:(i. 11) inp

exit 1
