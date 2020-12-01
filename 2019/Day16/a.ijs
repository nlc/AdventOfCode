require '../utilities/readlines.ijs'

signal =: , readlines 'input_cheat.txt'

NB. Naive version: "6" of "sig"
NB. 10||+/ sig * ($ sig) $ 1 |. 6 # 0 1 0 _1

fftonce =: 4 : '10||+/ x * ($ x) $ 1 |. y # 0 1 0 _1'
fft =: 3 : '((y & fftonce)"0) >: i. $ y'

echo 10 #. 8 {. fft^:100 signal
