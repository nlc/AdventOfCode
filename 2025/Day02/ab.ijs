Note 'Part A'
  Invalid IDs have to be an even number of digits.
  Find all possible "first halves" in range.
  First n/2 digits of n-digit number, where n is even.

  For 71-103:
    Only 71-99 are even-digited.
)

NB. Load
sample =: x: > ([: ".@> '-'&cut) each ',' cut (LF ; '') rxrplc fread 'sample.txt'
input =: x: > ([: ".@> '-'&cut) each ',' cut (LF ; '') rxrplc fread 'input.txt'

odd =: 2x&|

nd =: 1x + [: <. 10x&^. NB. Number of Digits
ndo =: odd@nd NB. Number of Digits is Odd

mn =: 1x +10x^-: NB. Magic Number for given # of digits (i.e. 1001 for 6 digits)

pd =: 1x -~ 10x ^ 1x -~ nd NB. Push Down to nearest num-digits boundary
pu =: 10x ^ nd NB. Push Up to nearest num-digits boundary

NB. temp proof of concept
(1 + <.@{: - >.@{.) (%&101) 5063 7100 NB. --> 20

Note 'Brittleness'
  The algorithm assumes the start and end numbers differ in #digits
  by at most 1!!! This will break hard if the data is changed.
)

tr =: ((pu^:ndo)"(0)@{."1 ,"0 (pd^:ndo)"(0)@{:"1) NB. Truncate Ranges
ci =: [: (#~ <:/"1) tr NB. Condition Input--truncate and remove where lf edge > rt edge

NB. echo mn@nd (#~ <:/"1) tr input

NB. nmir =: [: (1 + <.@{: - >.@{.)"1 [: (% mn@nd@{."1) ([: (#~ <:/"1) tr) NB. Num Matches In Range
nmir =: [: (1 + <.@{: - >.@{.)"1 (% mn@nd@{."1) NB. Num Matches In Range

fmir =: (] (]*>.@%) mn@nd)@{."1 NB. First Match In Range
lmir =: (] (]*<.@%) mn@nd)@{:"1 NB. Last Match In Range

echo +/ ([: -: [: +/ nmir * fmir ,"0 lmir)"1 ci input


Note 'Table of Diagnostic Divisors'
  Lacked the mental energy to figure out how to generate it.
  At least it looks neat.

          _.        _.      _.    _.     _.
          _.        _.      _.    _.     _.
          11        _.      _.    _.     _.
         111        _.      _.    _.     _.
        1111       101      _.    _.     _.
       11111        _.      _.    _.     _.
      111111     10101    1001    _.     _.
     1111111        _.      _.    _.     _.
    11111111   1010101      _. 10001     _.
   111111111        _. 1001001    _.     _.
  1111111111 101010101      _.    _. 100001
)

NB. tdd =: 10 5 $ _.        _.      _.    _.     _.  _.        _.      _.    _.     _.  11x        _.      _.    _.     _.  111x        _.      _.    _.     _.  1111x       101x      _.    _.     _.  11111x        _.      _.    _.     _.  111111x     10101x    1001x    _.     _.  1111111x        _.      _.    _.     _.  11111111x   1010101x      _. 10001x     _.  111111111x        _. 1001001x    _.     _.  1111111111x 101010101x      _.    _. 100001x
tdd =: 11 5 $  0         0       0     0      0   0         0       0     0      0  11x         0       0     0      0  111x         0       0     0      0  1111x       101x       0     0      0  11111x         0       0     0      0  111111x     10101x    1001x     0      0  1111111x         0       0     0      0  11111111x   1010101x       0 10001x      0  111111111x         0 1001001x     0      0  1111111111x 101010101x       0     0 100001x

gdtrfgn =: [: (#~*) tdd {~ nd NB. Get Divisor Table Row For Given Number

ar =: [: */&.:-. 0 = 1 | ] % gdtrfgn NB. Any Repetitions?

echo +/ > +/each (#~ ar"0)each ({. + [: i. 1 + -~/) each ;/ input
