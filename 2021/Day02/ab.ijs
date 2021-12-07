require '../../utilities/utils.ijs'

'rds ns' =: |: smartreadtabular inputfile
ds =: ('up' ; 'down' ; 'forward') i. ('\s' ; '')&rxrplc each { rds

'ups downs forwards' =: +/"1 (0 1 2 ="0 1 ds) # ns

NB. Day 02 Part A solution
day02a =: forwards * downs - ups

aims =: +/\ +/ _1 1 * ns *"(1) 2 {. (0 1 2 ="0 1 ds)
movs =: ns * {: (0 1 2 ="0 1 ds)

depths =: +/ movs * aims
horizs =: +/ movs

NB. Day 02 Part A solution
day02b =: depths * horizs

NB Print answers
echo 'Day 02:'
'  Part A: %d' printf day02a
'  Part B: %d' printf day02b

exit 1
