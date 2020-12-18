cat input.txt | sed \
  -e 's/(/{/g' \
  -e 's/)/(/g' \
  -e 's/{/)/g' > conditioned_input.txt
