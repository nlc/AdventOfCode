require 'format/printf'
load 'regex'
input =: cutopen (1!:1) < 'input.txt'

NB. Day 08 Part A solution
sq =: ('^"|"$' ; '')&rxrplc NB. Strip Quotes
uq =: ('\\"' ; '"')&rxrplc NB. Unescape Quotes
ub =: ('\\\\' ; '\')&rxrplc NB. Unescape Backslashes
ue =: ('\\x[0-9a-f]{2}' ; '?')&rxrplc NB. Unescape Escape sequences
ns =: ub@ue@uq@sq NB. Normalize Strings
ln =: #@ns NB. Length of Normalized string
dl =: #-ln NB. Difference in Lengths
day08a =: [: +/ [: > dl&.>

NB. Day 08 Part B solution
day08b =: 0:
as =: ('.*' ; '"&"')&rxrplc NB. Add Surrounding quotes

NB. Print answers
echo 'Day 08:'
'  Part A: %d' printf day08a input
'  Part B: %d' printf day08b input

exit 1
