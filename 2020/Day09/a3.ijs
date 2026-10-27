input =: > ". each cutLF fread 'input.txt'
({~ 25 + 0 i.~ 26 (}: OR/@e. {: - }:) \ ]) input

NB. beginnings of part b
NB. (1 i.~ [: {. ] #~ +/"1) (2 + i. 20) (756008079=+/)\ input
