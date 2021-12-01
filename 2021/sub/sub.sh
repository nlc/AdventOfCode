lines=(
  '           o  '
  '  _|______/|  '
  ' /G R G R G\/\'
  '( )\\\\___ =|>'
  ' \____(___)/\/'
  ',/,/      \|  '
  '           o  '
)

y_start=5
x_start=10

i=0
clear
for i in $(seq 0 ${#lines[@]}); do
  x=$x_start
  y=$(($y_start + $i))

  echo -ne "\033[${y};${x}H"

  echo "${lines[$i]}" |\
    sed 's/G/'"[32m"'*'"[0m"'/g' |\
    sed 's/R/'"[31m"'*'"[0m"'/g'
done
