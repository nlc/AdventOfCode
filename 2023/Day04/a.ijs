NB. Input parsing
extract =: 1 : '> ". each ''\d+'' rxall m rxfirst y'
carddata =: > ('Card *\d+' extract ; ':.*\|' extract ; '\|.*' extract) each cutopen fread 'input.txt'

NB. Actual logic
echo ([:+/2^1-~*#]) (1&pick (e.#@#[) 2&pick)"1 carddata

exit 1
