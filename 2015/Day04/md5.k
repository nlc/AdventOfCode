s: ,/ { 16 # x }' { 4 4 # x } 7 12 17 22 5 9 14 20 4 11 16 23 6 10 15 21 / table of s
K: { _ (2^32) * _abs _sin(x + 1) }' !64 / table of K

a0: (32 # 2) _vs 16 _sv 6 7 4 5 2 3 0 1
b0: (32 # 2) _vs 16 _sv 14 15 12 13 10 11 8 9
c0: (32 # 2) _vs 16 _sv 9 8 11 10 13 12 15 14
d0: (32 # 2) _vs 16 _sv 1 0 3 2 5 4 7 6

s2b: { ,/ {(8 # 2) _vs x }' _ic x } / string to bitstring
pad: { x , (448 - (# x) ! 512) # 0 } / zero-pad to length 448 mod 512

msg: s2b "1"
ol: # msg / original length

msg: pad msg , 1 / append 1 and zero-pad to length 448 mod 12
msg ,: ,/ | (-1 8) # (64 # 2) _vs ol / append original msg length (skip modding by 2^64 :p)

`0: $ (2 _sv/: (16 32) # msg)
\\

n: (# msg) % 512 / num. chunks
c: 0 / chunk index
do[n;
   cnk: msg@(512*c)+!512;
   `0: "cnk: " , (5: cnk) , "\n";
   M: 2 _sv/: 16 32 # cnk;
   `0: "M: " , (5: M) , "\n";
   A: a0;
   B: b0;
   C: c0;
   D: d0;
   i:0;
   do[64;
      F:0;
      g:0;
      `0: "i: " , (5: i) , "\n";
      if[i<16; F: (B & C) | ((~B) & D); g: i];
      if[(i>15)&(i<32); F: (D & B) | ((~D) & C); g: (1 + 5 * i)!16];
      if[(i>31)&(i<48); F: {(x+y)!2}/ (B ; C ; D); g: (5 + 3 * i)!16];
      if[i>47; F: (C + (B | (~D)))!2; g: (7 * i)!16];
      `0: "F: " , (5: F) , "\n";
      `0: "g: " , (5: g) , "\n";
      `0: "K@i: " , (5: K@g) , "\n";
      `0: "M@g: " , (5: M@g) , "\n";
      `0: "s@i: " , (5: s@i) , "\n";
      F: (32 # 2) _vs (2 _sv F) + (2 _sv A) + (K@i) + (M@g);
      A: D;
      D: C;
      C: B;
      B: (32 # 2) _vs (2 _sv B) + 2 _sv (s[i]) ! F;
      i+:1];
   a0: (32 # 2) _vs (2 _sv a0) + (2 _sv A);
   b0: (32 # 2) _vs (2 _sv b0) + (2 _sv B);
   c0: (32 # 2) _vs (2 _sv c0) + (2 _sv C);
   d0: (32 # 2) _vs (2 _sv d0) + (2 _sv D);
   c+:1]

dig: a0 , b0 , c0 , d0
hex: "0123456789abcdef" @/: 2 _sv' (-1 4) # dig

`0: "dig: " , (5: dig) , "\n";
`0: "hex: " , (5: hex) , "\n";
