BEGIN {
  canvasside = 512;
  canvascenter = canvasside / 2;
}

{
  gsub(/_/, "-");
}

/^p$/ {
  print "P1";
  print canvasside, canvasside
  state = "pos";
}

state ~ /^pos$/ && $0 !~ /^[pv]$/ {
  for(i = 1; i <= NF; i++) {
    $i += canvascenter;
  }

  for(y = 0; y < canvasside; y++) {
    for(x = 0; x < canvasside; x++) {
      
    }
  }
}

/^v$/ {
  state = "vel";
}
