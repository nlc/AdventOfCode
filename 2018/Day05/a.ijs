NB. This is for you, Ken

NB. Given input string s
([:|[:-/"1]{~[:(,>:)/"0~[:i.([:<:#))a.i.s 
NB. I got a ways, to be fair. Try to revisit this.

'OX' {~ (32 ~: }.|@-}:) a. i. 'aAaAJjasidfjbB'
NB. Closer but doesn't hanadle odd-length runs
# (#~ 0 ,~ 1 + }.-}:) (0 ,~ 32 ~: }.|@-}:) a. i. 'aAJjasidDdfjbBbBb'

((#~ [: -. i.@# e. 0 1 + 32 i.~ }.|@-}:)&.:ord)^:4 'uio' , 'aAJjasidDdfjbBbBb'

input =: (LF ; '') rxrplc fread 'input.txt'
NB. This works! Slowly, but it works.
# ((#~_>])@(#~ [: -. i.@# e. 0 1 + 32 i.~ }.|@-}:)@,&_)^:_ ord
