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
dln =: #-ln NB. Difference in Lengths to Normalized
day08a =: [: +/ [: > dln&.>

NB. Day 08 Part B solution
pa =: '.*'&(('"',~'"',]) rxapply) NB. Prepend/Append quotes
eq =: ('"' ; '\"')&rxrplc NB. Escape Quotes
eb =: ('\\' ; '\\')&rxrplc NB. Escape Backslashes
es =: pa@eq@eb
le =: #@es
dle =: le-# NB. Difference in Lengths from Escaped
day08b =: [: +/ [: > dle&.>

NB. Print answers
echo 'Day 08:'
'  Part A: %d' printf day08a input
'  Part B: %d' printf day08b input

NB. exit 1
