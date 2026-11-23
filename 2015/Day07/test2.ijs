NB. OR
NB. AND
LSHIFT =: (33 b.)~
RSHIFT =: (-@[ (33 b.) ])~
NOT =: -.

echo ' -> '&([: ". [: ([,' =: ',])/ 2 0 pick rxmatch rxcut ])each cutLF fread 'sample.txt'
