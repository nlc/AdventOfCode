require 'format/printf'

NB. Number of Ways the race can be won--brute-force approach
nwbf =: [: +/ ] < [: (*|.)@i. 1+[

Note 'Equation'
  Given positive integers a and b, find the *number* of positive integer values of x for which
    a < x * (b - x); i.e.
    a < -x^2 + bx; i.e.
    0 < -x^2 + bx - a

    The equation is quadratic and strictly convex (f''(x) < 1). Identify the zeros with the
    quadratic formula, then calculate how many integers lie strictly within those endpoints.
)

NB. Calculate directly
nweq =: 1 -~ [: (>.@{. - <.@{:) [: + 1 pick [: p. ([: - ]) , _1 ,~ [

day06a =: [: */ nweq"0/
day06b =: nweq/

contents =: cutopen fread 'input.txt'
inputa =: > ".@(('[^\d ]';'') rxrplc ]) each contents
inputb =: > ".@(('[^\d]';'') rxrplc ]) each contents

echo 'Day 06:'
'  Part A: %d' printf day06a inputa
'  Part B: %d' printf day06b inputb
exit 1
