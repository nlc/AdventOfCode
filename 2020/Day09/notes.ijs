data =: 35 20 15 25 47 40 62 55 65 95 102 117 150 182 127 219 299 277 309 576

runlength =: 5 NB. 25
xx =: 1 ,: runlength
tiling =: ;._3

echo xx ([:~.[:,+/~) tiling data

exit 1
