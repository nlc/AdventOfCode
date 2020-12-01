# q: What if we took advantage of the monotonicity of the function?
# a: A zillion times faster

# Binary search:
#   real    0m0.982s
#   user    0m0.715s
#   sys     0m0.245s

# Linear search:
#   real    7m57.545s
#   user    6m8.082s
#   sys     1m30.612s

# i.e. about 500 times faster lol

target=19690720

len=10000

p=
lo=0
hi=$len

while true; do
  p=$((($lo + $hi) / 2))
  ifmt=$(printf "%04d" $p)
  p1=$(echo $ifmt | cut -b1-2)
  p2=$(echo $ifmt | cut -b3-4)
  echo $p1 $p2
  output=$(ruby a.rb $p1 $p2)
  if [ "$output" -eq "$target" ]; then
    echo "FOUND"
    return
  elif [ "$output" -lt "$target" ]; then
    lo=$(($p + 1))
  elif [ "$output" -gt "$target" ]; then
    hi=$(($p - 1))
  fi
done
