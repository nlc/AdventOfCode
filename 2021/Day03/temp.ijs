NB. (0&{"1 # ])  data
NB. 
NB. 500 <: +/ data    
NB. 
NB. 1 1 0 0 1 0 1 1 1 0 1 1

go =: 4 : 0
  n =: -: # y
  mask =: n > +/ y

  ((x { mask) = x{"1 y) # y
)

NB. 1 1 1 1 1 0 1 1 0 1 1 1 
