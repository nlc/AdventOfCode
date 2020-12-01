function winnow(localresults, localstr, localrules) {
  print "winnowing", localstr, "with", length(localrules), "rules";
  localnchanges = 0;
  localnewstr = "";
  split(localstr, locallexemes, / /);
  for(localli in locallexemes) {
    locallexeme = locallexemes[localli];
    if(locallexeme in localrules) {
      localnewstr = localnewstr " ( " localrules[locallexeme] " )";
      localnchanges += 1;
    } else {
      localnewstr = localnewstr " " locallexeme;
    }
  }

  print localnchanges, "changes made";
  # ^ EXTREMELY
  # UGLY HACK INCOMING
  localresults["nchanges"] = localnchanges;
  localresults["str"] = gensub(/^ */, "", "g", localnewstr);
}

function countvars(str) {
  varsum = 0;
  split(str, lexemes, / /);
  for(li in lexemes) {
    if(lexemes[li] ~ /^[a-z]+$/) {
      varsum += 1;
    }
  }
  return varsum;
}

BEGIN {
  FS = " -> ";

  operators["AND"] = "\&";
  operators["LSHIFT"] = "<<";
  operators["NOT"] = "~";
  operators["OR"] = "|";
  operators["RSHIFT"] = ">>";
}

/^[^#]/ {
  for(original in operators) {
    gsub(original, operators[original]);
  }

  split($1, lexemes, / /);
  if(length(lexemes) == 1) { # nilad
    nilads[$2] = $1;
  } else if(length(lexemes) == 2) { # monad
    monads[$2] = $1;
  } else if(length(lexemes) == 3) { # dyad
    dyads[$2] = $1;
  }

  # rules[$2] = $1;
}

END {
  str = "a";

  print str;

  nchanges = 1;
  while(nchanges > 0) { # while unresolved variables
    winnow(results, str, nilads);
    nchanges = results["nchanges"];
    str = results["str"];
  }

  nchanges = 1;
  while(nchanges > 0) { # while unresolved variables
    winnow(results, str, monads);
    nchanges = results["nchanges"];
    str = results["str"];

    nchangesn = 1;
    while(nchangesn > 0) { # while unresolved variables
      winnow(results, str, nilads);
      nchangesn = results["nchanges"];
      nchanges += nchangesn;
      str = results["str"];
    }
  }

  nchanges = 1;
  while(nchanges > 0) { # while unresolved variables
    winnow(results, str, dyads);
    nchanges = results["nchanges"];
    str = results["str"];

    nchangesm = 1;
    while(nchangesm > 0) { # while unresolved variables
      winnow(results, str, monads);
      nchangesm = results["nchanges"];
      nchanges += nchangesm;
      str = results["str"];

      nchangesn = 1;
      while(nchangesn > 0) { # while unresolved variables
        winnow(results, str, nilads);
        nchangesn = results["nchanges"];
        nchangesm += nchangesn;
        nchanges += nchangesn;
        str = results["str"];
      }
    }
  }

  print str;
}
