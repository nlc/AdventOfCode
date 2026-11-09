require 'format/printf'

Note 'strategy'
  x and y can be considered entirely separately
  the "folding" is a function that maps x -> min(x, 2X - x) for some X
)

ifname =: 'input.txt'
'dotsstr instructionsstr' =: (1 0 1 # ] rxcut~ (LF , LF) rxmatches ]) fread ifname
dots =: > ". each cutLF dotsstr
'xs ys' =: |: dots

NB. halfdimx =: ". ('\d+' rxfirst ]) ('x=\d+' rxfirst ]) instructionsstr
NB. halfdimy =: ". ('\d+' rxfirst ]) ('y=\d+' rxfirst ]) instructionsstr
NB. dims =: 1 2 p. halfdimx , halfdimy

xfolds =: > ([: ". '\d+' rxfirst ]) each ('x=\d+' rxall ]) instructionsstr
yfolds =: > ([: ". '\d+' rxfirst ]) each ('y=\d+' rxall ]) instructionsstr

place =: 4 : '|: 1 (<"1 y) } x $ 0' NB. dims place dots
foldover =: ] <. +:@[ - ]

echo 'Day 13:'
'  Part A: %d' printf # ~. |: (({. xfolds) foldover xs) ,: ys
echo '  Part B:'
echo '.#' {~ 40 7 place |: ((xs) (]) F.. (foldover) xfolds) ,: ((ys) (]) F.. (foldover) yfolds)

exit 0
