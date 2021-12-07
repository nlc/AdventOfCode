bs =: ". readwords 'boards.txt'        
bs =: 100 5 5 $  bs 

ns =: ". readwords nums.txt             

exec =: 4 : 0
  qq =: bs e."(0 1) 3 {. ns

  5 = +/"1 qq
)
