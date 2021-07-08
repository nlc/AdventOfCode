require '../utilities/utils.ijs'

(9!:37)0 _ _ _

lines =: readlines 'input_cheating.txt'

data =: 100 6 25 $,lines

idxlstzro =: (i.<./)((+/"1)^:2) 0=data

echo (([:+/1&=) * ([:+/2&=)) , idxlstzro{data

exit 0
