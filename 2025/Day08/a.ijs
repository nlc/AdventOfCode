input =: > ([: > [: ". each ',' cut ]) each cutLF fread 'input.txt'
$ ([: +/ [: *: -)"1 /~ input NB. absolufreakinglutely a way to do this much smarter
