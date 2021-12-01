require '../../utilities/utils.ijs'

sumto=:=+/~
mulall=:*/~

inputs =: ". readlines 'input.txt'

NB. Part A
echo >./ ^:_ (mulall * 2020&sumto) inputs

NB. Part B
echo >./^:_(inputs */ inputs */ inputs) * 2020 = (inputs +/ inputs +/ inputs)

exit 0
