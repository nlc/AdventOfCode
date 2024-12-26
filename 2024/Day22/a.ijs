prune =: 16777215 AND ]
mix =: XOR
shift =: 33 b.

step =: 4 : 'prune y mix x shift y'
evolve =: 3 : '11 step _5 step 6 step y'
