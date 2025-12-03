sample =: "."0 each cutLF fread 'sample.txt'
input =: "."0 each cutLF fread 'input.txt'

echo +/ > (10 1 +/ . * {.,>./@}.)@(]}.~]i.>./@}:) each input

NB. fib =: (0:`1:`($:@-&1 + $:@-&2)@.(>&0 + >&1))"0 M.

12 ((<:@[ $: ])`(>./@])@.(1=[)) s NB. recurses but just returns the array instead of calcing on it
12 (]}.~]i. [:>./-@[}.]) s NB. returns the "rest"
12 (] (] , i. }. [) [:>./-@[}.]) s
12 (_1&+@[ ; 1&pick@] (] ; [ }.~ 1 + i.) [: >./ -@[}. 1&pick@]) a: , < s NB. idek
NB. The problem is that the recursion requires k, the list, AND the index to start from
