BEGIN {
  FS = ",";

  sampling = 1;
  samplelen = 10;

  # columnname = "pz1";
  column = -1;

  matchindex = 0;
}

NR == 1 {
  for(i = 1; i <= NF; i++) {
    if($i ~ columnname) {
      column = i;
      break;
    }
  }
}

NR > 1 && sampling <= samplelen {
  samples[sampling] = $column;
  sampling++;
}

sampling > samplelen {
  if($column ~ samples[matchindex]) {
    matchindex++;
    if(matchindex >= samplelen) {
      print NR - samplelen;
      exit;
    }
  } else {
    matchindex = 0;
  }
}
