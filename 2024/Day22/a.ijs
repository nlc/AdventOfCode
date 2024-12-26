   M=: 2^24
   M-1
1.67772e7
   
   M-1x
1.67772e7
   
   M=: 2^24x
   M
16777216
   prune =: 16777215 AND ]
   mix =: XOR
   shift =: 33 b.
   prune 123 mix 6 shift 123
7867
   
   prune 7867 mix _5 shift 7867
7758
   
   prune 7867 mix _5 shift 7867
7758
   
   prune 7758 mix 11 shift 7758
15888384
   
   11 _5 6shift 7758
15887950
   
   11 _5 6 shift 7758
15888384 242 496512
   
   mix/11 _5 6 shift 7758
16114546
   
   prunemix/11 _5 6 shift 7758
|value error: prunemix
|       prunemix/11 _5 6 shift 7758
   
   prune mix/11 _5 6 shift 123
16114546
   
   prune mix/11 _5 6 shift 123
247491
   step =: 4 : 'prune y mix x shift y'
   6 step 123
7867
   
   11 step _5 step 6 step 123
15887950
   evolve =: 3 : '11 step _5 step 6 step y'
   evolve^:(i. 10) 123
15887950
   
   evolve^:2000 123
123 15887950 16495136 527345 704524 1553684 12683156 11100544 12249484 7753432
   
   evolve^:2000 123
evolve^:2000 123
   
   evolve^:2000 123
evolve^:2000 123
   
   evolve^:(2000) 1
1110806
   
   evolve^:(2000) 1
8685429
   
