Note 'Key'
  children:    n
  cats:        c
  samoyeds:    s
  pomeranians: p
  akitas:      a
  vizslas:     v
  goldfish:    g
  trees:       t
  cars:        r
  perfumes     f
)

condition =: 3 : 0
  s =. y
  s =. ('children' ; 'n') rxrplc s
  s =. ('cats' ; 'c') rxrplc s
  s =. ('samoyeds' ; 's') rxrplc s
  s =. ('pomeranians' ; 'p') rxrplc s
  s =. ('akitas' ; 'a') rxrplc s
  s =. ('vizslas' ; 'v') rxrplc s
  s =. ('goldfish' ; 'g') rxrplc s
  s =. ('trees' ; 't') rxrplc s
  s =. ('cars' ; 'r') rxrplc s
  s =. ('perfumes' ; 'f') rxrplc s

  s =. ('^Sue \d+: ' ; '') rxrplc s
  s =. (',|: ' ; '') rxrplc s

  s
)

input =: condition each cutLF fread 'input.txt'
