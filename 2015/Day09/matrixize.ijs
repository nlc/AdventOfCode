require 'regex'

Note 'Weirdness'
  This was supposed to be a simple script that I could use to format the input
  into something I could shove into Wolfram|Alpha (and then I ended up
  getting a user key and installing Wolfram Engine because stupid Alpha has
  a brutal character limit for queries), but once I realized how small the
  problem as stated actually was I just brute-forced it. So this also contains
  the solution.
)

input =: 0 2 4&{@cutopen each cutopen (1!:1) < 'input.txt'

key =: [:<'-'&joinstring@sort

locnames =: ~. , > }: each input
dtable =: > (key@}: ; ".@>@{:) each input
dkeys =: {."1 dtable
dvalues =: {:"1 dtable
getdindex =: dkeys&i.
getdvalue =: (dvalues {~ getdindex)&.< :: _

matrix =: getdvalue"0 ([: key ,)"0/~ locnames
NB. matrixstr =: '{ %s }' sprintf '{ %s }' sprintf

encurl =: '{','}',~]
echo (' ';'') rxrplc ('_';'0') rxrplc encurl"1 ', '&joinstring"1 ;/ encurl"1 ', '&joinstring"1 ":each matrix

NB. And then we cheat and feed it to Wolfram Engine
NB. FindHamiltonianPath[ WeightedAdjacencyGraph[{{0, 129, 58, 13, 24, 60, 71, 67}, {129, 0, 142, 15, 135, 75, 82, 54},
NB.   {58, 142, 0, 118, 122, 103, 49, 97}, {13, 15, 118, 0, 116, 12, 18, 91}, {24, 135, 122, 116, 0, 129, 53, 40},
NB.   {60, 75, 103, 12, 129, 0, 15, 99}, {71, 82, 49, 18, 53, 15, 0, 70}, {67, 54, 97, 91, 40, 99, 70, 0}}]

NB. Tristram
NB. Tambi
NB. Snowdin
NB. AlphaCentauri
NB. Faerun
NB. Arbre
NB. Straylight
NB. Norrath

solorder =: <: 3 7 6 4 1 5 8 2 NB. Mathematica's solution

+/ getdvalue"0 key"1 (}:,.}.) solorder { locnames
NB. 207

NB. And at this point I realized that the problem is actually super tractable
NB. by simple brute force: (!8) = 40320

allperms =: A.~ i.@!@#
pathlength =: [: +/ [: getdvalue"0 [: key"1 }: ,. }.
lengths =: pathlength"1 allperms locnames

echo <./lengths
echo >./lengths

exit 1
