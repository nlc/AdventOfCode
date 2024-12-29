(* Mathematica is so powerful that this feels like cheating *)
(* Invoke with `wolframscript -f b.wl` *)

Print[StringJoin[Riffle[Sort[FindClique[Import["input.graphml"]][[1]]], ","]]]
Exit
