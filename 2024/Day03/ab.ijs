input =: fread 'input.txt'

isoa =: 'mul\(\d+,\d+\)'&rxall
process =: [: +/ [: > ([: */ [: ". ('\D';' ')&rxrplc) each

echo +/ > ([: */ [: ". ('\D';' ')&rxrplc) each isoa input
echo process@isoa input

exit 1
