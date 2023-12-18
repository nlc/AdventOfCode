input =: >"."0 each cutLF fread 'input.txt'
sample =: >"."0 each cutLF fread 'sample.txt'

day03a =: -:@#(<:*&#.>)+/

collect =: 1 : '(]#~ {"1 = -:@#@] u [:+/{"1)'

day03b =: 3 : 0
  num =. 1 { $ y

  data =. y
  for_i. i. num do.
    echo data =. i <: collect data
    echo ''
  end.

  data =. y
  for_i. i. num do.
    echo y =. i > collect y
    echo ''
  end.

  y
)

NB. echo day03a input

