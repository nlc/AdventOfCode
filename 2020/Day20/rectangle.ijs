NB. require '../../utils.ijs' NB. for "odometer"

NB. Get the different side lengths to form a rectangle of area 72,
NB. plus their perimeter
NB. (;2&*@+/)"1 ~. sort"1 (([: odometer 2 * *) *//."1 ]) q: 72

NB. possible integer sides for a rectangle of area y
NB. odometer f.-expanded for less dependence
NB. do it by partition--cute but inefficient
sidespartition =: [: (] #~ 0 -.@e."1 ]) [: ~. [: /:~ :/:"1 [: (([: (#: i.@(*/)) 2 * *) *//."1 ]) q:@]

NB. Do it by divisibility test
sides =: (],"0%) ] (]#~0=|~) 1 }. [: i. 1 + <.@%:

perimsandsides =: [: (2&*@+/;])"1 sides
sidesfor =: (1 pick"1 ]#~[=(0&pick)"1@]) perimsandsides@]
