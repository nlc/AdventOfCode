ns =: > ([: ". '_?\d+' rxfirst ('lose ';'_') rxrplc ]) each cutLF fread 'sample.txt'

'p q' =: ([: |@(1&pick)@p. [:,&1 1 -@#) ns
t1 =: (+|:) (p, p) $ , _.&,"1 (q , p) $ ns
t2 =: (2 # p + 1) {. t1

sas =: 1 : '+/@((m {~ <@,)"(0) 1&|.)"1 y' NB. Seating Arrangement Score

echo >./ (t1 sas)@(] A.~ i.@!@#) i. p
echo >./ (t2 sas)@(] A.~ i.@!@#) i. p + 1
