NB. Cut into alternating unbracketed/bracketed/unbracketed/... segments
('\[[^\]]*\]'&rxmatches rxcut ]) string

([:  [: > [: ('.*(.)((?!\1).)\2\1.*' rxeq ]) each ('\[[^\]]*\]'&rxmatches rxcut ])) each sample
