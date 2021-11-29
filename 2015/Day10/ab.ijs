require 'format/printf'

Note 'Original idea'
  "Something sooooorta like this
  '(\d)\1*' ((('.';'x') rxrplc ]),":)@# rxapply ] s"
)

lookandsay =: '(\d)\1*' (":@#,{.) rxapply ]

Note 'Actual numbers'
  Actual numbers can be produced/processed with
     lookandsay&.:":
)

input =: '3113322113'
day10a =: [:#lookandsay^:40
day10b =: [:#lookandsay^:50 NB. This one takes a few minutes but it gets there

echo 'Day 10:'
'  Part A: %d' printf day10a input
'  Part B: %d' printf day10b input

exit 1
