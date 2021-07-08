require '../utilities/utils.ijs'
input =: readlines 'input.txt'

NB. to find the fuel required for a module, take its mass, divide by three, round down, and subtract 2.
fuel =: _2+[:<.1r3&*

echo +/ fuel input

exit 0

NB. 3367126
