manhattan =: ([: +/ |) :([: +/ |@-)
ring =: [: >. ([:*:1+2*])^:(_1) NB. Establish what ring it's in
ringlength =: (^*)@(8*]) NB. How many entries in a ring?

NB. functions for "corner" numbers of a ring x
se =: 1 4 4&p.
ne =: 7 _10 4&p.
nw =: 1 0 4&p.
sw =: 3 _6 4&p.

NB. Sequence
([: (|.@}.}:@,]) ] + i.@(1&+)) each <"(0) i. 4

quadruple =: (4&*)@# $ ]

input =: ". fread 'input.txt'
