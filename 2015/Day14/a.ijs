require 'format/printf'

Note 'Data'
  Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.

  14 speed
  10 fly
  127 rest
  10 + 127 = 137 cycle
  14 * 10 = 140 distance per cycle

  time in current cycle: (137 | ])y
  is resting?: (10 <: time in current cycle) y
  fly cycles completed: (resting? + 137 %~ ]) y
  distance gone in current fly cycle: min(distance per cycle, speed * time in current cycle)
)

fly =: 4 : 0
  's f r' =. y NB. speed, flytime, resttime
  d =. s * f NB. distance gone per cycle
  t =. f + r NB. total time

  ((d * [: <. t %~ ]) + s * f <. t | ]) x
)

input =: >> ([: ". each '\d+'&rxall) each cutLF fread 'input.txt'

echo 'Day 14:'
'  Part A: %d' printf >./ (2503 fly ])"1 input

exit 0
