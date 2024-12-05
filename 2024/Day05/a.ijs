'rulestrs seqstrs' =: cutLF each 0 2 { (LF,LF) ([@rxmatches rxcut ]) fread 'input.txt'

rules =: ('.*' joinstring [: |. '|'&cut) each rulestrs

echo +/ >". each > ( (] {~ [: <.@-:@# ]) ',' cut ]) each seqstrs #~ -.@* +/ > >each seqstrs (rxin each ])"0/~ rules

exit 0
