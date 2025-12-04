dims =: 3 7

NB. ON mask for "rect 3x2"
3 2 (] e. [: , |.@[ {. ]) i. 3 7

NB. A way to "rotate column x=1 by 1"
0 _1 0 0 0 0 0 (|."0 1)&.:|: 3 2 (] e. [: , |.@[ {. ]) i. 3 7

NB. Rotates column where x=1... but only by 1.
1 (] (|."0 1)&.:|:~ [ -@= i.@{:@$@]) 3 2 (] e. [: , |.@[ {. ]) i. 3 7
