(9 !: 37) 0 1024 0 1024

delay =: (6 !: 3)

cgol=:(]=3+4=*)[:+/^:2(,"0/~@i:1)&|.
br =: [: u: 10240&+
n2b =: ([: br 0 2 4 1 3 5 6 7&{&.|.&.((8$2)&#.^:_1))"0
g2b =: (4 2 ,: 4 2)&(([:n2b[:#.[:|.,);._3)

iterate =: monad define
  echo g2b"2 grid =: (cgol^:y) grid
)

frame =: monad define
  echo ''
  iterate 1
  delay y
)

NB. Seed rng
(9!:1) ". (1!:1) 3

NB. grid =: ? 220 406 $ 2
grid =: ? 276 544 $ 2

(frame ^: 10000) 2
