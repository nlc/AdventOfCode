require 'format/printf'

md5 =: 15 (128!:6) ]

input =: 'uqwqemis'

gen =: ([: md5 '%s%d' sprintf ;)"1 0
atest =: ('00000' -: 5 {. gen)"1 0
btest =: ([: ((8 > 48 -~ a. i. 5 { ]) * ('00000' -: 5 {. ])) gen)"1 0

NB. (#~ 'abc' ('00000' -: 5 {. [: md5 '%s%d' sprintf ;)"(1 0)]) i. 1000000

day05a =: 3 : 0
  res =. 0 $ 0
  i =. 0

  while. (# res) < 8 do.
    res =. res , (#~ y atest ]) (i * 100000) + i. 100000
    i =. i + 1
  end.

  5 {"1 y gen 8 {. res
)

NB. Frustratingly unintuitive to do without a lot of imperative programming.
day05b =: 3 : 0
  res =. 0 $ 0
  idxs =. 0 $ 0
  chrs =. 0 $ 0
  i =. 45

  while. (# res) < 8 do.
    echo i
    echo res =. res , (#~ y btest ]) (i * 100000) + i. 100000
    echo idxs 5 {"1 y gen res

    i =. i + 1
  end.

  NB. 5 {"1 y gen 8 {. res
  res
)

NB. echo day05a input
NB. exit 1
