serial =: 6392
power =: ] (5-~[:10&|[:<.100%~]*[:serial&+*) [:10&+[
cells =: power"0/~1+i.300
clusters=:([:+/^:2(,"0/~@i:1)&|.)cells
max =: >./^:_ clusters
<.(300&|,~%&300)max i.~,clusters
