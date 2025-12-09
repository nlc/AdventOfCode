Note 'properties'
  Splitters don't appear next to one another. That means that
  we can probably just sweep a row of "beam" occupancy bits
  downward and have transition rules--an occupied position
  meeting a splitter *always* sets itself to zero and the two
  neighbors to 1:
    ... x1x ...
   +... 010 ...
   =... 101 ...
)

Note '2-bit CA'
  after "splitters #.@|:@,: beam"
  0: no beam, empty space
  1: beam through empty space
  2: splitter with no beam
  3: beam hits splitter

  0 0 0: 0
  0 0 1: 0
  0 0 2: 0
  0 0 3: 1
  0 1 0: 1
  0 1 1: 1
  0 1 2: 1
  0 1 3: 1
  0 2 0: 0
  0 2 1: 0
  0 2 2: 0 NB. technically forbidden
  0 2 3: 0 NB. technically forbidden
  0 3 0: 0
  0 3 1: 0
  0 3 2: 0 NB. technically forbidden
  0 3 3: 0 NB. forbidden
  1 0 0: 0
  1 0 1: 0
  1 0 2: 0
  1 0 3: 1
  1 1 0: 1
  1 1 1: 1
  1 1 2: 1
  1 1 3: 1
  1 2 0: 0
  1 2 1: 0
  1 2 2: 0
  1 2 3: 0 NB. forbidden
  1 3 0: 0
  1 3 1: 0
  1 3 2: 0 NB. technically forbidden
  1 3 3: 0 NB. forbidden
  2 0 0: 0
  2 0 1: 0
  2 0 2: 0
  2 0 3: 1
  2 1 0: 1
  2 1 1: 1
  2 1 2: 1
  2 1 3: 1
  2 2 0: 0 NB. technically forbidden
  2 2 1: 0 NB. technically forbidden
  2 2 2: 0 NB. technically forbidden
  2 2 3: 0 NB. technically forbidden
  2 3 0: 0 NB. ''
  2 3 1: 0 NB. ''
  2 3 2: 0 NB. ''
  2 3 3: 0 NB. ''
  3 0 0: 1
  3 0 1: 1
  3 0 2: 1
  3 0 3: 1
  3 1 0: 1
  3 1 1: 1
  3 1 2: 1
  3 1 3: 1
  3 2 0: 0 NB. technically forbidden
  3 2 1: 0 NB. tf
  3 2 2: 0 NB. tf
  3 2 3: 0 NB. ''
  3 3 0: 0 NB. forbidden
  3 3 1: 0 NB. forbidden
  3 3 2: 0 NB. forbidden
  3 3 3: 0 NB. forbidden

  0 0 0 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0
  2233819500556386048

  (3 (((64#2)#: 2233819500556386048x) {~ 4 4 4 #. ])\ 0,~0,])
)



'b s' =: ({. ; }.) > cutLF fread 'input.txt'
beamstart =: 'S' = b
splitters =: '^' = s

NB. ('S' = b) < F:. ( #.@|:@,: ) '^' = s
beampath =: > beamstart < F:. ( [: (3 (((64#2)#: 2233819500556386048x) {~ 4 4 4 #. ])\ 0,~0,]) #.@|:@,: ) splitters
echo +/^:_(}:beampath) * (}.splitters)
