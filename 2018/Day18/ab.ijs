require 'format/printf'

r0 =: (2<{:)*0={. NB. 0->1 transition rule
r1 =: (1+2<1{])*1={. NB. 1->2 transition rule
r2 =: (2*[:*[:*/}.)*2={. NB. 2->0 transition rule

input =: '.|#' i. > ,"1/each cutLF fread 'input.txt'
iter =: [: (r0 + r1 + r2)"1 [: (]((0 1 9 i. [),"(0 1) 9 9 #: -~) (1 1 ,: 3 3) +/^:2 ;._3 (_1 _1)|.(2+$){.]) (**9^-&1)
score =: ([:+/^:(2)1=])*([:+/^:(2)2=])

day18a =: [: score iter^:10

NB. Tortoise and Hare algorithm
tortoiseandhare =: [: (1&pick;~(1 2) + 0&pick)^:([: ({.~:{:) 0&pick { 1&pick)^:(_.) 1 2 ; ]

NB. simple "hash": add first and last lines and treat them like a base-6 number. Should be unique enough to use.
hashes =: (6x#:^:_1{.+{:)"(2) iter^:(i.2000) input

tortoise =: {. 0 pick tortoiseandhare hashes
cyclelength =: 1 + { i.~ >:@[ }. ]
clen =: tortoise cyclelength hashes
ansiters =: clen&|&.(-&tortoise) 1000000000

day18b =: [: score iter^:ansiters

echo 'Day 18:'
'  Part A: %d' printf day18a input
'  Part B: %d' printf day18b input

exit 0
