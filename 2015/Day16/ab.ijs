(*1-~2*_<:])

num =: [: (*1-~2*_<:]) [: ". '_' , ('.*: ' ; '') rxrplc rxfirst

parse =: 3 : 0
  > y&(num~) each 'children: \d+'; 'cats: \d+'; 'samoyeds: \d+'; 'pomeranians: \d+'; 'akitas: \d+'; 'vizslas: \d+'; 'goldfish: \d+'; 'trees: \d+'; 'cars: \d+'; 'perfumes: \d+'
)

compatiblea =: 4 : 0
  key =. x

  a =: parse y
  */ (a < _) # key = parse y
)

key =: 3 7 2 3 0 0 5 3 2 1
echo 1 + {.@I. > (key compatiblea ]) each cutLF fread 'input.txt'
NB. exit 0
