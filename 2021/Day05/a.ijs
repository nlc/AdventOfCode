sample =: > ". each cutLF (',| -> ';' ') rxrplc fread 'sample.txt'

vertical =: (0&({ ) = 2&({ ))"1
horizontal =: (1&({ ) = 3&({ ))"1
orthogonal =: horizontal OR vertical
diagonal =: -.@orthogonal

select =: 1 : '(#~u)y'

i."0 ({:-{.) ([: sort 2&{. ,: _2&{.)"1 {. horizontal select sample

([: sort 2&{. ,: _2&{.)"1 {. horizontal select sample

({. + i."0@({:-{.)) ([: sort 2&{. ,: _2&{.)"(1) 1 { horizontal select sample

NB. Generate orthogonal index pairs from a starting point to an ending point, inclusive
({: ,~ [: |: {. + i."0@({:-{.)) ([: sort 2&{. ,: _2&{.)"(1) 1 { horizontal select sample

([: ({: ,~ [: |: {. + i."0@({: - {.)) ([: sort 2&{. ,: _2&{.)"1) each { sample
