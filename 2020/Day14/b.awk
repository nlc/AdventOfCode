# AWK didn't get to be used for Part A as intended,
# so it gets to be the finisher for part B

# Set a memory location
/^mem\[[0-9]+\] = [0-9]+$/ {
  address = gensub(/mem\[|\]/, "", "g", $1);
  value = $3;

  mem[address] = value;
}

END {
  sum = 0;
  for(loc in mem) {
    sum += mem[loc];
  }

  print sum;
}
