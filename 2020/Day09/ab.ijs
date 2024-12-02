require '../../utilities/utils.ijs'

NB. part a
NB. data =: 35 20 15 25 47 40 62 55 65 95 102 117 150 182 127 219 299 277 309 576
NB. runlength =: 5

data =: ". readlines 'input.txt'
runlength =: 25

xx =: 1 ,: runlength
tiling =: ;._3

values =: runlength }. data NB. data w/o preamble

xrefs =: xx ([:~.[:,+/~) tiling data

missingindex =: 0 i.~ values e."0 1 (}:xrefs)
targetvalue =: missingindex { values

echo missingindex
bold 1
echo targetvalue
bold 0

datalength =: # data

NB. part b
maxrunlen =: 100 NB. For performance assume that the run is not longer than maxrunlen
run =: dyad def '(1 ,: x) ] ;._3 y'
NB. contigstart =: 1 i.~ }. targetvalue e."1 +/"1(>: i. maxrunlen) run"0 1 data NB. index of start of run
findings =: }. (* datalength&>) targetvalue i.~"1 +/"1(>: i. maxrunlen) run"0 1 data NB. index of start of run
contigstart =: +/ findings
contiglength =: 2 + findings i. contigstart
echo contigstart
echo contiglength
NB. contiglength =: contigstart + 2
NB. echo contigstart

bold 1
echo (<./ + >./) (contigstart ,: contiglength) ];.0 data
bold 0
NB. echo (contigstart ,: contiglength) ];.0 data

NB. exit 1
