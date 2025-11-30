require 'format/printf'
input =: > "."0 each cutopen fread 'input.txt'

vs =: 9 2($,) ,"0/~ i: 1

NB. Not quite the elegant tacit def that I wanted,
NB. but a reasonably satisfying and extensible solution.
iter =: 3 : 0
  'i s g' =. y NB. Iteration, Sum, Grid

  g =. g + 1

  f =. g > 9 NB. Flash
  r =. f NB. Refractory

  while. (+/^:_ f) > 0 do.
    g =. (-. r) * g + +/ vs |.!.0"(1 2) f
    f =. g > 9
    r =. r OR f
  end.

  (i + 1) ; (s + +/^:_ r) ; g
)

day11a =: 3 : 0
  1 pick iter^:(100) 0 ; 0 ; y
)

day11b =: 3 : 0
  0 pick iter^:(0 < [: +/^:(2) 2 pick ])^:_ (0 ; 0 ; y)
)

NB. Print answers
echo 'Day 11:'
'  Part A: %d' printf day11a input
'  Part B: %d' printf day11b input
exit 1
