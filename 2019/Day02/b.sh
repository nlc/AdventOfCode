target=19690720

range=100

for p1 in $(seq 0 $range); do
  for p2 in $(seq 0 $range); do
    echo $p1 $p2
    output=$(ruby a.rb $p1 $p2)
    if [ "$output" -eq "$target" ]; then
      echo "FOUND"
      return
    fi
  done
  echo
done
