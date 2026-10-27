'in1 in2' =: 0 2 {  (3 # LF) (] rxcut~ rxmatches) fread 'input.txt'

echo cutLF in1

op_addr =: ([: +/ [ {~ 0 1&{@]) ({:@]) } [
op_mulr =: ([: */ [ {~ 0 1&{@]) ({:@]) } [
op_banr =: ([: AND/ [ {~ 0 1&{@]) ({:@]) } [
op_borr =: ([: OR/ [ {~ 0 1&{@]) ({:@]) } [
