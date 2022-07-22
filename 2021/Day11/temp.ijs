require '../../utilities/utils.ijs'

input =: > "."0 each cutopen fread 'input.txt'
sl =: > "."0 each cutopen fread 'sample2.txt'
s0 =: > "."0 each cutopen fread 'sample2.txt'

vs =: 9 2($,) ,"0/~ i: 1
vs |."(1 2) 9 = >: input

NB. dispersal =: +/@((vs |."(1 2) >:&9)&.rim
NB. (>:*<&9)@(+dispersal) input
NB. 
NB. (>:*<&9)@(+dispersal)^:(i. 3)

NB. flash mask joined to first-level propagation result:
(] (] ;~ [ + [: +/ vs |."(1 2) ]) 9 <: ]) sl

NB. make it able to be applied multipe times
([: (] (] ;~ [ + [: +/ vs |."(1 2) ]) 9 <: ]) 0 pick ] ) < sl

Note 'strategy'
  keep mask and result separate, AND result with NOT mask
  before propagating
)

NB. SO CLOSE but it adds to the prepropagated ones
([: (] (] ;~ [ + [: +/ vs |."(1 2) ]) 9 <: ]) ([: -. 1 pick ]) * (0 pick ]) )^:3 sl ; 5 5 $ 0
