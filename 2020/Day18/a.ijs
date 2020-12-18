NB. Cheated a little bit by reversing the parens in the input,
NB. but you have to admit that this problem is crying out for
NB. J's strict right-to-left parsing.

revparse =: [: ". [: ,/ [: > [: |. ;:

lines =: >cutopen (1!:1) < 'input_conditioned.txt'

echo +/ revparse"1 lines
exit
