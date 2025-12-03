sample =: "."0 each cutLF fread 'sample.txt'
input =: "."0 each cutLF fread 'input.txt'

echo +/ > (10 1 +/ . * {.,>./@}.)@(]}.~]i.>./@}:) each input
