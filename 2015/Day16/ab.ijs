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

compatible =: 4 : 0
  key =. x

  children    =. ". '_' , ('.*: ' ; '') rxrplc ('children: \d+') rxfirst y
  cats        =. ". '_' , ('.*: ' ; '') rxrplc ('cats: \d+') rxfirst y
  samoyeds    =. ". '_' , ('.*: ' ; '') rxrplc ('samoyeds: \d+') rxfirst y
  pomeranians =. ". '_' , ('.*: ' ; '') rxrplc ('pomeranians: \d+') rxfirst y
  akitas      =. ". '_' , ('.*: ' ; '') rxrplc ('akitas: \d+') rxfirst y
  vizslas     =. ". '_' , ('.*: ' ; '') rxrplc ('vizslas: \d+') rxfirst y
  goldfish    =. ". '_' , ('.*: ' ; '') rxrplc ('goldfish: \d+') rxfirst y
  trees       =. ". '_' , ('.*: ' ; '') rxrplc ('trees: \d+') rxfirst y
  cars        =. ". '_' , ('.*: ' ; '') rxrplc ('cars: \d+') rxfirst y
  perfumes    =. ". '_' , ('.*: ' ; '') rxrplc ('perfumes: \d+') rxfirst y

  a =: children , cats , samoyeds , pomeranians , akitas , vizslas , goldfish , trees , cars , perfumes

  */ (a < _) # key = -a
)

key =: 3 7 2 3 0 0 5 3 2 1
echo 1 + {.@I. > (key compatible ]) each cutLF fread 'input.txt'
exit 0
