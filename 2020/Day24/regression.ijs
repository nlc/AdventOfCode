require 'plot'

lr =: 4 : 'y %. 1 ,. x'

cts =: > ". each cutopen fread 'counts_input.txt'
sqrtpoly =: (i. # cts) lr %: cts NB. Linear regression of square root of data

plot ((}.-}:) cts) , cts ,: (*: sqrtpoly p. i. # cts)

exit 0
