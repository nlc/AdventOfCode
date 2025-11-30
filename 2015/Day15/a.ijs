input =: ". each ('-';'_')&rxrplc each ('[^-\d]';' ')&rxrplc each cutLF fread 'input.txt'

NB. */ 0 >."(0) 44 56 (+/ . *) ingredients
score =: [: */ 0 >. (4 {."1 input) +/ .*~ ]
