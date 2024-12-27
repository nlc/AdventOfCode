NB. It is a six-digit number.
NB. The value is within the range given in your puzzle input.
NB. Two adjacent digits are the same (like 22 in 122345).
NB. Going from left to right, the digits never decrease;
NB.   they only ever increase or stay the same (like 111123 or 135679).

digits =: 10&#.^:_1
issorted =: -:/:~

NB. crude
mask =: 6 6 $ 0 1 0 0 0 0 1 0 1 0 0 0 0 1 0 1 0 0 0 0 1 0 1 0 0 0 0 1

is6digit =: 6 = [: # digits NB. is a 6-digit number
inrange =: 0 1 -: > NB. y is in the non-inclusive range specified by x
eqadj =: [:+./^:_ [:mask & * [: =/~ digits NB. there are at least two adjacent equal digits
ascending =: [: issorted digits

sequence =: 152085 + i. 670283 - 152085

echo $ ((ascending"0)#]) ((eqadj"0)#]) sequence
NB. 1764

isopair =: 3 : '0 1 1 0 +./@:E. ,0&,,"1&0 =/~ digits y'

echo $ ((ascending"0)#]) ((isopair"0)#]) sequence
NB. 1196

exit 0
