require '../../utilities/utils.ijs'

NB. signal =: ($~10000*$) , readlines 'input_cheat.txt'

signal =: ? 10 $ 10

fftonce =: 4 : '10||+/ x * ($ x) $ 1 |. y # 0 1 0 _1'
fft =: 3 : '((y & fftonce)"0) >: i. $ y'

echo signal

echo fft^:1 signal
echo fft^:2 signal
echo fft^:3 signal
echo fft^:4 signal
echo fft^:5 signal
echo fft^:6 signal
echo fft^:7 signal
echo fft^:8 signal
echo fft^:9 signal

NB. for some reason, the right half of the numbers follows the sum
NB.   of differences! but why doesn't the left half?

NB. Note: think about the number wrapping around...
