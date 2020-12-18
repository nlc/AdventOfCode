require '../../utilities/readlines.ijs'

NB. Highly useful odometer function from https://code.jsoftware.com/wiki/Essays/Odometer
odometer =: #: i.@(*/)

NB. Generate array of neighbor vectors using the odometer function
odoadj =: [: <: [: odometer 3 #~ ]

NB. Define CGoL in N dimensions
lifend =: 4 : '((] = 3 + 4 = *) [: +/ (odoadj x) & |.) y'

life2d =: 2 & lifend
life3d =: 3 & lifend
life4d =: 4 & lifend

NB. state2d =: _7 _7 {. 5 5 {. 3 3 ($,) '.#' i. readchars 'sample.txt'
NB. state3d =: _7 _7 _7 {. 4 5 5 {. 1 3 3 ($,) '.#' i. readchars 'sample.txt'
NB. state4d =: _7 _7 _7 _7 {. 4 4 5 5 {. 1 1 3 3 ($,) '.#' i. readchars 'sample.txt'

state2d =: _24 _24 {. 16 16 {. 8 8 ($,) '.#' i. readchars 'input.txt'
state3d =: _21 _24 _24 {. 11 16 16 {. 1 8 8 ($,) '.#' i. readchars 'input.txt'
state4d =: _21 _21 _24 _24 {. 11 11 16 16 {. 1 1 8 8 ($,) '.#' i. readchars 'input.txt'

echo +/^:_ life3d^:6 state3d
echo +/^:_ life4d^:6 state4d

exit 0
