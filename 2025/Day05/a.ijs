require 'format/printf'

'rss iss' =: cutLF each 0 2 { ((LF , LF)&rxmatch rxcut ]) fread 'input.txt'

is =: sort > ".each iss
rs =: sort > ([: > [: ".each '-'&cut) each rss


Note 'Adding ranges'
  Keep track of s (sum) and n (current number)
  Assuming all ranges are of the form (a..b), where b >= a
  For each range (a..b) in the list of all ranges, sorted ascending by lower bound:
    if b < n
      # do nothing
    else
      set s = s + b - max(a, n) + (a > n)
    end
    set n = max(n, b)
    go to next range
)

NB. (a , b) combine (s , n)
addranges =: ({:@[ >. {:@]) ,~ {.@] + 0 >. ({.@[>{:@]) + {:@[ - ({.@[)>.({:@])

day05a =: +/ * +/ rs (({:@[>:]) * {.@[<:])"1 0/ is
day05b =: {. 0 0 ] F.. addranges rs

echo 'Day 05:'
'  Part A: %d' printf < day05a
'  Part B: %d' printf < day05b
exit 1
