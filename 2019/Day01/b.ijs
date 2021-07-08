require '../utilities/utils.ijs'
input =: readlines 'input.txt'

NB. to find the fuel required for a module, take its mass, divide by three, round down, and subtract 2.
fuel =: _2+[:<.1r3&*

NB. A perfect place to apply the do-while syntax
NB. "This is the construct: (u^:v^:_ y) or: (x u^:v^:_ y)
NB.  - Verb v must always produce a Boolean result.
NB.  - Verb u is executed repeatedly until v returns 0 or u returns its argument unchanged."

NB. (u^:v^:_ y)
NB. (fuel^:(>&0)^:a:) 3367126 NB. What the fuck, what is that a: doing
NB. Note to self: figure out how framing fill works

convfuel =: 3 : '+/}.(*>&0)(fuel^:(>&0)^:a:)y'
echo +/ convfuel"0 input

exit 0

NB. 5047796
