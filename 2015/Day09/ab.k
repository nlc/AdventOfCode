i:,/("    I";" ")0:"input.txt"
j:0
k:0
d:()
do[8
   d,:,((j+1)#0),i[k+!8-j+1]
   k+:8-j+1
   j+:1]
;d+:+d

p:{:[x>1;,/(!x)!\:/:0,/:1+_f[x-1];!x]} / generate permutations of x elements
a:+/+{d[x;y]}':' p 8

`0: "2015 Day 09:\n"
`0: "  Part A: " , ($ &/ a) , "\n"
`0: "  Part B: " , ($ |/ a) , "\n"

\\
