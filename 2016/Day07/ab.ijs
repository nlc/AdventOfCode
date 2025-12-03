input =: cutLF fread 'input.txt'

NB. aAAAAaaAAAAAAAAAAA
echo +/ > (([:AND/ -.)@(1&pick) AND (OR/)@(0&pick)) each (2&|@i.@# </. ]) each ([: > [: ('.*(.)((?!\1).)\2\1.*' rxeq ]) each ('\[[^\]]*\]'&rxmatches rxcut ])) each input

NB. aAAAAaaAAAAAAAAAAAaaaAAaaaaAAAAaAAAA
echo +/ > ('(.)((?!\1).)\1.*--.*\2\1\2' rxin ]) each ([: '--'&joinstring [: '<>'&joinstring each 2&|@i.@# </. ]) each ('\[[^\]]*\]'&rxmatches rxcut ]) each input
