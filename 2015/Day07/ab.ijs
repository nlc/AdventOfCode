require 'format/printf'

fLSHIFT =: (33 b.)~
fRSHIFT =: -@](33 b.)[
fNOT =: 3 : '#. NOT (16#2)&#:y'
fOR =: 4 : '#. ((16#2)&#: x) OR ((16#2)&#: y)'
fAND =: 4 : '#. ((16#2)&#: x) AND ((16#2)&#: y)'

prependf =: 3 : 0
  cutstr =. cutopen y
  newval =. 'f'&, each _2 { cutstr
  ' ' joinstring newval _2 } cutstr
)

s =: 'bn RSHIFT 5 -> bq'
'expression receiver' =: ' -> ' splitstring s
news =: '%s =: 3 : ''%s''' sprintf receiver ; prependf expression
echo news
". news
bn =: 12471
echo bq ''

s =: 'af AND ah -> ai'
'expression receiver' =: ' -> ' splitstring s
news =: '%s =: 3 : ''%s''' sprintf receiver ; prependf expression
echo news
". news
af =: 17
ah =: 18
echo ai ''
