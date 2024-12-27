islock =: '#' = {.@{.

vectorize =: _1 + [: +/"1 '#' = ]

fit =: [:*/6>+


patterns =: |: each >@cutLF each '|' cut ((LF,LF);'|') rxrplc fread 'input.txt'

lockbool =: ([: > [: islock each ]) patterns

locks =: > vectorize each lockbool # patterns
keys =: > vectorize each (-.lockbool) # patterns

echo +/^:_ locks fit"1/~ keys

exit 0
