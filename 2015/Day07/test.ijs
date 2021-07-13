NB. An unassigned name in a definition is always treated as a verb.
require 'format/printf'

". 'c =: a + b'
". 'a =: 3 : ''2'''
". 'b =: 3 : ''5'''
NB. '%s =: 3 : ''%s''' sprintf RECEIVER ; EXPRESSION
echo ". 'c '''''

s =: 'bn RSHIFT 5 -> bq'
'expression receiver' =: ' -> ' splitstring s
echo '%s =: 3 : ''%s''' sprintf receiver ; expression
