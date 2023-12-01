snafufwd =: 5 #:^:(_1) 2 -~'=-012' i. ]
snafuinv =: 3 : 0
  if. y = 0 do.
    '0' return.
  end.

  signum =. * y
  y =. | y

  ndigits =. (1 + [: <. 5 ^. 2 * ]) y

  NB. (2 2 2 2 -~ 5 5 5 5 | 2 2 2 2 + 125 25 5 1 <.@%~ 62 12 2 0 + ])"(1 0) i. 19
  divisors =. |. 5x ^ i. ndigits
  offsettors =. 1 -~ <. 1 + divisors % 2
  NB. (ndigits # 2) -~ (ndigits # 5) | (ndigits # 2) + divisors <.@%~ offsettors + y
  digits =. 2 -~ 5 | 2 + divisors <.@%~ offsettors + y

  if. signum = 1 do.
    '=-012' {~ 2 + digits
  else.
    '210-=' {~ 2 + digits
  end.
)
snafu =: snafufwd :. snafuinv

snafu cutopen fread 'input.txt'
